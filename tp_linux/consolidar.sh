#!/bin/bash

BASE_DIR="$HOME/EPNro1"
ENTRADA="$BASE_DIR/entrada"
SALIDA="$BASE_DIR/salida"
PROCESADO="$BASE_DIR/procesado"

if [ -z "$FILENAME" ]; then
    export FILENAME="alumnos"
fi

ARCHIVO_SALIDA="$SALIDA/$FILENAME.txt" 
ARCHIVO_LOG="$BASE_DIR/procesado.log"

touch "$ARCHIVO_SALIDA"
touch "$ARCHIVO_LOG"

while true; do
    for archivo in "$ENTRADA"/*.txt; do
        if [ -f "$archivo" ]; then
	    FECHA=$(date "+%d/%m/%Y %H:%M:%S")
	    NOMBRE=$(basename "$archivo")    
	    echo "$FECHA - Procesado archivo $NOMBRE" >> "$ARCHIVO_LOG"
            cat "$archivo" >> "$ARCHIVO_SALIDA"
            mv "$archivo" "$PROCESADO"
            echo "Procesado: $(basename "$archivo")"
        fi
    done
    sleep 5
done
