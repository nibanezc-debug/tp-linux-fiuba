#!/bin/bash

BASE_DIR="$HOME/EPNro1"
ENTRADA="$BASE_DIR/entrada"
SALIDA="$BASE_DIR/salida"
PROCESADO="$BASE_DIR/procesado"

if [ -z "$FILENAME" ]; then
    export FILENAME="alumnos"
fi

ARCHIVO_SALIDA="$SALIDA/$FILENAME.txt"

touch "$ARCHIVO_SALIDA"

while true; do
    for archivo in "$ENTRADA"/*.txt; do
        if [ -f "$archivo" ]; then
            cat "$archivo" >> "$ARCHIVO_SALIDA"
            mv "$archivo" "$PROCESADO"
            echo "Procesado: $(basename "$archivo")"
        fi
    done
    sleep 5
done
