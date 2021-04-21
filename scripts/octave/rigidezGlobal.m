##-----UTN FACULTAD REGIONAL HAEDO----------------* - Octave - *-----------------------------
##     _________    ____________  |    
##    / ____/   |  /  _/  _/  _/  |    CATEDRA ESTRUCTURAS AERONAUTICAS III
##   / __/ / /| |  / / / / / /    |
##  / /___/ ___ |_/ /_/ /_/ /     |    ANALISIS LINEAL DINAMICO
## /_____/_/  |_/___/___/___/     |
##                                |    rigidezGlobal: Calculo de Matriz de Rig. y Masa Global y local
##                                |                     
##---------CICLO LECTIVO 2020----------------------------------------------------------------

function [KG,MG]=rigidezGlobal(ELEMENTO,NODO,GL,codigo)
  
  KG=zeros(GL,GL);

  MG=zeros(GL,GL);

  for u=1:size(ELEMENTO,1)

				% CALCULOS GEOMETRICOS POR ELEMENTO

    nodoI=ELEMENTO(u,1);

    nodoF=ELEMENTO(u,2);

    Ufx=NODO(nodoF,1);
    
    Ufy=NODO(nodoF,2);

    Uix=NODO(nodoI,1);
    
    Uiy=NODO(nodoI,2);

    ladoY=Ufy-Uiy;

    ladoX=Ufx-Uix;
    
    Largo=sqrt(ladoY^2+ladoX^2);

    coseno=ladoX/Largo;

    seno=ladoY/Largo;
    
    
    

				% MATRIZ LOCAL A GLOBAL

    
    switch (codigo)

	   case 1

	     [k,m,T,conectividad]=elementoBarra(ELEMENTO(u,3),ELEMENTO(u,4),Largo,ELEMENTO(u,5),0,coseno,seno,nodoI,nodoF);

	   case 2

	     [k,m,T,conectividad]=elementoVigaPortico(ELEMENTO(u,3),ELEMENTO(u,4),Largo,ELEMENTO(u,5),ELEMENTO(u,6),coseno,seno,nodoI,nodoF);

    endswitch
    
    C=size(conectividad,2);
    
    K=transpose(T)*k*T;

    M=transpose(T)*m*T;
    
    
################# ENSAMBLADO #####################################
    
    for i=1:C

      for j=1:C
	
	KG(conectividad(i),conectividad(j))=KG(conectividad(i),conectividad(j))+K(i,j);

	MG(conectividad(i),conectividad(j))=MG(conectividad(i),conectividad(j))+M(i,j);

      endfor
    endfor
    
  endfor
  
endfunction

  
