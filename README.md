# Optimization

## 2/3/2023
Oggi mi sono dedicato alla lettura della tesi di dottorato sull'ottimizzazione di Hammoud(Griseri). Ho scoperto che l'algoritmo che hanno valutato migliore è il TRRA (Trust Region Reflective Algorithm). Per implementarlo hanno utilizzato la funzione MATLAB **lsqnonlin**. Procedo quindi ad effettuare qualche prova con questa funzione.  

## 3/3/2023
Parto con l'intenzione di sistemare il lavoro di fitting che avevo fatto per il particle swarm, e utilizzarlo nella nuova forma con il TRRA. Stabilisco fin da subito che lo schema numerico che utilizzerò per la convezione sarà l'upwind del primo ordine. Devo anche scegliere un set di parametri di riferimento che proverò a fittare con il TRRA. Intanto parto col riordinare (eliminando le parti inutili) il codice che serviva per effettuare una simulazione. Sistemo tutto e provo a far partire una simulazione  
* la prima che ho lanciato ha finito in 10 secondi e ha dato come risultato lo stesso che avevo messo come punto di partenza, dicendo che era stata raggiunta l'accuratezza limite
* Cambiando il punto di partenza cambia il risultato:  
x0 = [-15,   19,  1.1,    0,    0,   -3,   19];
![](figs/2023_03_06/starting_point_1.png)
x0 = [-14,   19,  1.1,    0,    0,   -3,   19];
![](figs/2023_03_06/starting_point_2.png)
* Il fitting non è perfetto ed è randomico, il caso qui sotto aveva lo stesso punto di partenza di quello sopra, ma i parametri ottenuti sono leggermente diversi 
![](figs/2023_03_03/fit_TRRA.png)

## 6/3/2023
Provo a fare una simulazione in cui la normalizzazione viene effettuata facendo 
$$err = \frac{J_{objective} - J}{J}$$
mentre prima veniva effettuata facendo
$$err = \frac{J_{objective} - J}{J_{objective}}$$
x0 = [-14,   19,  1.1,    0,    0,   -3,   19];
![](figs/2023_03_06/norm_dividing_by_J.png)  

Poi provo a fare una simulazione in cui il vettore errore viene calcolato come
$$err = \frac{\log{(J_{objective})} - \log{(J)}}{\log{(J_{objective})}}$$
![](figs/2023_03_06/norm_with_log.png)

 
