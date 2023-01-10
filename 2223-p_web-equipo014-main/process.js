//VERSION DE JAVASCRIPT: 1.5

function is_number(texto) {
    var nums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
    for(var i=0; i<texto.length; i++){
        if(!nums.includes(texto[i])){
            return false;
        }
    }
    return true;
 }           

function check_input(){
    const cantidad =document.getElementById("intext");
    const numero =document.getElementById("innumber");
    const opciones =document.getElementById("inopciones");
    cantidad.setCustomValidity("");
    numero.setCustomValidity("");
    opciones.setCustomValidity("");

    if(cantidad.value==""){
        cantidad.setCustomValidity("Debe introducir la cantidad a apostar");
        return false;
    }
    if(numero.value==""){
        numero.setCustomValidity("Debe elegir a qué partido apostar");//necesitamos validar que es todo una cadena de numeros
        return false
    }
    if(opciones.value==""){
        opciones.setCustomValidity("Es necesario que elija a quién apostar");//necesitamos validar que es todo una cadena de numeros
        return false
    }
    var num= parseInt(numero.value);
    if(num<1 || num>10){
        numero.setCustomValidity("Debe introducir un numero entre 1 y 10");
        return false;    
    }
    if(!is_number(String(cantidad.value))){
        cantidad.setCustomValidity("Es necesario que introduzca un numero");
        return false;
    }
    
    return true;

}
function map_opts(x){
    if(x=="opt2"){
        return "empate";
    
    }else if(x=="opt1"){
        return "opcion 1";
    }else{
        return "opcion 2";
    }
}

function check_and_add() { /*Añadir a la lista*/
    const list = document.getElementById("ulist");
    const aviso= document.getElementById("advertise");
    const cantidad =document.getElementById("intext");
    const fecha =document.getElementById("indate");
    const numero =document.getElementById("innumber");
    const opciones =document.getElementById("inopciones");
    if(check_input()){
        var img;
        if(opciones.value=="opt1"){
            img="<li name='anadidos'> <img src='./imagenes/opcion1.png' alt='(foto de opcion1)' height='30'>";
        }else if(opciones.value=="opt3"){
            img="<li name='anadidos'> <img src='./imagenes/opcion2.png' alt='(foto de opcion2)' height='30'>";
        }else{
            img="<li name='anadidos'> <img src='./imagenes/empate.png' alt='(foto de empate)' height='30'>";
        }
       var codeli="<p>"+ img +
        "PARTIDO: " + String(numero.value)+ "<br>" + "APUESTA POR: " + map_opts(opciones.value) + "<br>" +
        "CANTIDAD: " + cantidad.value + " euros<br>";
        if(fecha.value!=""){
            codeli+= " FECHA RECEPCION: " + String(fecha.value)
        }
        codeli+="<br></p></li>";
        list.innerHTML += codeli;
        clear();
        }

}
function clear() { /*Limpiar el formulario*/
    const cantidad =document.getElementById("intext");
    const fecha =document.getElementById("indate");
    const numero =document.getElementById("innumber");
    cantidad.value="";
    fecha.value="";
    numero.value="";

}

function init() {
/*Así no recarga la pagina cada vez que enviamos el formulario*/
    
    const Formulario= document.getElementById("form1");
    Formulario.addEventListener("submit", function(evento){
    evento.preventDefault();})
    

    document.getElementById("insubmit").onclick =check_and_add;
}

window.onload = init;