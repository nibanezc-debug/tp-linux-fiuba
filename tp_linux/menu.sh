#!/bin/bash

BASE_DIR="$HOME/EPNro1"
ENTRADA="$BASE_DIR/entrada"
SALIDA="$BASE_DIR/salida"
PROCESADO="$BASE_DIR/procesado"
PID_FILE="$BASE_DIR/consolidar.pid"

if [ -z "$FILENAME" ]; then
    export FILENAME="alumnos"
fi

ARCHIVO_SALIDA="$SALIDA/$FILENAME.txt"

borrar_entorno() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            kill "$PID"
            echo "Proceso en background finalizado."
        fi
        rm -f "$PID_FILE"
    fi

    rm -rf "$BASE_DIR"
    echo "Entorno borrado."
}

crear_entorno() {
    mkdir -p "$ENTRADA" "$SALIDA" "$PROCESADO"
    touch "$ARCHIVO_SALIDA"

    if [ -f "./consolidar.sh" ]; then
        cp "./consolidar.sh" "$BASE_DIR/consolidar.sh"
        echo "consolidar.sh copiado a $BASE_DIR"
    else
        echo "Advertencia: no se encontró consolidar.sh en la carpeta actual."
    fi

    echo "Entorno creado en $BASE_DIR"
}

correr_proceso() {
    if [ ! -d "$BASE_DIR" ]; then
        echo "Primero debés crear el entorno."
        return
    fi

    if [ ! -f "$BASE_DIR/consolidar.sh" ]; then
        echo "No existe $BASE_DIR/consolidar.sh"
        return
    fi

    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "El proceso ya está corriendo con PID $PID"
            return
        else
            rm -f "$PID_FILE"
        fi
    fi

    bash "$BASE_DIR/consolidar.sh" &
    echo $! > "$PID_FILE"
    echo "Proceso iniciado en background con PID $(cat "$PID_FILE")"
}

mostrar_ordenados() {
    if [ -f "$ARCHIVO_SALIDA" ]; then
        sort -n "$ARCHIVO_SALIDA"
    else
        echo "No existe el archivo $ARCHIVO_SALIDA"
    fi
}

mostrar_top10() {
    if [ -f "$ARCHIVO_SALIDA" ]; then
        awk '{print $NF, $0}' "$ARCHIVO_SALIDA" | sort -k1,1nr | cut -d' ' -f2- | head -10
    else
        echo "No existe el archivo $ARCHIVO_SALIDA"
    fi
}

buscar_padron() {
    if [ ! -f "$ARCHIVO_SALIDA" ]; then
        echo "No existe el archivo $ARCHIVO_SALIDA"
        return
    fi

    read -p "Ingrese número de padrón: " padron
    grep "^$padron " "$ARCHIVO_SALIDA"
}

if [ "$1" = "-d" ]; then
    borrar_entorno
    exit 0
fi

abrir_historial(){
   if [[ -f "$BASE_DIR/procesado.log" ]]; then
	cat "$BASE_DIR/procesado.log"
   else
	echo "No existe el archivo $BASE_DIR/procesado.log"
   fi
}

while true; do
    echo "-----------------------------"
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Mostrar alumnos ordenados por padrón"
    echo "4) Mostrar las 10 notas más altas"
    echo "5) Buscar alumno por padrón"
    echo "6)visualizar historial de procesos"
    echo "7) Salir"
    echo "-----------------------------"

    read -p "Seleccione una opción: " opcion

    case $opcion in
        1) crear_entorno ;;
        2) correr_proceso ;;
        3) mostrar_ordenados ;;
        4) mostrar_top10 ;;
        5) buscar_padron ;;
        6) abrir_historial ;;
	7) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción inválida." ;;
    esac
done
