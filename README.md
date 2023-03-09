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

Wall Clock Time = 3404 s

![](figs/2023_03_08/phi_0_5.png)

&nbsp; 

&nbsp;

* $\varphi = 0.75$ 

| $\mu$ | n0t | B | D | S | n0 |
|--     |--   |-- |-- |-- |--  |
|-13.3011| 20.8562| -0.6990 | -0.9999| -2.3979 |18.0000|

Wall Clock Time = 7569 s

![](figs/2023_03_08/phi_0_75.png)

&nbsp; 

&nbsp;

* $\varphi = 1$ 

| $\mu$ | n0t | B | D | S | n0 |
|--     |--   |-- |-- |-- |--  |
|-13.3010| 20.7787| -0.6990 | -1.0000| -2.3979 |18.0000|

Wall Clock Time = 14696 s

![](figs/2023_03_08/phi_1.png)

&nbsp; 

&nbsp;

* $\varphi = 1.25$ 

| $\mu$ | n0t | B | D | S | n0 |
|--     |--   |-- |-- |-- |--  |
|-13.3011| 20.8543| -0.6990 | -0.9999| -2.3979 |18.0000|

Wall Clock Time = 8963 s

![](figs/2023_03_08/phi_1_25.png)

&nbsp; 

&nbsp;

* $\varphi = 1.5$ 

| $\mu$ | n0t | B | D | S | n0 |
|--     |--   |-- |-- |-- |--  |
|-13.3011| 20.8703| -0.6991 | -1.0000| -2.3979 |18.0000|

Wall Clock Time = 10781 s

![](figs/2023_03_08/phi_1_5.png)

&nbsp; 

&nbsp;

Mi accorgo che avevo scritto la funzione obiettivo in una maniera tale per cui il valore di $\varphi$ era sempre fissato al valore giusto e i tentativi di modifica del PS(particle swarm) erano inefficaci. Correggo tale aspetto e lancio una nuova simulazione

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 |
|-- |--     |--   |--         |-- |-- |-- |--  |
| lower bound  |-16| 18| 0.5| -2| -2| -4| 16 |
| exact  |**-13.3010**| **20.7782**| **1**| **-0.6990**| **-1**| **-2.3979**| **18** |
| upper bound  |-12| 22| 1.5| 1| 1| 1| 20 |
| guessed  |-13.3013| 21.9969| 1.0000| -0.6991| -0.9997| -2.3968| 18.0003 |

| FunctionTolerance | MaxStallIterations | WallClockTime(s) |
|--                 |--                  |--             |
| 1e-6              | 50                 | 16080 = 4h e 28m        |

![](figs/2023_03_08/good_fit.png)

Si vede che il particle swarm è stato molto bravo a fare il fit. L'unico valore che è diverso da quelli esatti è il valore della densità iniziale di trappole. Controllo e verifico che effettivamente il valore di tale parametro influenza poco il fitting

Vedo a parità di problema che cosa ottengo utilizzando il **TRRA** (correggo anche qui l'errore relativo alla non rilevanza del valore di $\varphi$)

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 |
|-- |--     |--   |--         |-- |-- |-- |--  |
| lower bound  |-16| 18| 0.5| -2| -2| -4| 16 |
| exact  |**-13.3010**| **20.7782**| **1**| **-0.6990**| **-1**| **-2.3979**| **18** |
| upper bound  |-12| 22| 1.5| 1| 1| 1| 20 |
| initial guess | -14 | 19 | 1.1 | 0 | 0 | -3 | 19 |
| guessed  |-13.4805| 19.0891| 1.0453| -0.0209| -0.0252| -3.2900| 18.0640 |

| FunctionTolerance | OptimalityTolerance | WallClockTime(s) |
|--                 |--                  |--             |
| 1e-6              | 1e-6                 | 132 = 2m 12s    |

![](figs/2023_03_08/godd_fit_with_TRRA.png)

Il risultato con il TRRA non è altrettanto bello, ma ha il vantaggio che ci mette 2 minuti contro 4 ore e mezza. Lo svantaggio è che occorre dargli un punto di partenza. Ora provo a fargli fare uno swipe di punti di partenza e vedere se trova delle belle soluzioni con tutti quanti. Prendo 11 punti nell'intervallo di ricerca tra "lower bound" e "upper bound", il primo corrisponde ai valori di "lower bound" e l'undicesimo corrisponde ai valori di "upper bound". Nella tabella sotto riporto i valori dei parametri trovati per ogni punto di partenza e il corrispondente tempo di simulazione

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 | WallClockTime(s) |
|-- |--     |--   |--         |-- |-- |-- |--  |--                |
| #1  |-15.0521| 21.9994| 1.3488| -2.0000| 0.9927| -1.6929| 19.8905 | 110 |
| #2  |-13.7688| 19.6215| 0.9803| -1.7340| -0.7647| -1.9544| 18.1863 | 206 |
| #3  |-14.3044| 18.6844| 1.3037| -1.5070| -1.2044| -1.1258| 17.5855 | 54 |
| #4  |-13.5613| 18.4901| 0.9680| -1.1268| -1.0439| -1.3199| 18.1837 | 63 |
| #5  |-13.6049| 19.9784| 0.9997| -0.9889| -0.7097| -2.5412| 18.0487 | 65 |
| #6  |-13.5188| 19.8481| 1.0058| -0.5853| -0.5179| -2.4820| 18.0743 | 58 |
| #7  |-13.5023| 21.0258| 1.0189| -0.2705| -0.2111| -2.2225| 18.0881 | 56 |
| #8  |-13.1998| 20.8002| 1.1999| 0.1005| 0.1001| -1.9003| 18.8000 | 52 |
| #9  |-12.7999| 21.2002| 1.3000| 0.4000| 0.4000| -1.6000| 19.2000 | 38 |
| **#10**  |||||||||
| **#11**  |||||||||
 
 Stranamente la simulazione #10 con il TRRA sembra bloccarsi (pare che non converga). Per quanto riguarda la 11 ricevo un messaggio di errore (non si possono usare lower o upper bound come punto di partenza, eppure la simulzione #1 era andata). Rinuncio ad effettuare queste ultime due simulazioni dato che le altre nove sono sufficienti

![](figs/2023_03_08/span_TRRA.png)

Quello che si vede da questo grafico è che la bontà del fit è molto dipendente dal punto di partenza che si da all'algoritmo TRRA.

Lancio una nuova simulazione con il particle swarm, questa volta essendo meno stringente con le MaxStallIterations e la FunctionTolerance, per verificare se riesco ad ottenere comunque una buona accuratezza in un tempo inferiore

| FunctionTolerance | MaxStallIterations | WallClockTime(s) |
|--                 |--                  |--                |
| 1e-3              | 20                 |  4525 = 1h 15m   |

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 |
|-- |--     |--   |--         |-- |-- |-- |--  |
| lower bound  |-16| 18| 0.5| -2| -2| -4| 16 |
| exact  |**-13.3010**| **20.7782**| **1**| **-0.6990**| **-1**| **-2.3979**| **18** |
| upper bound  |-12| 22| 1.5| 1| 1| 1| 20 |
| guessed | -13.3252 | 21.6320 | 0.9976 | -0.7015 | -0.9720 | -2.3212 | 18.0181 |

![](figs/2023_03_09/PS_blando.png)

Si riesce ad ottenere una buona accuratezza anche in un tempo inferiore (poco più di un ora) usando il PS.

&nbsp;

&nbsp;

A questo punto provo a fare il fitting della famosa corrente di polarizzazione di Paolo Seri utilizzando il particle swarm. 

| FunctionTolerance | MaxStallIterations | WallClockTime(s) |
|--                 |--                  |--                |
| 1e-3              | 20                 |  5097 = 1h 23m   |

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 |
|-- |--     |--   |--         |-- |-- |-- |--  |
| lower bound  |-16| 19| 0.5| -4| -4| -4| 16 |
| upper bound  |-12| 25| 1.5| 2| 2| 2| 20 |
| guessed | -13.7661 | 19.0018 | 0.50000 | -4.0000 | 0.2812 | -4.0000 | 20.0000 |

![](figs/2023_03_09/fit_Seri.png)
Il risultato non è granchè, molti parametri sono in corrispondenza dei limiti, vuol dire che per ottenere un fitting migliore dovrei cambiare i lower e gli upper bound

&nbsp;

&nbsp;

Provo allora ad usare il TRRA utilizzando diversi valori di x0 (punto di partenza). 
![](figs/2023_03_09/parametri_TRRA_1.png)
L'ultima colonna della matrice qui sopra corrisponde ai tempi in secondi.
![](figs/2023_03_09/TRRA_Seri.png)
Vorrei fare 11 fit, ma arrivato al 5 ottengo un errore che mi dice che i lower e gli upper bound non sono supportati con funzioni complesse. Provo allora a togliere i lower e gli uper bound che davo alla funzione lsqnonlin (li tengo come riferimento per selezionare i vari punti di partenza). Anche in questo caso non riesco a concludere le simulazioni perchè ad un certo punto ottengo una matrice con numero di condizionamento uguale a NaN. Non riesco neanche a plottare i primi 4 (ed unici) fit che avevo ottenuto perchè le ODE si fermano a causa della riduzione eccessiva del passo temporale 


