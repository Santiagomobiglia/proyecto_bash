#!/bin/bash

export FILENAME="Alumnos_info"

if [ "$1" == "-d" ]; then
   echo "Destruyendo el entorno"
   pkill -f "consolidar.sh" 2>/dev/null #pkill busca proccesos por nombre y los mata, y lo que esta al lado sirve para esonder mensajes de error, /dev/null lugar donde va la basura
   rm -rf $HOME/EPNro1/*
   echo "Entorno eliminado y procesos detenidos"
   exit 0
fi

mostrar_menu() {
echo "-----MENU-----"
echo "1 - Crear entorno"
echo "2 - Correr proceso"
echo "3 - Mostrar por pantalla el listado de alumnos contenido ordenados por el numero de padron"
echo "4 - Mostrar las 10 notas mas altas del listado"
echo "5 - Ingrese numero de padron para ver los datos de un alumno"
echo "6 - Salir"
echo "Ejecutar menu.sh con -d como parametro principal para eliminar el entorno y los procesos corriendo en el background."
read -p "seleccione una opcion " opcion
}

dir="$HOME/EPNro1"
archivo_salida="$dir/SALIDA/${FILENAME}.txt"

while true; do #esto es neceario ya que quiero que el menu se repita de forma infinita, hasta que querramos salir con la opcion 6
   mostrar_menu
   case $opcion in
      1)
        #-p crea las subcarpetas automaticamente sin dar error si ya existen
        mkdir -p "$dir/ENTRADA" "$dir/SALIDA" "$dir/PROCESADO"
        cp "$HOME/consolidar.sh" "$dir"
        echo "Entorno creado con exito en $dir"
        ;;
      2)
        if [ -f "$dir/consolidar.sh" ]; then # cone el & e ejecuta el background, nohup sirve para que no muera al cerrar la terminal y > /dev/null 2> hace que no muestre errores
            chmod +x "$dir/consolidar.sh" #le damos permisos de ejecucion al archivo.
            nohup "$dir/consolidar.sh"  >/dev/null 2>&1 & #mandas los mensaje que quiera imprimir el script al agujero negro y luego le decis que haga lo mismo si hay algun mensaeje de error
            echo "Proceso consolidar.sh iniciado en el background"
        else
            echo "Error, el archivo consolidar.sh no esta en $dir."
        fi
        ;;
      3)
        if [ -f "$archivo_salida" ]; then
           echo "---Listado ordenado por padron---"
           sort -k 1,1 -n "$archivo_salida" #el sort te lo ordena y lo imprime ordenado en pantalla, no hace falta el cat
        else
           echo "No se encuentra el archivo $FILENAME.txt"
        fi
        ;;
      4)
        if [ -f "$archivo_salida" ]; then
           echo "---Listado ordenado por nota mas alta---"
           sort -k 5,5 -r -n "$archivo_salida" | head  # | es pipe y agarra todo el listado que ordenamos con sort y se lo da al comando siguiente, en este caso head .n 10 lo que hace es mostrarnos las 10 primeras lineas que le pasaron
        else
           echo "No se encuentra el archivo $FILENAME.txt"
        fi
        ;;
      5)
        if [ -f "$archivo_salida" ]; then
           read -p "ingrese un numero de padron a buscar: " padron
           grep "^$padron " "$archivo_salida" || echo "padron no encontrado" #grep es la herramienta de busqueda, ^sirve simplemente para indicar que el padron esta al comienzao de linea, el espacio al lado de pdron, es porque le decimos que busque el nro de padron seguido de un espacio, grep imprime la fila completa que enccotro  || significa or es decir si falla esta ejecuta esto
        else
           echo  "No se encontro el archivo $FILENAME.txt"
        fi
        ;;
      6)
        echo "Saliendo"
        exit 0
        ;;
      *) #el * sirve para decir en caso de que se escriba cualquier otra cosa
        echo "Esta, opcion es invalida, no esta en el menu, por favor ingrese una opcion valida"
   esac
done


