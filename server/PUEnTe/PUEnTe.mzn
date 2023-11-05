%Analisis y Diseño de algoritmos II - 750020C
%Proyecto 2 - Problema de la Planificacion de Unidades de Energia Termica
%Integrantes:
%  - Mauricio Munoz Gutierrez.
%  - Paul Rodrigo Rojas Guerrero.
%  - Juan Sebastian Getial Getial.
%  - Nicolas Fernando Hueras Cadavid.

%-------------------------------- PARAMETROS --------------------------------------

par int: J;                      %Numero de utpees.
par int: K;                      %Numero de intervalos.
array[1..J] of par float: E;       %Costo de encedido de las utpees.  
array[1..J] of par float: A;     %Costo de apagado de las utpees.
array[1..J] of par 0..1: G;      %Indicador de encendido o apagado de la utpee antes del primer intervalo.
array[1..J] of par float: F;       %Costo fijo de encendido de las utpees.
array[1..J] of par float: V;     %Coeficiente de costo variable de las utpees.
array[1..J] of par float: P_inf;   %Limites inferiores de potencia de las utpees.
array[1..J] of par float: P_sup;   %Limites superiores de potencia de las utpees.
array[1..J] of par float: Sup;     %Limites de ampliacion de potencia de las utpees. 
array[1..J] of par float: Inf;     %Limites de reduccion de potencia de las utpees.  
array[1..J] of par float: P0;      %Potencia generada por las utpees en antes del primer intervalo.
array[1..K] of par float: D;       %Demanda de potencia para cada intervalo.
array[1..K] of par float: R;       %Demanda de reserva para cada intervalo.

par float: M = max(i in 1..J)(P_sup[i]) + 10000;
par float: P_limit = max(i in 1..J)(P_sup[i]) * max(i in 1..J)(V[i]) + 10000;
 
%-------------------------------- VARIABLES --------------------------------------

array[1..K, 1..J] of var int: P;     %Potencias generadas por cada utpee en cada intervalo
array[1..K, 1..J] of var 0..1: Ue;   %Indicador de utpee encendida en cada intervalo
array[1..K, 1..J] of var float: C;   %Costo de cada utpee en cada intervalo
var float: costoTotal;               %Costo total de operacion en el horizonte de planificacion

%------------------------------ RESTRICCIONES ------------------------------------

%No negatividad.
constraint forall(k in 1..K,j in 1..J)(P[k,j] >= 0);
constraint forall(k in 1..K, j in 1..J)(P[k,j] <= P_limit);

%Limites de potencia.
constraint forall(k in 1..K, j in 1..J)(P[k,j] <= 0 + M*Ue[k,j] /\ P[k,j] >= 0 - M*Ue[k,j]);

constraint forall(k in 1..K, j in 1..J)(P[k,j] >= P_inf[j] - M*(1-Ue[k,j])); %Lim inf.
constraint forall(k in 1..K, j in 1..J)(P[k,j] <= P_sup[j] + M*(1-Ue[k,j])); %Lim sup.


%Limitea de reduccion y ampliacion de potencia.
constraint forall(j in 1..J)(P[1,j] <= 0 + M*(1-G[j]) /\ P[1,j] >= 0 - M*(1-G[j]));  %La utpee en el ciclo anterior produce?
constraint forall(j in 1..J)(P0[j] - P[1,j] <= P_inf[j] + M*G[j]);       %Lim reduccion para k=1
constraint forall(j in 1..J)(P[1,j] - P0[j] <= P_sup[j] + M*G[j]);       %Lim ampliacion para k=1

constraint forall(k in 2..K, j in 1..J)(P[k-1,j] <= 0 + M*Ue[k-1,j] /\ P[k-1,j] >= 0 - M*Ue[k-1,j]); %La utpee en el periodo anterior produce?
constraint forall(k in 2..K, j in 1..J)(P[k-1,j] - P[k,j] <= P_inf[j] + M*(1-Ue[k-1,j]));  %Lim reduccion para k>=2
constraint forall(k in 2..K, j in 1..J)(P[k,j] - P[k-1,j] <= P_sup[j] + M*(1-Ue[k-1,j]));  %Lim ampliacion para k>=2

%Demanda de potencia
constraint forall(k in 1..K)(sum(j in 1..J)(P[k,j]) = D[k]);

%Reserva de potencia
constraint forall(k in 1..K)(sum(j in 1..J)(Ue[k,j]*P_sup[j]) >= R[k]+D[k]+1);

%Costo 
constraint forall(j in 1..J)(C[1,j] = 
  if P[1,j] != 0 then  
    E[j]*(1-G[j])+(F[j]+V[j]*P[1,j])
  else
    A[j]*G[j]
  endif 
);

constraint forall(k in 2..K, j in 1..J)(C[k,j] = 
  if P[k,j] != 0 then  
    E[j]*(1-Ue[k-1,j])+(F[j]+V[j]*P[k,j])
  else
    A[j]*(Ue[k-1,j])
  endif
);

constraint costoTotal = sum(k in 1..K, j in 1..J)(C[k,j]);

%------------------------------ RESTRICCIONES ------------------------------------
solve minimize costoTotal;