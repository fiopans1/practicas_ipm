# Diseño software

<!-- ## Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

> :warning: El diseño en un elemento "vivo". No olvideis actualizarlo
> a medida que cambia durante la realización de la práctica.

> :warning: Recordad que el diseño debe separar _vista_ y
> _estado/modelo_.
	 

El lenguaje de modelado es UML y debeis usar Mermaid para incluir los
diagramas dentro de este documento. Por ejemplo:
-->
```mermaid

classDiagram
    class CheatModel {
		+get_list()
	}
	class TextSelector {
		+__init__()
		+add_row()
		+remove_all()
        +get_values()
	}
	class CheatView{
        +Gtk.CssProvider css_provider
		+GLib.idle_add concu
		+Gtk.ApplicationWindow win
		+Gtk.Label label
		+Gtk.Spinner spiner
		+Gtk.Entry	entry
		+Gtk.HeaderBar header
		+List<TextSelector> list
        +Gtk.Label clabel
        +Gtk.Dialog dialog
        +Gtk.Entry entry2
        +Gtk.Button buton_rst
        +Gtk.Button buton_accept
        +List<TextSelector> list_c
        +List<TextSelector> list_d
        +Boolean rst
        +Boolean find
        +Boolean filter
        +Boolean firsttime
		+quit()
		+create_interface()
		+on_row_changes()
		+set_list()
		+info()
		+connect_signals()
		+spinner_control()
		+remove_list()
        +remove_list_g()
		+set_label_text()
		+entry_result()
        +get_values_list()
        +hide_dialog()
        +filter_for_word()
        +set_g_list()
        +restart_default_from_b()
        +restart_default()
        +set_list_t()

	}
	class CheatHandler {
		+__init__()
		+run()
		+on_activate()
		+quit()
		+on_entry_activate()
		+on_entry_activate_in_another_thread()
		+on_row_changes()
        +filter()
        +filter_in_another_thread()
	}
	CheatHandler ..> CheatView 
	CheatHandler ..> CheatModel
    CheatHandler ..> gettext : << uses >>
    CheatHandler ..> locale : << uses >>
    CheatHandler ..> Path : << uses >>

	CheatView "1" --> "1..*" TextSelector
	CheatView ..> Gtk : << uses >>
    CheatView ..> time : << uses >>
    CheatView ..> threading : << uses >>
    CheatView ..> css : << uses >>
    class css
    <<package>> css
	class Gtk
	<<package>> Gtk
    class gettext
	<<package>> gettext
    class locale
	<<package>> locale
    class Path
	<<package>> Path
    <<pakage>> time
    <<pakage>> threading

	
```


```mermaid

sequenceDiagram
    actor User 
    participant View
    participant Handler
    participant Model
    
    
    Handler->>View: create_interface()
    activate Handler
    activate View
    Handler->>View: connect_signals()
    deactivate Handler
    deactivate View
    
    User->>View: "activate [entry]"
    activate User
    activate View
    View->>Handler: on_entry_activate()
    
    activate Handler
    Handler->>Handler: on_entry_activate_in_another_thread()
    alt search
    Handler->>View: spinner_control(1)
    Handler->>View: remove_list_g()
    Handler->>View: set_label_text()
    Handler->>View: entry_result()
    View-->>Handler: Searched
    Handler->>Model: get_list()
    activate Model
    Model-->>Handler: List 
    deactivate Model
    alt Error
        Handler->>View: info()
    else OK
        Handler->>View: set_list()
        Handler->>View: set_g_list()
    end
    Handler->>View: spinner_control(0)
    else !search
        Handler->>View: info()
    end

    deactivate Handler
    deactivate View
    deactivate User

    User->>View: "row-selected"
    activate User
    activate View
    View->>Handler: on_row_changes()
    activate Handler
    Handler->>View: on_row_changes()
    deactivate Handler
    deactivate View
    
    deactivate User

    User->>View: "destroy"
    activate User
    activate View
    View->>Handler: quit()
    activate Handler
    Handler->>View: quit()
    deactivate Handler
    deactivate View
    
    deactivate User


    User->>View: "activate [entry2]" OR "clicked"
    activate User
    activate View
    View->>Handler: filter()
    
    activate Handler
    Handler->>View: hide_dialog()


    alt Search & Filter & firstTime
    Handler->>View: spinner_control(1)
    Handler->>View: get_text()
    View-->>Handler: word
    Handler->>View: get_values_list()
    View-->>Handler: n

    alt word==""
    Handler->>View:restart_default
    else word!=""

    
    
    
    alt comaux=={}
        Handler->>View: info()
    else OK
        Handler->>View: remove_list_g()
    Handler->>View: set_label_text()
    Handler->>View: set_list()
    end

    end
    Handler->>View: spinner_control(0)

    else !Search | !Filter | !firstTime
        Handler->>View: info()
    end
    

    deactivate Handler
    deactivate View
    deactivate User
	
```

