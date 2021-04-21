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
# LECTURA DE VARIABLES DE LABORATORIO - CALCULO DE RANGOS DE EPSILON y VALORES ALFA BETA ASOCIADOS
#--------------------------------------------------------------------------------------------------------------

## CONFIGURACION

clear

warning ('off','OctSymPy:sym:rationalapprox');

pkg load symbolic

syms x t tau

T=linspace(0,0.002,2000);

## DECLARACIONES

markStyle=["+","o","*",".","x","s","d","^","v",">","<","p","h"];

color=["k","r","g","b","m","c","k","r","g","b","m","c"];


## INGRESO DE VALORES

maxEpsilon=0.1;

minEpsilon=0.05;

pasos=100;

frecuenciaReal=11.8;

masterEpsilon=linspace(minEpsilon,maxEpsilon,pasos);

## CARACTERISTICAS DEL MATERIAL

base=15e-3;

altura=1e-3;

E=210000e6;

A=base*altura;

L=240e-3;

RHO=7850;

I=(1/12)*base*altura^3;

g=9.81;

##---- CARACTERISTICAS FISICO-GEOMETRICAS


NODO=[0 0;(L/2) 0;L 0]; % [Xi Yi] en fila i define nodo i

ELEMENTO=[1 2 E A RHO I;2 3 E A RHO I]; % [NodoInicial NodoFinal E A I] en fila i define ubicacion de la viga "i-esima" y sus propiedades

## NODO=[0 0;L 0]; % [Xi Yi] en fila i define nodo i

## ELEMENTO=[1 2 E A RHO I]; % [NodoInicial NodoFinal E A I] en fila i define ubicacion de la viga "i-esima" y sus propiedades

tipoElemento=2;

#########%  CONDICIONES DE CONTORNO Y DESPLAZAMIENTOS ---> G L O B A L E S

f=30;

w=2*pi*f;

acce=0.2*g*sin(w*tau);

Acce=taylor(acce, tau, 0, 'order', 3);

Vel=int(Acce,tau);

Disp=int(Vel,tau);

CCx=[1 0]; % [Nodo Ux] define condicion de contorno en nodo i

CCy=[1 Disp]; % [Nodo Uy] define condicion de contorno en nodo i 

CCw=[1 0]; % [Nodo Wz] define condicion de contorno en nodo i 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  SCRIPT 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

barra=2; # Grados de libertad por nodo 

vigaPortico=3;

matrizElementos=[barra;vigaPortico]; # El orden vertical de los componentes indica su codigo

GL=size(NODO,1)*matrizElementos(tipoElemento); % Cant. de grados de libertad globales

[KG,MG]=rigidezGlobal(ELEMENTO,NODO,GL,tipoElemento);

##[Px]=cargaEquivalente(KG,MG,CCx,CCy,CCw,GL,tipoElemento);

[KG,MG]=condContorno(KG,MG,CCx,CCy,CCw,GL,tipoElemento); % Aplicacion de las condiciones de contorno

GLNN=size(KG,1);

########### AUTOVECT/AUTOVALORES -->  W2  ###############

[phi,w2]=eig(inv(MG)*KG);

frecuenciasNaturales=sort(sqrt(w2)/(2*pi)*ones(GLNN,1));

printf("\nTotal %d Frecuencias Naturales:\n\n",GLNN)

printf("%d Hz\n",frecuenciasNaturales)

########## MATRIZ DE AMORTIGUAMIENTO POR METODO DE RAYLEIGH #######

velocidadAngular=sort(sqrt(w2)*ones(GLNN,1));

keyboard

alfa=zeros(pasos,1);

beta=zeros(pasos,1);

for i=1:pasos
    
  [C,alfa(i),beta(i)]=amortiguamientoRayleigh(1,velocidadAngular(1),velocidadAngular(2),masterEpsilon(i),masterEpsilon(i),MG,KG);

endfor


####### DATOS DE LAB-VIEW #############

aster=dlmread('./ensayoLaboratorio.dat',';',0,0);

figure (1);clf;hold on;grid on;

title ('MASTER LABORATORIO')

plot(aster(:,6),aster(:,2),["--" markStyle(2) color(2) ";Corta;"]);

plot(aster(:,6),aster(:,3),["--" markStyle(3) color(3) ";Larga Medio;"]);

plot(aster(:,6),aster(:,4),["--" markStyle(4) color(4) ";Larga Extremo;"]);

plot(aster(:,6),aster(:,5),["--" markStyle(5) color(5) ";ac control;"]);

hold off

## ####### COMPARACION LAB-VIEW CON MODELO #############


## Simul=dlmread('./plotFreq.resu',',',0,0);

## figure (2);clf;hold on;grid on;

## title ('AJUSTE MODELO')

## plot(aster(:,6),aster(:,3),["--" markStyle(4) color(4) ";Laboratorio SG central;"]);

## plot(Simul(:,1),-Simul(:,3),["--" markStyle(4) color(2) ";Simulacion Nodo central;"]);

## plot(aster(:,6),aster(:,4),["--" markStyle(5) color(5) ";Laboratorio SG extremo;"]);

## plot(Simul(:,1),abs(Simul(:,5)),["--" markStyle(5) color(3) ";Simulacion Nodo extremo;"]);

## hold off


####### IMPRESION #############

numFrec=find(aster(:,6)==frecuenciaReal);

matrixA=[aster(numFrec,5) aster(numFrec,3) aster(numFrec,4) frecuenciasNaturales(1) frecuenciaReal];

matrixB=[alfa beta masterEpsilon'];

save "./resultados/matrixA.dat" matrixA

save "./resultados/matrixB.dat" matrixB
