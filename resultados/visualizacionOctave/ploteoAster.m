#!/bin/bash
#-------------------------------------------------------------------------------------------------------------
# __/\\\______________/\\\\\\\\\\\\_____/\\\\\\\\\\\\\\\_                          
#  _\/\\\_____________\/\\\////////\\\__\/\\\///////////__                LABORATORIO DE ESTRUCTURAS 
#   _\/\\\_____________\/\\\______\//\\\_\/\\\_____________               
#    _\/\\\_____________\/\\\_______\/\\\_\/\\\\\\\\\\\_____         
#     _\/\\\_____________\/\\\_______\/\\\_\/\\\///////______    
#      _\/\\\_____________\/\\\_______\/\\\_\/\\\_____________   
#       _\/\\\_____________\/\\\_______/\\\__\/\\\_____________  
#        _\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\/___\/\\\\\\\\\\\\\\\_ 
#         _\///////////////__\////////////_____\///////////////__
#--------------------------------------------------------------------------------------------------------------
# PLOTEO DE RESULTADOS CODE ASTER
#--------------------------------------------------------------------------------------------------------------

## CONFIGURACION

clear

warning ('off','OctSymPy:sym:rationalapprox');

## DECLARACIONES

markStyle=["+","o","*",".","x","s","d","^","v",">","<","p","h"];

color=["k","r","g","b","m","c","k","r","g","b","m","c"];

####### DATOS DE LAB-VIEW #############

lab=dlmread('./ensayoLaboratorio.dat',';',0,0);

figure (1);clf;hold on;grid on;

title ('MASTER LABORATORIO')

plot(lab(:,6),lab(:,2),["--" markStyle(2) color(2) ";Corta;"]);

plot(lab(:,6),lab(:,3),["--" markStyle(3) color(3) ";Larga Medio;"]);

plot(lab(:,6),lab(:,4),["--" markStyle(4) color(4) ";Larga Extremo;"]);

plot(lab(:,6),lab(:,5),["--" markStyle(5) color(5) ";ac control;"]);

hold off

# ####### DATOS TRANSITORIO ASTER #############

# aster=dlmread('./resuAster.resu',',',0,0);

# figure (2);clf;hold on;grid on;

# title ('CODE ASTER 14.51hz')

# plot(aster(:,1),aster(:,2),["--" markStyle(2) color(2) ";N2;"]);

# plot(aster(:,1),aster(:,3),["--" markStyle(3) color(3) ";N3;"]);

# hold off

####### ANALISIS HARMONICO ASTER ############

Simul=dlmread('./plotFreq.resu',',',0,0);

figure (3);clf;hold on;grid on;

title ('AJUSTE MODELO')


plot(lab(:,6),lab(:,3),["--" markStyle(2) color(2) ";Laboratorio SG Medio;"]);

plot(Simul(:,1),abs(Simul(:,3)),["--" markStyle(4) color(4) ";Simulacion SG Medio;"]);

plot(lab(:,6),lab(:,4),["--" markStyle(2) color(3) ";Laboratorio SG Extremo;"]);

plot(Simul(:,1),abs(Simul(:,5)),["--" markStyle(4) color(5) ";Simulacion SG Extremo;"]);


hold off

