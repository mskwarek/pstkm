set N;                     #Wezly
set L := (N cross N);      #Polaczenia logiczne pomiedzy wezlami
set D within (N cross N);  #Zapotrzebowania
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


var Xed {(i, j) in L, (k,l) in D, m in C} binary;       #zapotrzebowania na polaczeniu
var XXed {(i, j) in P, (k,l) in L, m in C} binary;       #zapotrzebowania na polaczeniu
var d_served {(k,l) in D} binary;    		#zmienna binara - realizowane zapotrzebowania

var hpd {L};
subject to Demand{(i,j)in L}:
        hpd[i,j] = sum{(k,l) in D, m in C}Xed[i,j,k,l,m]*m;

var cables{P};# >= 0;
subject to Demand_on_edge{(i,j) in P}:
        cables[i,j] = sum{(k,l) in L, m in C}XXed[i,j,k,l,m]*m;
        #cables >=0;
        #minimize cables;

var is_cabinet{N} binary;
subject to cabinet_needed{n in N}:
        is_cabinet[n] = if(sum{(i,j) in P}ape[n,i,j] - sum{(i,j) in P}bpe[n,i,j])>0 then 1 else 0;

maximize Profit:       	  			#f. celu
	 sum{(k,l) in D}(d_served[k,l] * M * hd[k,l])
	-sum{(i,j) in P}(cables[i,j]*3)
        -(sum{n in N}is_cabinet[n]-1)*NU
;

subject to Kirchhoff{n in N, (k,l) in D}:
	(sum {(i, j) in L, m in C} ae[n,i,j]*Xed[i,j,k,l,m]*m)
	- (sum {(i,j) in L, m in C} be[n,i,j]*Xed[i,j,k,l,m]*m) =
	(if n = k then hd[k,l]*d_served[k,l] else if n = l then - hd[k,l]*d_served[k,l] else 0);

subject to Kirchhoff_Paths{n in N, (k,l) in L}:
	(sum {(i, j) in P, m in C} ape[n,i,j]*XXed[i,j,k,l,m]*m)
	- (sum {(i,j) in P, m in C} bpe[n,i,j]*XXed[i,j,k,l,m]*m) =
        (if n = k then hpd[k,l] else if n = l then - hpd[k,l] else 0);

param sum_d := sum{(k,l) in D} hd[k,l];
subject to usage_l{(i,j) in L, m in C}:
	(sum {(k,l) in D} Xed[i,j,k,l,m]*m) <= sum_d;




				    



