%Analisis y Diseño de algoritmos II - 750020C
%Proyecto 2 - Problema de la Planificacion de Unidades de Energia Termica
%Integrantes:
%  - Mauricio Munoz Gutierrez.
%  - Paul Rodrigo Rojas Guerrero.
%  - Juan Sebastian Getial Getial.
%  - Nicolas Fernando Hueras Cadavid.

%-------------------------------- PARAMETROS --------------------------------------
par int: J;                  %Numero de utpees.
par int: K;                  %Numero de intervalos.
array[1..J] of int: E;       %Costo de encedido de las utpees.  
array[1..J] of float: A;     %Costo de apagado de las utpees.
array[1..J] of 0..1: G;      %Indicador de encendido o apagado de la utpee antes del primer intervalo.
array[1..J] of int: F;       %Costo fijo de encendido de las utpees.
array[1..J] of float: V;     %Coeficiente de costo variable de las utpees.
array[1..J] of int: P_inf;   %Limites inferiores de potencia de las utpees.
array[1..J] of int: P_sup;   %Limites superiores de potencia de las utpees.
array[1..J] of int: Sup;     %Limites de ampliacion de potencia de las utpees. 
array[1..J] of int: Inf;     %Limites de reduccion de potencia de las utpees.  
array[1..J] of int: P0;      %Potencia generada por las utpees en antes del primer intervalo.
array[1..K] of int: D;       %Demanda de potencia para cada intervalo.
array[1..K] of int: R;       %Demanda de reserva para cada intervalo.

par float: P_max = max(i in 1..J)(P_sup[i]);  %Cota superior de la potencia, se puede ver como M.
%-------------------------------- VARIABLES --------------------------------------
array[1..K+1, 1..J] of var int: P;         %Potencias generadas por cada utpee en cada intervalo, incluye k=0.
array[1..K+1, 1..J] of var bool: Op;       %Indicador de utpee encendida en cada intervalo, incluye k=0.
array[1..K, 1..J] of var bool: amp;        %Indicador de ampliacion de potencia dentro de los limites.
array[1..K, 1..J] of var bool: red;        %Indicador de reduccion de potencia dentro de los limites.
array[1..K, 1..J] of var bool: encendido;  %Indica si la utpee j se ha encendido en el intervalo k. 
array[1..K, 1..J] of var bool: apagado;    %Indica si la utpee j se ha apagado en el intervalo k.
array[1..K, 1..J] of var float: C;         %Costo de cada utpee en cada intervalo.
var float: costoTotal;                     %Costo total de operacion en el horizonte de planificacion.
%------------------------------ RESTRICCIONES ------------------------------------
%Si k=0, Op_jk = G_j y P_jk = P0_j
constraint forall(j in 1..J)(Op[1,j] = G[j]);
constraint forall(j in 1..J)(P[1,j] = P0[j]);

%Restricciones de encendido
constraint forall(k in 2..K+1, j in 1..J where Op[k-1,j] = 0 /\ Op[k,j] = 1)(encendido[k-1,j] = 1);
%constraint forall(k in 2..K+1, j in 1..J where Op[k-1,j] = 1 \/ Op[k,j] = 0)(encendido[k-1,j] = 0);

%Restricciones de apagado
constraint forall(k in 2..K+1, j in 1..J where Op[k-1,j] = 1 /\ Op[k,j] = 0)(apagado[k-1,j] = 1);
%constraint forall(k in 2..K+1, j in 1..J where Op[k-1,j] = 0 \/ Op[k,j] = 1)(apagado[k-1,j] = 0);

%Restricciones de operatividad.  
constraint forall(k in 2..K+1, j in 1..J where P[k,j] > 0)(Op[k,j] = 1); 
constraint forall(k in 2..K+1, j in 1..J where apagado[k-1,j] = 1)(Op[k,j] = 0);             

%No negatividad
constraint forall(k in 1..K+1, j in 1..J)(P[k,j] >= 0);

%Cota superior
constraint forall(k in 1..K+1, j in 1..J)(P[k,j] <= P_max);

%Limites de produccion
constraint forall(k in 2..K+1, j in 1..J)(P[k,j] <= P_sup[j]+P_max*(1-Op[k,j]));
constraint forall(k in 2..K+1, j in 1..J)(P[k,j] >= P_inf[j]-P_max*(1-Op[k,j]));

%Limites de ampliacion
constraint forall(k in 2..K+1, j in 1..J)(amp[k-1,j] = (P[k,j] - P[k-1,j] <= Sup[j]));
constraint forall(k in 2..K+1, j in 1..J)((1-Op[k,j]) + (1-Op[k-1,j]) + amp[k-1,j] >= 1);

%Limites de reduccion.
constraint forall(k in 2..K+1, j in 1..J)(red[k-1,j] = (P[k,j] - P[k-1,j] >= -Inf[j]));
constraint forall(k in 2..K+1, j in 1..J)((1-Op[k,j]) + (1-Op[k-1,j]) + red[k-1,j] >= 1);

%Demanda de potencia
constraint forall(k in 2..K+1)(sum(j in 1..J)(P[k,j]) = D[k-1]);

%Reserva de potencia
constraint forall(k in 2..K+1)(sum(j in 1..J)(Op[k,j]*P_sup[j]) >= D[k-1]+R[k-1]);

%Costo por cada utpee en cada periodo.
constraint forall(k in 2..K+1, j in 1..J )(C[k-1,j] = E[j]*encendido[k-1,j]+F[j]*Op[k,j]+V[j]*P[k,j]+A[j]*apagado[k-1,j]);

%Costo total
constraint costoTotal = sum(k in 1..K, j in 1..J)(C[k,j]);
%------------------------------ FUNCION OBJETIVO ---------------------------------
solve minimize costoTotal;