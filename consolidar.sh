#!/bin/bash

while true; do

 for archivo in "$HOME/EPNro1/ENTRADA"/*.txt;
   do
      if [ -f "$archivo" ]; then
         cat "$archivo" >> "$HOME/EPNro1/SALIDA/${FILENAME}.txt"
         mv "$archivo" "$HOME/EPNro1/PROCESADO/"
      fi
   done
sleep 2
done

