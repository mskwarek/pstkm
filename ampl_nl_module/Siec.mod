#Sets
set CENTRAL;						#Wezel centralny (zbior jednoelementowy)
set TRANSPORT_NODE;					#Zbior wezlow transportowych
set DEMAND;  						#Zapotrzebowania
set CABLE_TYPE;                     #Zbior grubosci kabla

set NODES := CENTRAL union DEMAND union TRANSPORT_NODE;   #Wszystkie wezly w naszej topologii sieci
set L := (NODES cross NODES);      			#Polaczenia logiczne pomiedzy wezlami

set EDGE within (NODES cross NODES);  			#Zbior sciezek - polaczen fizycznych miedzy wezlami

#Params	    
param hd {DEMAND} >= 0;         		#zapotrzebowanie aka liczba wlokien 
param M0 >= 0;		   			#zysk jednostkowy z realizacji 1 zapotrzebowania
param hc {CABLE_TYPE} >= 0;         		#koszt polozenia kabla danego typu
param TRENCHING_COST {EDGE};					#trenching cost kabla
param CABINET_COST >= 0;             		#stala definujaca koszt umieszczenia cabinetu w wezle transportowym
param fiber_s {CABLE_TYPE} >= 0;
						       
#parametry originates/terminates dla modelu "logicznego"				  
param ae {n in NODES, (i,j) in L} binary :=	    		# ae - wykłady - konieczne do kirchhoffa
      if (i = n) then 1
    else 0; 
param be {n in NODES, (i,j) in L} binary :=				# be - wyklady - konieczne do kirchhoffa
      if (j = n) then 1
    else 0; 

#parametry originates/terminates dla modelu "fizycznego"			 
param ape {n in NODES, (i,j) in EDGE} binary :=	    	# ae - wykłady - konieczne do kirchhoffa
      if (i = n) then 1
    else 0; 
param bpe {n in NODES, (i,j) in EDGE} binary :=			# be - wyklady - konieczne do kirchhoffa
      if (j = n) then 1
    else 0; 

param path_counter = card(EDGE);						# suma wszystkich krawedzi w modelu fizycznym
	
var Xed {(i, j) in L, k in CENTRAL, l in DEMAND} >= 0;				#zapotrzebowania na polaczeniu w modelu logicznym 
var XXed {(i, j) in EDGE, (k,l) in L, m in CABLE_TYPE} binary;						#zapotrzebowania na polaczeniu w modelu fizycznym
var d_served {k in CENTRAL, l in DEMAND} binary;    							#realizowane zapotrzebowania - zmienna binarna
var hpd {L} >= 0;

var is_cabinet{NODES} binary;
var cables{(i,j) in EDGE, m in CABLE_TYPE} binary;

maximize Profit:       	  							#f. celu
	 sum{k in CENTRAL ,l in DEMAND}(d_served[k,l] * M0 * hd[l])
	-sum{(i,j) in EDGE, (k,l) in L, m in CABLE_TYPE}(XXed[i,j,k,l,m]*hc[m])
	-(sum{n in NODES}is_cabinet[n])*CABINET_COST
	-sum{(i,j) in EDGE, (k,l) in L, m in CABLE_TYPE}XXed[i,j,k,l,m]*TRENCHING_COST[i,j]
;


subject to Kirchhoff{n in NODES, k in CENTRAL, l in DEMAND}:
	(sum {(i, j) in L} ae[n,i,j]*Xed[i,j,k,l])
	- (sum {(i,j) in L} be[n,i,j]*Xed[i,j,k,l]) =
	(if n = k then hd[l]*d_served[k,l] else if n = l then - hd[l]*d_served[k,l] else 0);


subject to Kirchhoff_Paths{n in NODES, (k,l) in L}:
	(sum {(i,j) in EDGE, m in CABLE_TYPE} ape[n,i,j]*XXed[i,j,k,l,m]*fiber_s[m])
	- (sum {(i,j) in EDGE, m in CABLE_TYPE} bpe[n,i,j]*XXed[i,j,k,l,m]*fiber_s[m]) >=
        (if n = k then hpd[k,l]
	  else if n = l then - hpd[k,l]
				  else 0);

subject to debug{(i,j) in EDGE, m in CABLE_TYPE}:
	cables[i,j,m] = sum{(k,l) in L}XXed[i,j,k,l,m];

# suma zapotrzebowan na krawedzi musi byc wieksza niz suma logicznych polaczen
subject to demand{(i,j)in L, k in CENTRAL}:
          hpd[i,j] >= sum{l in DEMAND}(Xed[i,j,k,l]); 

subject to one_cable_on_link{(i,j) in EDGE}:
        sum{(k,l) in L, m in CABLE_TYPE}XXed[i,j,k,l,m] <= 1;

subject to cabinet_needed{n in TRANSPORT_NODE}:
        sum{(i,j) in EDGE, (k,l) in L, m in CABLE_TYPE} (ape[n,i,j]-bpe[n,i,j])*XXed[i,j,k,l,m] <= path_counter*is_cabinet[n];
