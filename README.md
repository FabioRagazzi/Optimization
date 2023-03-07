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

Provo anche a lanciare una simulazione usando il particle swarm e calcolando l'errore come nel caso qui sopra.

xv = [-13.2683, 19.5292, 1.0996, -0.6286, -0.9797, -2.4064, 17.9967];
![](figs/2023_03_06/PS_log.png)  

Il risultato è molto buono, il problema sta tutto nel valore del potenziale di estrazione. Se lo metto ad 1(valore esatto) il risultato è ottimo

xv = [-13.2683, 19.5292, 1, -0.6286, -0.9797, -2.4064, 17.9967];
![](figs/2023_03_06/PS_phi_esatto.png)

D'ora in poi calcolerò l'errore come

$$err = \frac{\log_{10}{(J_{objective})} - \log_{10}{(J)}}{\log_{10}{(J_{objective})}}$$

Provo a diminuire la tolleranza della funzione e aumentare il numero di stalliterations

## 7/3/2023
Implemento la possibilità di fare il fitting anche delle number density. Lo provo con il TRRA e i risultati non sono particolarmente belli.  
Ottengo i risultati della simulazione che avevo lanciato con il particle-swarm utilizzando degli intervalli più ampi per i parametri, una "FunctionTolerance" più elevata e anche un numero di "StallIterations" maggiore, e inoltre dando il potenziale di estrazione normalizzato
$$ \varphi_{norm} = \frac{\varphi}{\frac{k_{B}T}{e}} $$

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 |
|-- |--     |--   |--         |-- |-- |-- |--  |
| lower bound  |-16| 18| 0.5| -2| -2| -4| 16 |
| exact  |**-13.3010**| **20.7782**| **1**| **-0.6990**| **-1**| **-2.3979**| **18** |
| upper bound  |-12| 22| 1.5| 1| 1| 1| 20 |
| guessed  |-13.3010| 20.8325| 0.5058| -0.6988| -0.9999| -2.3979| 18.0000 |

| FunctionTolerance | MaxStallIterations | WallClockTime(s) |
|--                 |--                  |--             |
| 1e-6              | 50                 | 12181 = 3h e 23m        |

![](figs/2023_03_07/PS_res.png)  

Se tengo gli stessi valori e cambio solo il potenziale di estrazione, fissandolo a 1 ottengo un fitting ottimo

![](figs/2023_03_07/PS_fisso_io_phi_a_1.png)  

Faccio partire una simulazione in cui fisserò di volta in volta il valore del potenziale di estrazione e cercherò di ottenere i migliori parametri possibili.

Creo uno script per graficare l'errore nel caso in cui cerco di fittare le number density. Quello che osservo è che plottando la densità di carica (imagesc) non si riesce a vedere bene l'errore.  
![](figs/2023_03_07/rho_tot.png)

Provo a fare un confronto allora sulle number density delle specie e così si riesce a vedere un po' meglio. Per questo secondo caso l'errore da mostrare lo calcolo come
$$ err = \frac{|n_{objective} - n|}{n_{objective}} $$
e poi metto a zero quando viene **NaN** (perchè vuol dire che ho fatto $0 / 0$)
![](figs/2023_03_07/number_density.png)

## 8/3/2023
* $\varphi = 0.5$ 

| $\mu$ | n0t | B | D | S | n0 |
|--     |--   |-- |-- |-- |--  |
|-13.4015| 18.2590| 0.9938 |0.7860| -2.3746 |18.0529|

![](figs/2023_03_07/phi_0_5.png)

 
