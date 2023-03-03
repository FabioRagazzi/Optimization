# Optimization

## 2/3/2023
Oggi mi sono dedicato alla lettura della tesi di dottorato sull'ottimizzazione di Hammoud(Griseri). Ho scoperto che l'algoritmo che hanno valutato migliore è il TRRA (Trust Region Reflective Algorithm). Per implementarlo hanno utilizzato la funzione MATLAB **lsqnonlin**. Procedo quindi ad effettuare qualche prova con questa funzione.  

## 3/3/2023
Parto con l'intenzione di sistemare il lavoro di fitting che avevo fatto per il particle swarm, e utilizzarlo nella nuova forma con il TRRA. Stabilisco fin da subito che lo schema numerico che utilizzerò per la convezione sarà l'upwind del primo ordine. Devo anche scegliere un set di parametri di riferimento che proverò a fittare con il TRRA. Intanto parto col riordinare (eliminando le parti inutili) il codice che serviva per effettuare una simulazione. Sistemo tutto e provo a far partire una simulazione

 
