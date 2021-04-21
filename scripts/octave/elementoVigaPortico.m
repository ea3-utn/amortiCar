##-----UTN FACULTAD REGIONAL HAEDO----------------* - Octave - *-----------------------------
##     _________    ____________  |    
##    / ____/   |  /  _/  _/  _/  |    CATEDRA ESTRUCTURAS AERONAUTICAS III
##   / __/ / /| |  / / / / / /    |
##  / /___/ ___ |_/ /_/ /_/ /     |    ANALISIS LINEAL DINAMICO
## /_____/_/  |_/___/___/___/     |
##                                |    elementoVigaPortico: Matrices Caracteristicas
##                                |                     
##---------CICLO LECTIVO 2020----------------------------------------------------------------

function [k,m,T,conectividad]=elementoVigaPortico(E,A,L,R,I,cos,sin,nodoI,nodoF)

  
  
  kfunc= @(E,A,L,I) [(A*E)/L 0 0 -(A*E)/L 0 0;0 (12*E*I)/L^3 (6*E*I)/L^2 0 -(12*E*I)/L^3 (6*E*I)/L^2;0 (6*E*I)/L^2 (4*E*I)/L 0 -(6*E*I)/L^2 (2*E*I)/L;-(A*E)/L 0 0 (A*E)/L 0 0;0 -(12*E*I)/L^3 -(6*E*I)/L^2 0 (12*E*I)/L^3 -(6*E*I)/L^2;0 (6*E*I)/L^2 (2*E*I)/L 0 -(6*E*I)/L^2 (4*E*I)/L];

  Tfunc= @(cos,sin) [cos sin 0 0 0 0;-sin cos 0 0 0 0;0 0 1 0 0 0;0 0 0 cos sin 0;0 0 0 -sin cos 0;0 0 0 0 0 1];

  mfunc= @(E,A,L,R) ((R*A*L)/420)*[140 0 0 70 0 0;0 156 22*L 0 54 -13*L;0 22*L 4*L^2 0 13*L -3*L^2;70 0 0 140 0 0;0 54 13*L 0 156 -22*L;0 -13*L -3*L^2 0 -22*L 4*L^2];

  conectividad=[3*nodoI-2 3*nodoI-1 3*nodoI 3*nodoF-2 3*nodoF-1 3*nodoF];

  k=kfunc(E,A,L,I);

  m=mfunc(E,A,L,R);

  T=Tfunc(cos,sin);
  
endfunction

  
