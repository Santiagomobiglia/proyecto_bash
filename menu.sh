#!/bin/bash

export FILENAME="Alumnos_info"

if [ "$1" == "-d" ]; then
   echo "Destruyendo el entorno"
   pkill -f "consolidar.sh" 2>/dev/null
   rm -rf $HOME/EPNro1
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

while true; do
   mostrar_menu
   case $opcion in
      1)
        mkdir -p "$dir/ENTRADA" "$dir/SALIDA" "$dir/PROCESADO"
        cp "$HOME/consolidar.sh" "$dir"
        echo "Entorno creado con exito en $dir"
        ;;
      2)
        if [ -f "$dir/consolidar.sh" ]; then
            chmod +x "$dir/consolidar.sh"
            nohup "$dir/consolidar.sh"  >/dev/null 2>&1 &
            echo "Proceso consolidar.sh iniciado en el background"
        else
            echo "Error, el archivo consolidar.sh no esta en $dir."
        fi
        ;;
      3)
        if [ -f "$archivo_salida" ]; then
           echo "---Listado ordenado por padron---"
           sort -k 1,1 -n "$archivo_salida"
        else
           echo "No se encuentra el archivo $FILENAME.txt"
        fi
        ;;
      4)
        if [ -f "$archivo_salida" ]; then
           echo "---Listado ordenado por nota mas alta---"
           sort -k 5,5 -r -n "$archivo_salida" | head
        else
           echo "No se encuentra el archivo $FILENAME.txt"
        fi
        ;;
      5)
        if [ -f "$archivo_salida" ]; then
           read -p "ingrese un numero de padron a buscar: " padron
           grep "^$padron " "$archivo_salida" || echo "padron no encontrado"
        else
           echo  "No se encontro el archivo $FILENAME.txt"
        fi
        ;;
      6)
        echo "Saliendo"
        exit 0
        ;;
      *)
        echo "Esta, opcion es invalida, no esta en el menu, por favor ingrese una opcion valida"
   esac
done


