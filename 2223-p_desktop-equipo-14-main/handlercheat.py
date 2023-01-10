#!/usr/bin/env python3
import gi
import viewcheat
from viewcheat import CheatView
import modelcheat
import gettext
import locale
from pathlib import Path
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, GLib
#con cada llamada al view durante una operacion entre las que interactuan el model
#y el view, llamaremos a concu para que la parte del view se ejecute en el thread
#principal mientras que las operaciones del model se hagan en el secundario
_ = gettext.gettext
N_ = gettext.ngettext
class CheatHandler:
    def __init__(self,model,view):#constructor
        self.model=model
        self.view=view
        self.app=Gtk.Application()
    def run(self):#arranca la aplicacion
        self.app.connect('activate',self.on_activate)
        self.app.run()
    def on_activate(self,app : Gtk.Application):#activa las interfaces y las señales
        self.view.create_interface(self.app)
        self.view.connect_signals(self)
    def quit(self,widget):#cierra la app
        self.view.quit()
    def on_entry_activate(self,widget):
        if(self.view.search):
            self.view.search=False
            self.view.filter=False
            self.view.rst=False
            self.view.spinner_control(1)
            self.view.remove_list_g()#elimina todo
            self.view.set_label_text("", "")
            t = viewcheat.Thread(target=self.on_entry_activate_in_another_thread)#para que la funcion se ejecute en otro hilo
            t.start()
        else:
            self.view.info(_("UNABLE TO PERFORM THE ACTION"),"")
    def on_entry_activate_in_another_thread(self): #actualiza la listbox
        nicesearch=True
        searched=self.view.entry_result() #como nos tiene que devolver un valor el view no podemos hacerla concu
        if(searched!=''):
            try:
                list=model.get_list(searched)
                if(list==[]):
                    CheatView.concu(self.view.info,_("ERROR"), _("No results for your search"))
                    nicesearch=False
                else:
                    i=0
                    clist={}
                    dlist={}
                    for item in list:#metemos los items en la cosa
                        description=item.description#podriamos crear nuestro propio formato en 
                        if (item.commands==''):
                            command=searched
                        else:
                            command=item.commands
                        if(description==''):
                            description=_('NO DESCRIPTION FOR THIS COMMAND')
                        clist[i]=command
                        dlist[i]=description
                        i+=1
                    CheatView.concu(self.view.set_list_t,clist,dlist)
                    self.view.filter=True
            except Exception:
                CheatView.concu(self.view.info,_("NO CONECTION"),_("Please check your internet connection"))
                nicesearch=False                        
        CheatView.concu(self.view.spinner_control,0)  
        self.view.search=True
        if(nicesearch):
            self.view.firstTime= True
    def on_row_changes(self,widget,row):#cuando clicas sobre una columna
        if(self.view.list.caniselect):
            self.view.on_row_changes(widget,row)
    def filter(self, widget):
        self.view.hide_dialog()
        if(self.view.search & self.view.filter & self.view.firstTime):
            self.view.search=False
            self.view.filter=False
            self.view.rst=True
            self.view.spinner_control(1)
            word=self.view.entry2.get_text()
            com,des,n=self.view.get_values_list()
            comaux={}
            desaux={}
            naux=0
            if(word==""):
                self.view.restart_default()
            else:
                for i in range(0,len(com)):
                    if(word==com[i]):
                        comaux[naux]=com[i]
                        desaux[naux]=des[i]
                        naux+=1
                if (comaux!={}):
                    
                    self.view.remove_list()
                    self.view.set_label_text("", "")
                    for i in range(0,len(comaux)):
                        self.view.set_list(desaux[i],comaux[i])
                else:
                    self.view.info(_('SEARCH ERROR'),_('The command you were looking for was not found'))
            self.view.spinner_control(0)
            self.view.search=True
            self.view.filter=True       
        else:
            self.view.info(_("UNABLE TO PERFORM THE ACTION"),"")
            self.view.search=True


if __name__ == "__main__":
    mytextdomain='CheatApp'
    locale.setlocale(locale.LC_ALL, '')
    # The i18n files should be copied to ./locale/LANGUAGE_CODE/LC_MESSAGES/
    LOCALE_DIR = Path(__file__).parent / "locale"
    locale.bindtextdomain(mytextdomain, LOCALE_DIR)
    gettext.bindtextdomain(mytextdomain, LOCALE_DIR)
    gettext.textdomain(mytextdomain)
    
    view = CheatView()
    model = modelcheat.CheatModel()
    controller = CheatHandler(model, view)
    controller.run() 