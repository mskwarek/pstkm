set CENTRAL;
set T;
set D;  #Zapotrzebowania
set N := CENTRAL union D union T;                     #Wezly
set L := (N cross N);      #Polaczenia logiczne pomiedzy wezlami
set C;                     #Grubosc kabla
set P within (N cross N);  #Sciezki - polaczenia fizyczne miedzy wezlami

				    
param hd {D} >= 0;         #zapotrzebowanie aka liczba wlokien
param M >= 0;		   #zysk jednostkowy z realizacji 1 zapotrzebowania
param hc {C} >= 0;         #koszt polozenia kabla danego typu
param TC {P};
param NU >= 0;             #koszt umieszczenia cabinetu

				  
param ae {n in N, (i,j) in L} binary :=	    	# ae - wykłady - konieczne do kirchhoffa
      if (i = n) then 1
    else 0; 
param be {n in N, (i,j) in L} binary :=		# be - wyklady - konieczne do kirchhoffa
      if (j = n) then 1
    else 0; 

#Kirchhoff dla modelu "fizycznego"			 
param ape {n in N, (i,j) in P} binary :=	    	# ae - wykłady - konieczne do kirchhoffa
      if (i = n) then 1
    else 0; 
param bpe {n in N, (i,j) in P} binary :=		# be - wyklady - konieczne do kirchhoffa
      if (j = n) then 1
    else 0; 


var Xed {(i, j) in L, k in CENTRAL, l in D, m in C} binary;       #zapotrzebowania na polaczeniu
var XXed {(i, j) in P, (k,l) in L, m in C} binary;       #zapotrzebowania na polaczeniu
var d_served {k in CENTRAL, l in D} binary;    		#zmienna binara - realizowane zapotrzebowania

var hpd {L};
subject to Demand{(i,j)in L}:
        hpd[i,j] = sum{k in CENTRAL, l in D, m in C}Xed[i,j,k,l,m]*m;

param sum_d := sum{l in D} hd[l];
subject to usage_l{(i,j) in L, m in C}:
	(sum {k in CENTRAL,l in D} Xed[i,j,k,l,m]*m) <= sum_d;

var cables{P, C} binary;
subject to Demand_on_edge{(i,j) in P, m in C}:
        (cables[i,j,m]*m) >= (sum{(k,l) in L}XXed[i,j,k,l,m]*m);

var is_cable_used{(i,j) in P} binary;
subject to path_exists{(i,j) in P, m in C}:
	cables[i,j,m] <= is_cable_used[i,j]*sum_d;

param path_counter = card(P);
var is_cabinet{N} binary;
subject to cabinet_needed{n in T}:
        sum{(i,j) in P, m in C} (ape[n,i,j]+bpe[n,i,j])*cables[i,j,m]*m <= path_counter*is_cabinet[n];


maximize Profit:       	  			#f. celu
	 sum{k in CENTRAL ,l in D}(d_served[k,l] * M * hd[l])
	-sum{(i,j) in P, m in C}(cables[i,j,m]*hc[m])
        -(sum{n in N}is_cabinet[n])*NU
	-sum{(i,j) in P}is_cable_used[i,j]*TC[i,j]
;

subject to Kirchhoff{n in N, k in CENTRAL, l in D}:
	(sum {(i, j) in L, m in C} ae[n,i,j]*Xed[i,j,k,l,m]*m)
	- (sum {(i,j) in L, m in C} be[n,i,j]*Xed[i,j,k,l,m]*m) =
	(if n = k then hd[l]*d_served[k,l] else if n = l then - hd[l]*d_served[k,l] else 0);

subject to Kirchhoff_Paths{n in N, (k,l) in L}:
	(sum {(i, j) in P, m in C} ape[n,i,j]*XXed[i,j,k,l,m]*m)
	- (sum {(i,j) in P, m in C} bpe[n,i,j]*XXed[i,j,k,l,m]*m) =
        (if n = k then hpd[k,l] else if n = l then - hpd[k,l] else 0);



				    



