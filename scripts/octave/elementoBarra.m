##-----UTN FACULTAD REGIONAL HAEDO----------------* - Octave - *-----------------------------
##     _________    ____________  |    
##    / ____/   |  /  _/  _/  _/  |    CATEDRA ESTRUCTURAS AERONAUTICAS III
##   / __/ / /| |  / / / / / /    |
##  / /___/ ___ |_/ /_/ /_/ /     |    ANALISIS LINEAL DINAMICO
## /_____/_/  |_/___/___/___/     |
##                                |    elementoBarra: Matrices Caracteristicas y Condiciones de contorno
##                                |                     
##---------CICLO LECTIVO 2020----------------------------------------------------------------

function [k,m,T,conectividad]=elementoBarra(E,A,L,R,FLAG,cos,sin,nodoI,nodoF)

  kfunc= @(E,A,L) (E*A/L)*[1 -1;-1 1];    
  
  Tfunc= @(cos,sin) [cos sin 0 0;0 0 cos sin];
    
  if FLAG==1
    
    mfunc= @(E,A,L,R) (R*A*L)*[1/2 0;0 1/2];

  else
    
    mfunc= @(E,A,L,R) (R*A*L)*[1/3 1/6;1/6 1/3];

  endif
 
  conectividad=[2*nodoI-1 2*nodoI 2*nodoF-1 2*nodoF;];

  k=kfunc(E,A,L);

  m=mfunc(E,A,L,R);

  T=Tfunc(cos,sin);
  
endfunction

  
