#!/usr/bin/env python3

import gi
import gettext
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, GLib, Gio , Gdk

from time import sleep
from threading import Thread

_ = gettext.gettext
N_ = gettext.ngettext

class TextSelector(Gtk.ListBox):
    """ Selector base class """

    def __init__(self):
        Gtk.ListBox.__init__(self)
        # Setup the listbox
        self.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self._rows = {}
        self._crows = {}
        self.ndx = 0
        self.caniselect =True 
        #a veces se queda una descripcion seleccionada y entraba el la funcion on_row_changes al borrar,
        #para solucionar este problema haremos un control de estado

    def add_row(self, description, command): #añad una columna, el markup es el comando y el name el description
        """ Add a named row to the selector with at given icon name"""
        # get the image
        label = Gtk.Label()
        label.set_text(command)
        label.set_wrap(True)
        # set the widget size request to 32x32 px, so we get some margins
        # label.set_size_request(100, 24)
        label.set_single_line_mode(True)
        label.set_halign(Gtk.Align.START)
        label.set_hexpand(True)
        label.set_xalign(0)
        label.set_margin_start(5)
        label.set_margin_end(10)
        row = self.append(label)
        # store the index names, so we can find it on selection
        self._rows[self.ndx] = description
        self._crows[self.ndx] = command
        self.ndx += 1
    def remove_all(self): #borra toda la list
        list={}
        i=0
        self.caniselect=False #bloqueamos actualizacion
        for item in self:
            list[i]=item
            i+=1
        for item in range(0,i):#OJITO!!!!
            self.remove(list[item])
        self.ndx=0
        self._rows={}  
        self._crows={} 
        self.caniselect=True  #desbloqueamos actualizacion   
    def get_values(self):
        return self._crows,self._rows,self.ndx

class CheatView:
    css_provider = Gtk.CssProvider()
    css_provider.load_from_file(Gio.File.new_for_path("./styles.css"))
    Gtk.StyleContext.add_provider_for_display(Gdk.Display.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
    concu = GLib.idle_add #para concurrencia
    win: Gtk.ApplicationWindow=None
    label : Gtk.Label= None
    spinner : Gtk.Spinner = None
    entry : Gtk.Entry = None
    list : TextSelector = None
    header : Gtk.HeaderBar = None
    clabel : Gtk.Label = None
    dialog : Gtk.Dialog = None
    entry2 : Gtk.Entry = None
    buton_rst : Gtk.Button = None
    buton_accept : Gtk.Button = None
    #para poder volver a la list inicial
    list_c = None
    list_d = None
    #booleanos de control
    rst= False
    search= True
    filter = True
    firstTime= False
    def quit(self):#cierra la app
        self.win.destroy()
    def create_interface(self,app:Gtk.Application): #crea la interfaz
        #creamos la ventana
        self.win=Gtk.ApplicationWindow(title=_("CHEAT.SH"))
        self.win.set_default_size(1000,800)
        self.win.present()#podría ir en otro metodo
        #añadimos ventana
        app.add_window(self.win)
        #creamos la cabecera
        self.header=Gtk.HeaderBar()
        self.win.set_titlebar(self.header)
        #creamos la caja de descripcion
        box= Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.win.set_child(box)
        #creamos un frame
        frame=Gtk.Frame()
        frame.set_size_request(width=300,height=300)
        frame.set_valign(Gtk.Align.FILL)
        frame.set_vexpand(True)
        frame.set_hexpand(True)
        frame.set_margin_start(20)
        frame.set_margin_end(20)
        frame.set_margin_top(10)
        frame.set_margin_bottom(10)
        #creamos el buscador
        self.entry=Gtk.SearchEntry()
        self.entry.set_halign(Gtk.Align.FILL)
        self.entry.set_valign(Gtk.Align.END)
        self.entry.set_margin_top(20)
        self.entry.set_margin_start(20)
        self.entry.set_margin_end(20)
        #self.entry.set_text("Type here...")
        #scrollwindow
        scroll= Gtk.ScrolledWindow()
        scroll.set_propagate_natural_width(True)
        scroll.set_min_content_width(300)
        #creamos el label de las descripciones
        self.label=Gtk.Label()
        self.label.set_text("")
        label1 = Gtk.Label()
        label1.set_text(_("COMMANDS:"))
        self.clabel = Gtk.Label()
        self.clabel.set_text("")
        label2 = Gtk.Label( )
        label2.set_text(_("DESCRIPTIONS:"))
        boxLabel=Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        boxLabel.append(label1)
        boxLabel.append(self.clabel)
        boxLabel.append(label2)
        boxLabel.append(self.label)
        #creamos el listbox
        self.list= TextSelector()
        #creamos el spinner
        self.spinner=Gtk.Spinner()
        #metemos los contenedores en contenedores y este en ventana
        self.header.pack_start(self.entry)
        self.header.pack_start(self.spinner)
        scroll.set_child(self.list)
        frame.set_child(boxLabel)
        box.append(scroll)
        box.append(frame)
        #creamos la entry2, del CTRL+F que se va a cambiar
        self.entry2=Gtk.Entry()
        self.entry2.set_halign(Gtk.Align.FILL)
        self.entry2.set_valign(Gtk.Align.END)
        self.entry2.set_margin_top(20)
        self.entry2.set_margin_start(20)
        self.entry2.set_margin_end(20) 
        #boton de reset de la list:
        self.buton_rst= Gtk.Button(label=_("Reset"))
        self.buton_rst.connect('clicked', self.restart_default_from_b)
        #creamos el dialog de filtrar
        self.dialog=Gtk.Dialog(           
            transient_for= self.win,
            modal= True)       
        
        box2= Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing= 7) #el vertical
        box3= Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, homogeneous=True) #para los botones
        
        buton_cancel = Gtk.Button(label= (_("Cancel")))
        self.buton_accept = Gtk.Button(label= (_("Accept")))
        box3.append(buton_cancel)
        box3.append(self.buton_accept)
        
        label_info= Gtk.Label()
        label_info.set_text(_("FIlter for command:"))
        box2.append(label_info)
        box2.append(self.entry2)
        box2.append(box3)
        self.dialog.connect('response', self.hide_dialog_2)
        buton_cancel.connect('clicked', self.hide_dialog_d)
        
        self.dialog.set_child(box2)
        
        buton = Gtk.Button(label= (_("Filter")))
        buton.connect('clicked', self.filter_for_word)
        self.header.pack_start(buton)
        self.header.pack_start(self.buton_rst)
    def on_row_changes(self, widget, row): #para cuando seleccionas una fila
        ndx = row.get_index()
        self.clabel.set_text(widget._crows[ndx])
        self.label.set_text(widget._rows[ndx])
        
    def set_list(self,description,command):#le mete una columna al listbox
        self.list.add_row(description,command)
        
    def info(self, text : str, stext : str):#saca un mensaje de informacion con el texto que indiques
        dialog = Gtk.MessageDialog(
            transient_for= self.win,
            modal= True,
            message_type= Gtk.MessageType.INFO,
            buttons= Gtk.ButtonsType.OK,
            text= text,
            secondary_text= stext
        )

        dialog.connect('response', lambda d, _: d.destroy())
        dialog.show()
        
    def connect_signals(self, handler):#conecta todos los signals
        self.win.connect('destroy', handler.quit)
        self.entry.connect('activate', handler.on_entry_activate)
        self.list.connect('row-selected', handler.on_row_changes)
        self.entry2.connect('activate', handler.filter)
        self.buton_accept.connect('clicked', handler.filter)
    def spinner_control(self, mode):#activa y desactiva el spinner
        if (mode==1):
            self.spinner.start()
        else:
            self.spinner.stop()    
    def remove_list(self):#borra toda la list
        self.list.remove_all()
    def remove_list_g(self):
        self.list.remove_all()
        self.list_c= {}
        self.list_d={}    
    def set_label_text(self,ctext : str, text : str):#cambiar el texto del label de la derecha
        self.clabel.set_text(ctext)
        self.label.set_text(text)
    def entry_result(self):#obtiene el texto de la entrada
        return self.entry.get_text()
    def get_values_list(self):
        return self.list.get_values()
    def hide_dialog_2(self,widget, id):
        if(id==Gtk.ResponseType.DELETE_EVENT):
            self.dialog.hide()
    def hide_dialog_d(self, widget):
        self.dialog.hide()
    def hide_dialog(self):
        self.dialog.hide()
    def filter_for_word(self,widget):#se puede llegar a eliminar
        self.dialog.show()
    def set_g_list(self):
        for i in range(0,len(self.list._crows)):
            self.list_c[i] = self.list._crows[i]
            self.list_d[i] = self.list._rows[i]
    def restart_default_from_b(self,widget):
        self.restart_default()
    def restart_default(self):
        if(self.rst):
            self.remove_list()
            for i in range(0,len(self.list_c)):
                self.list.add_row(self.list_d[i],self.list_c[i])

    def set_list_t(self,clist, dlist):
        for i in range(0,len(clist)):
            self.set_list(dlist[i], clist[i])
        self.set_g_list()
