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

## 9/3/2023
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
Vorrei fare 11 fit, ma arrivato al 5 ottengo un errore che mi dice che i lower e gli upper bound non sono supportati con funzioni complesse. Provo allora a togliere i lower e gli uper bound che davo alla funzione lsqnonlin (li tengo come riferimento per selezionare i vari punti di partenza). Anche in questo caso non riesco a concludere le simulazioni perchè ad un certo punto ottengo una matrice con numero di condizionamento uguale a NaN. Non riesco neanche a plottare i primi 4 (ed unici) fit che avevo ottenuto perchè le ODE si fermano a causa della riduzione eccessiva del passo temporale.

Lancio una simulazione in cui anche $\varepsilon_{r}$ viene tenuta come parametro.

## 10/3/2023

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 | $\varepsilon_{r}$ |
|-- |--     |--   |--         |-- |-- |-- |--  |--                 |
| lower bound  |-16| 19| 0.5| -8| -4| -8| 16 |  0.5  |
| upper bound  |-12| 25| 1.5| 2| 2| 2| 22 | 6 |
| guessed | -15.9569 | 21.6586 | 0.50000 | -1.1056 | 0.7763 | -7.7562 | 21.1404 | 0.5000 |

| FunctionTolerance | MaxStallIterations | WallClockTime(s) |
|--                 |--                  |--                |
| 1e-6              | 50                 |  3972 = 1h 6m   |

![](figs/2023_03_10/fit_Seri_PS.png)

**fitness function = 11.3755**

Anche in questo caso i risulti sono abbastanza brutti. Concludo che sia necessario modificare/migliorare il modello

Sono andato a recuperare i parametri dei due fit che avevo fatto a mano:

|   | L | $\Delta V$ | $\mu$ | n0t | $\varphi$ | $B_{h}$ | $B_{e}$ | $D_{h}$ | $D_{e}$ | $S_{0}$ | $S_{1}$ | $S_{2}$ | $S_{3}$ | n0 | $\varepsilon_{r}$ |
|-- |-- |--          |--     |--   |--         |--       |--       |--       |--       |--       |--       |--       |--       |--  |--                 |
| Fit a mano #1 | 4e-4 | 12e3 | 9e-15 | 1e24 | 0.65 | 2e-1 | 1e-1 | 1e-1 | 5e-2 | 4e-3 | 4e-3 | 4e-3 | 0 | 4e21 | 4 |
| Fit a mano #2 | 3e-4 | 9e3 | 1e-12 | 1e25 | 1 | 2 | 1 | 1e-2 | 5e-3 | 4e-3 | 4e-3 | 4e-3 | 0 | 1e20 | 4 |

![](figs/2023_03_10/fit_1_a_mano.png)

![](figs/2023_03_10/fit_2_a_mano.png)

I parametri erano stati scelti quando si faceva la stima della corrente di conduzione al centro delle interfacce, in quel caso la somiglianza era maggiore.

Nel caso del Fit #1 vengono dei valori di corrente di polarizzazione negativi **!!!**  
Facendo una simulazione con gli stessi parametri del "fit a mano 1" con un codice che avevo fatto in precedenza ottengo una corrente che non diventa negativa. Andando a vedere le number density vedo che in entrambi i casi ce ne sono di negative, ce ne sono molte di più nel caso in cui la corrente non diventa negativa (mi aspetterei il contrario) -> mi viene voglia di fare un full esplicito

Nel frattempo lancio una simulazione in cui ho ristretto l'ampiezza dei bounds(attorno al fit non tanto bello di un po' di tempo fa) e mantengo sempre $\varepsilon_{r}$ variabile

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 | $\varepsilon_{r}$ |
|-- |--     |--   |--         |-- |-- |-- |--  |--                 |
| lower bound  |-14| 19| 0.5| -4| 0| -4| 19.5 |  1.5  |
| upper bound  |-13.5| 19.5| 0.6| -3.5| 0.5| -3.5| 20 | 5 |
| guessed previously | -13.7661 | 19.0018 | 0.50000 | -4.0000 | 0.2812 | -4.0000 | 20.0000 | **2** |
| guessed | -14.0000 | 19.0075 | 0.50000 | -3.5000 | 0 | -3.9901 | 19.7327 | 1.5000 |

| FunctionTolerance | MaxStallIterations | WallClockTime(s) |
|--                 |--                  |--                |
| 1e-6              | 50                 |  3479 = 58m   |

![](figs/2023_03_10/fit_stretto_epsilon_variabile.png)

**fitness function = 9.6294**


## 13/3/2023

Ho trovato un errore che facevo nel calcolo del $J + \frac{\partial D}{\partial t}$ (non avevo messo bene una parentesi nel calcolo del gradiente delle number density)  
Le cose ancora non tornano, devo indagare meglio  

## 15/3/2023
Controllo la funzione che calcola il $\frac{\partial D}{\partial t}$ e mi convinco che funziona bene.  
Realizzo un full esplicito e riesco con successo, almeno a prima vista, a calcolare bene la corrente di polarizzazione

## 16/3/2023
Eseguo una simulazione con il modello full esplicito e calcolo la corrente con il $J + \frac{\partial D}{\partial t}$
![](figs/2023_03_16/esplicito.png)
Eseguo la stessa identica simulazione con le ODE
![](figs/2023_03_16/ODE.png)

**LE ODE NON DANNO NUMBER DENSITY < 0**  
Questo mi fa ipotizzare che tutte le volte che ottenevo qualche number density <0 ci fosse qualcosa che non andava (metto un errore in odefunc quando le number density diventano <0)

Sistemo un po' il codice passato e vado a ricontrollare il confronto tra il fit a mano #1 e la corrente di Seri: come mi aspetto il fit non torna, ma almono la corrente calcolata con Sato e con il $J + \frac{\partial D}{\partial t}$ viene uguale. Anche in questo caso le number density sono tutte > 0 **BENE!**
![](figs/2023_03_16/confronto_1.png)

## 17/3/2023
Ho fatto uno script per vedere la dipendenza della mobilità dal campo elettrico e dalla temperatura  
Scopro un errore bello grosso: la costante di Richardson vale $A = 1.2 \cdot 10^{6} A m^{-2} K^{-2}$, io avevo sempre utilizzato come esponente $-6$ il che mi portava ad ottenere un valore di costante normalizzata (divisa per la carica dell'elettrone per ottenere un flusso invece che una densità di corrente) pari a $a = 7.5 \cdot 10^{12}$ quando in realtà il valore corretto era 
$$a = 7.5 \cdot 10^{24}$$  
Questo spiega perchè avessi sempre trovato dei potenziali di estrazione più bassi rispetto ai valori di riferimento generalmente accettati (circa 1.2 eV)  

Noto che il parametro S0 se fissato ad un certo valore fa la differenza tra la comparsa o meno di number density < 0 nella simulazione effettuata con le ODE (in realtà non è l'unico parametro, mi è successo una volta anche con le mobilità)

Provo di nuovo a fare un fitting con il TRRA 

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 |
|-- |--     |--   |--         |-- |-- |-- |--  |
| lower bound  |-15|20|1|-4|-4|-4|19|
| upper bound  |-12|25|1.5|2|2|2|23|
| initial guess |-13|21|1.3|-1|-2|-2|20|
| guessed |-12.9162|24.0893|1.3090|-0.4318|-1.4241|-2.8589|19.4116|

| FunctionTolerance | OptimalityTolerance | WallClockTime(s) |
|--                 |--                   |--                |
| 1e-10             | 1e-8                | 43               |

![](figs/2023_03_17/TRRA_fit.png)

Ora la situazione è molto migliorata, ricorda i grafici che aveva ottenuto la Le Roy 20 anni fa in *"Description of charge transport
in polyethylene using a fluid model
with a constant mobility: fitting model
and experiments"*

![](figs/2023_03_17/Le_Roy.png)

## 20/3/2023
Provo anche a fare un fit con il Particle Swarm

|   | $\mu$ | n0t | $\varphi$ | B | D | S | n0 |
|-- |--     |--   |--         |-- |-- |-- |--  |
| lower bound  |-15|20|1|-4|-4|-4|19|
| upper bound  |-12|25|1.5|2|2|2|23|
| guessed |-13.8450|24.9148|1.1626|-3.4693|-3.9943|-1.6546|20.3837|
| guessed |-12.9162|24.0893|1.3090|-0.4318|-1.4241|-2.8589|19.4116|

| FunctionTolerance | MaxStallIterations | WallClockTime(s) |
|--                 |--                  |--                |
| 1e-3              | 20                 |  211_000 = 2d : 10h : 36m : 40s   |

![](figs/2023_03_20/PS_fit_SERI.png)

## 21/3/2023
Inizio ad implementare il modello dei Nordici. Nella priga riga di PARAMETERS_TABLE metto i parametri che hanno trovato i Nordici

## 22/3/2023
Implemento la formula per la mobilità dipendente dal campo elettrico e faccio dei test sui risultati del modello quando si mette la mobilità dipendente dal campo elettrico

![](figs/2023_03_22/very_low_fields.png)
![](figs/2023_03_22/low_fields.png)
![](figs/2023_03_22/medium_fields.png)
![](figs/2023_03_22/medium_fields_2.png)
![](figs/2023_03_22/medium_high_fields.png)
![](figs/2023_03_22/high_fields.png)

I grafici mostrati sopra sono stati realizzati utilizzando in ordine i parametri denominati: 
* "mu_dependency_E_1e5.mat"  
* "mu_dependency_E_3e7.mat" 
* "mu_dependency_E_6e7.mat" 
* "mu_dependency_E_9e7.mat" 
* "mu_dependency_E_1.5e8.mat" 
* "mu_dependency_E_3e8.mat" 



Implemento la formula per il calcolo del coefficiente di trapping dipendente dal campo elettrico.
Cerco i valori dei coefficienti Be e Bh che fissati a mano mi danno un andamento molto simile a quello che ottengo considerando B dipendente dal campo, questo valido per bassi campi elettrici (1e5 V/m)

![](figs/2023_03_22/B_dependency_E_1e5.png)

I parametri che trovo che mi consentono di ottenere questo buon accordo sono
>P.Bh = 2.4e-2;
>
>P.Be = 1.2e-2;

Provo a fare dei test con gli stessi parametri fissati a mano e diversi valori di campo
![](figs/2023_03_22/B_dependency_E_1e6.png)
![](figs/2023_03_22/.B_dependency_E_1e7.png)
![](figs/2023_03_22/B_dependency_E_1e8.png)

I parametri utilizzati per ottenere i grafici sopra illustrati sono:
*  "B_dependency_E_1e5.mat"
*  "B_dependency_E_1e6.mat"
*  "B_dependency_E_1e7.mat"
*  "B_dependency_E_1e8.mat"

In tutti non è stata considerata la dipendenza dal campo elettrico della mobilità

## 23/3/2023
![](figs/2023_03_23/B_dependence_on_E.png)

![](figs/2023_03_23/B_dependence_on_E_with_mobility.png)

Le due figure sopra riportano la dipendenza del coefficiente di detrapping B dal campo elettrico. La prima si riferisce al caso in cui la mobilità viene lasciata costante mentre la seconda è relativa ad un caso in cui anche la mobilità è dipendente dal campo elettrico

Deduco che ha senso rifare le simulazioni di ieri mettendo sia la dipendenza di B che di $\mu$ dal campo elettrico  

## 27/3/2023
Utilizzando i parametri che vengono forniti nell'articolo dei Nordici (Doedens) le ODE non riescono a concludere la simulazione. Vedo che se metto un valore del campo elettrico più basso invece riescono a concludere. Indago questo aspetto: 

![](figs/2023_03_27/E_1e6.png)
![](figs/2023_03_27/E_2e6.png)

Con i parametri attuali, se metto il campo a $E = 3 \cdot 10^6 (V/m)$ si creano delle number density <0, anche ignorando questo aspetto le ODE non riescono a concludere e quello che si ottiene è questo grafico

![](figs/2023_03_27/E_3e6.png)

&nbsp;

&nbsp;

### TODO
* fare un fit con il TRRA mettendo solo la mobilità dipendente dal campo elettrico &#x2610;
* fare un semi implicito in MATLAB  &#x2610;
* $\mu = \mu(E,n)$  &#x2610;
* modello Nordici con ODE &#x2611;
* equilibrio termini di sorgente &#x2611;
* sanity check per il fitting &#x2611;
* aumentare n0 e vedere che succede &#x2611;
* fare un full esplicito in MATLAB &#x2611;
* grafico di $\mu = \mu(E,T)$ &#x2611;
* stop quando n <0 nelle ODE &#x2611;
* confronto corrente con $J + \frac{\partial D}{\partial t}$ e Sato  &#x2611;

### DUBBI
* $B_{(e,h)} = \mathrm{mult\_B} \cdot u_{e,h}$ Ma B è per ogni cella e u è alle interfacce
* $e$ o $e^2$ nell'argomento del sinh ? 
* $A_{T_{(e,h)}} = a_{sh_{(h,e)}}^2$ oppure $A_{T_{(e,h)}} = a_{sh_{(e,h)}}^2$ ?
* Ha senso fare una funzione tipo "Compare_mu" per i gli altri coefficienti?




