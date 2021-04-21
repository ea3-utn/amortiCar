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
# Script Analisis: analisis.sh | Script para adecuar el analisis armonico completo con los valores alfa y beta elegidos
#--------------------------------------------------------------------------------------------------------------
#
# ---  DECLARACIONES ---

declare -rx codeAster="/home/nico/codeAster/bin/as_run"

declare -r dirOctave="./resultados/visualizacionOctave/"

declare -r dirAster="./resultados/analisisHarmonicoCompleto/"

declare -r masterAster=${dirAster}"/archivosMaster/master.comm"

declare -r runAster=${dirAster}"programaArmonico.comm"

declare -r resuAster=${dirAster}"/resultados/plotFreq.resu"

declare -r masterResultados="./resultados/resultadosIteracion.dat"

# ---     DATOS A INGRESAR POR EL USUARIO     ---

alfa="0.000249799847839577"

beta="13.1204618542458"

cargaArmonica="0.209426"

# ---     SCRIPT     ---

data=$(echo $PWD | tr '/' '!')

cat ${dirAster}"/archivosMaster/exportMaster"  | sed "s/DIRECTORIO_TRABAJO/${data}/" | tr '!' '/' >${dirAster}"/export" 


cp "./scripts/octave/ensayoLaboratorio.dat" ${dirOctave}

cp "./scripts/codeAster/_malla.med" ${dirAster}


cat ${masterAster} | sed "s/masterAlfa/${alfa}/" | sed "s/masterBeta/${beta}/"  | sed "s/cargaArmonica/${cargaArmonica}/"  >${runAster}

${codeAster} ${dirAster}"/export" 
