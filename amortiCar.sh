#!/bin/bash
#-------------------------------------------------------------------------------------------------------------
#
# __/\\\______________/\\\\\\\\\\\\_____/\\\\\\\\\\\\\\\_                          
#  _\/\\\_____________\/\\\////////\\\__\/\\\///////////__                LABORATORIO DE ESTRUCTURAS 
#   _\/\\\_____________\/\\\______\//\\\_\/\\\_____________               
#    _\/\\\_____________\/\\\_______\/\\\_\/\\\\\\\\\\\_____         
#     _\/\\\_____________\/\\\_______\/\\\_\/\\\///////______    
#      _\/\\\_____________\/\\\_______\/\\\_\/\\\_____________   
#       _\/\\\_____________\/\\\_______/\\\__\/\\\_____________  
#        _\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\/___\/\\\\\\\\\\\\\\\_ 
#         _\///////////////__\////////////_____\///////////////__
#
#--------------------------------------------------------------------------------------------------------------
# Script Principal: amorCar.sh | Script para la caracterizar el amortiguamiento por el metodo iterativo
#--------------------------------------------------------------------------------------------------------------
#
# ---  DECLARACIONES ---

declare -rx codeAster="/home/nico/codeAster/bin/as_run"

declare -r dirOctave="./scripts/octave/resultados/"

declare -r dirAster="./scripts/codeAster/"

declare -r cargaArmonica=$(cat ${dirOctave}"matrixA.dat" | tail -n +6 | awk '{print $1}' | head -1)

declare -r acceMedia=$(cat ${dirOctave}"matrixA.dat" | tail -n +6 | awk '{print $2}' | head -1)

declare -r acceLarga=$(cat ${dirOctave}"matrixA.dat" | tail -n +6 | awk '{print $3}' | head -1)

declare -r frecuencia=$(cat ${dirOctave}"matrixA.dat" | tail -n +6 | awk '{print $4}' | head -1)

declare -r frecuenciaReal=$(cat ${dirOctave}"matrixA.dat" | tail -n +6 | awk '{print $5}' | head -1)

declare -r iteraciones="/tmp/iteraciones.dat"

declare -r masterAster=${dirAster}"/archivosMaster/master.comm"

declare -r runAster=${dirAster}"programaAster.comm"

declare -r resuAster=${dirAster}"/resultados/harmonic.resu"

declare -r masterResultados="./resultados/resultadosIteracion.dat"

# ---     CONSISTENCIA  ---

if test ! -x "$codeAster" ;then
    printf "\n$SCRIPT:$LINENO: El programa de simulacion no se encuentra disponible--> ABORTANDO\n\n" >&2
    exit 192
fi


# ---     FUNCIONES     ---

function aster() {

    ${codeAster} ${dirAster}/export
    
}     


function escrituraResultado() {

    reglaCortaResu=$(cat ${resuAster} | tail -n +16 | sed '/^.N/d' | sed '/^.$/d' | head -1)

    reglaLargaResu=$(cat ${resuAster} | tail -n +16 | sed '/^.N/d' | sed '/^.$/d' | tail -n +2)

    echo "${cargaArmonica};${frecuenciaReal};${acceMedia};${acceLarga};${frecuencia};${epsilon};${alfa};${beta};${reglaCortaResu};${reglaLargaResu}" | sed 's/E/e/g' | tr '.' ',' >>${masterResultados}
    
}     


function errorAster() {

    echo "Error en proceso de simulacion"

    exit 1

}     

function acondicionarDirectoriosAster() {

    data=$(echo $PWD | tr '/' '!')
  
    cat ${dirAster}"/archivosMaster/exportMaster"  | sed "s/DIRECTORIO_TRABAJO/${data}/" | tr '!' '/' >${dirAster}"/export" 

}     


# ---     SCRIPT     ---

acondicionarDirectoriosAster

echo "Ca;FrecuenciaReal;acceCorta;acceLarga;FrecuenciaSimul;epsilon;alfa;beta;N2;N3" >${masterResultados}

cat ${dirOctave}"matrixB.dat" | tail -n +6 | sed '/^$/d' >${iteraciones}

while read line;do

    alfa=$(echo ${line} | awk '{print $1}' | head -1)
    
    beta=$(echo ${line} | awk '{print $2}' | head -1)

    epsilon=$(echo ${line} | awk '{print $3}' | head -1)

    cat ${masterAster} | sed "s/masterAlfa/${alfa}/" | sed "s/masterBeta/${beta}/"  | sed "s/masterCarga/${cargaArmonica}/"  | sed "s/masterFrecuencia/${frecuencia}/" >${runAster}
    
    (aster && escrituraResultado) || errorAster 
    
done<${iteraciones}



