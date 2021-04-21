##-----UTN FACULTAD REGIONAL HAEDO----------------* - Octave - *-----------------------------
##     _________    ____________  |    
##    / ____/   |  /  _/  _/  _/  |    CATEDRA ESTRUCTURAS AERONAUTICAS III
##   / __/ / /| |  / / / / / /    |
##  / /___/ ___ |_/ /_/ /_/ /     |    ANALISIS LINEAL DINAMICO
## /_____/_/  |_/___/___/___/     |
##                                |    condContorno: Aplicacion de CC
##---------CICLO LECTIVO 2020----------------------------------------------------------------

function [KG,MG]=condContorno(KG,MG,CCx,CCy,CCw,GL,codigo)

  switch (codigo)

	 case 1

	   CONDICIONES=double(sort([2*CCx(:,1)-1;2*CCy(:,1)]));
	   
	 case 2

	   if (isempty(CCw)==0)
	   
	     CONDICIONES=double(sort([3*CCx(:,1)-2;3*CCy(:,1)-1;3*CCw(:,1)]));

	   else

	     CONDICIONES=double(sort([3*CCx(:,1)-2;3*CCy(:,1)-1]));

	   endif
	   
	     
  endswitch
  
  CONDICIONES( ~any(CONDICIONES,2), : ) = [];
  
  MAX=size(CONDICIONES,1);
  
  for i=0:(MAX-1)
    
    MG(:,CONDICIONES(MAX-i))=[];

    MG(CONDICIONES(MAX-i),:)=[];
    
    KG(:,CONDICIONES(MAX-i))=[];

    KG(CONDICIONES(MAX-i),:)=[];

  endfor
    
  % Remover filas nulas
  MG( all(~MG,2), : ) = [];
  KG( all(~KG,2), : ) = [];
  
  % Remover columnas nulas
  KG( :, all(~KG,1) ) = [];
  MG( :, all(~MG,1) ) = [];
  
endfunction


