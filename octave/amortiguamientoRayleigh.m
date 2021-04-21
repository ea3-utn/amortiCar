##-----UTN FACULTAD REGIONAL HAEDO----------------* - Octave - *-----------------
##     _________    ____________  |    
##    / ____/   |  /  _/  _/  _/  |    CATEDRA ESTRUCTURAS AERONAUTICAS III
##   / __/ / /| |  / / / / / /    |
##  / /___/ ___ |_/ /_/ /_/ /     |    AMORTIGUAMIENTO DE RAYLEIGH
## /_____/_/  |_/___/___/___/     |
##                                |    : crea la matriz C por el metodo de Rayleigh
##---------CICLO LECTIVO 2020----------------------------------------------------

# Clough & Penzien - Dynamics of structures - Pag.256

function [C,alfa,beta]=amortiguamientoRayleigh(FLAG,wn,wm,en,em,M,K)
  
  constantes= @(Wn,Wm,En,Em) ((2*Wm*Wn)/(Wn^2-Wm^2))*[Wn -Wm;(-1/Wn) (1/Wm)]*[Em;En];

  numerica=constantes(wn,wm,en,em);alfa=numerica(2);beta=numerica(1);

  C=alfa*[M]+beta*[K];

  if (FLAG==1)

    printf("\nCoeficientes de la matriz de amortiguamiento de Rayleigh:\n\n",alfa)

    printf("alfa=%d \n",alfa)

    printf("beta=%d \n",beta)

  else

    C=zeros(size(K));

    alfa=0;beta=0;
    
    printf("\nSistema no amortiguado\n",alfa)
    
  endif

endfunction

  
