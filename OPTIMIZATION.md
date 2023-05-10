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

Provo intanto a fare il fit con il TRRA mettendo solo la mobilità dipendente dal campo elettrico ma non riesco a farlo funzionare, ottengo un errore legato al fatto che la dimensione del gradiente sia inferiore alla tolleranza

## 28/3/2023
Faccio un full esplicito che implementa il modello dei nordici e per fare un primo check provo a confrontarne i risultati con il full esplicito che mantiene tutti i parametri ($\mu$, B, D, S) indipendenti dal campo elettrico.

![](figs/2023_03_28/confronto_full_espliciti.png)

Qualcosa non va, dovrò indagare meglio. vedo che già dalla prima iterazione ci sono delle differenze nelle number density che ottengo  

## 29/3/2023
Ricontrollo bene in debug e vedo che le number density calcolate sono identiche. Alla fine riesco a trovare l'errore, avevo sbagliato passando la mobilità invece della velocità alla funzione "compute_J_cond" (occhio al segno della velocità)

![](figs/2023_03_29/Confronto_full_esplicito_Nordic.png)

Faccio un check utilizzando le ODE_Nordic, dovrei ottenere lo stesso identico risultato

![](figs/2023_03_29/ODE_Nordic.png)

Mi tengo da parte questi parametri (utilizzati per ottenere i risultati appena mostrati) per test futuri.

~~~~
% Essential parameters of the simulation
P.L = 3.5e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = P.L * 3e7;
P.phih = 1.4;
P.phie = 1.4;
P.n_start = [1e18, 1e18, 0, 0];

% Fixed parameters not depending on the electric field 
P.mu_h = 1e-14;
P.mu_e = 1e-14;
P.Bh = 2e-1;
P.Be = 2e-1;
P.Dh = 1e-1;
P.De = 1e-1;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 4e-3;

% Extra Schottky parameter
P.lambda_e = 1;
P.lambda_h = 1;

P.N_deep = [6e20, 6e20]; % (m^-3)
~~~~

Ora provo a cambiare i parametri, mettendo anche le dipendenze dal campo elettrico e vedo se ottengo gli stessi risultati con le ODE e con il semi-implicito  
* tengo i parametri di sopra (per quelli non specificati uso quelli dei nordici) e metto la mobilità dipendente dal campo elettrico -> i risultati sono uguali
* tengo i parametri di sopra (per quelli non specificati uso quelli dei nordici ad eccezione di N.deep che è 6e20) e metto la mobilità e il coeffciente di trapping dipendenti dal campo elettrico -> i risultati sono uguali
* tengo i parametri di sopra (per quelli non specificati uso quelli dei nordici ad eccezione di N.deep che è 6e20) e metto la mobilità e il coeffciente di trapping e detrapping dipendenti dal campo elettrico -> i risultati non sono uguali !!
**Scopro  un errore: non avevo messo il valore assoluto dal campo elettrico dentro il sinh** -> adesso i risultati vengono uguali
* i risultati vengono uguali anche mettendo la dipendenza di tutti i parametri dal campo elettrico

Utilizzando i parametri che vengono forniti nell'articolo dei nordici (e con una number density iniziale per elettroni e lacune liberi pari a 1e20 mentre fissata a zero per gli intrappolati) si ottiene il seguente risultato. Nella figura vengono confrontati i risultati ottenuti eseguendo i calcoli con le ODE e con l'Esplicito
![](figs/2023_03_29/ODE_Esplicito_Nordic_0_8.png)
![](figs/2023_03_29/ODE_Esplicito_Nordic_0_1.png)

Si vede che riducendo il CFL i risultati dell'Esplicito tendono a coincidere di più con i risultati ottenuti dalle ODE.  
Sistemo un po' di cose per il TRRA, per renderlo più comodo, domani lo proverò

## 30/3/2023
Lavoro al literature survey sulle DBD degli ultimi anni di cui mi ha incaricato Arturo 

## 4/4/2023
Lavoro un po' sull'implementazione del fitting con TRRA per renderlo più pratico. Lancio una simulazione con **nessun parametro dipendente dal campo elettrico** e ottengo questo risultato
![](figs/2023_04_04/TRRA_Fit_Classico.png)
E' un buon risultato perchè si riesce a riprodurre fedelmente il primo tratto della curva, oserei dire come mai prima d'ora.  

&nbsp;  

&nbsp;  

&nbsp;

Provo a **riutilizzare dei vecchi parametri** che avevo trovato e ottengo un fit ottimo, migliore di quello che avevo ottenuto in precedenza con questi stessi parametri (eppure il modello dovrebbe essere identico)   
Non riesco a capire a cosa sia dovuta la differenza, comunque i parametri per cui ottengo il bel risultato sono:
| $\mu$ | $\varphi$ | B | D | S | n0 | n0t |
|--     |--   |--         |-- |-- |-- |--  |
|-12.9162|1.3090|-0.4318|-1.4241|-2.8589|19.4116|24.0893|
~~~~
xv = [-12.9162  1.3090  -0.4318  -1.4241  -2.8589  19.4116  24.0893];
L: 3.5000e-04
num_points: 100
T: 333.1500
eps_r: 2
Phi_W: 0
Phi_E: 10500
n_start: [/, /, 1e5 o 0, 1e5 o 0]
~~~~
![](figs/2023_04_04/Vecchi_parametri.png)

&nbsp;  

&nbsp;  

&nbsp;

Provo a mantenere gli stessi identici parametri che hanno prodotto il bel risultato mostrato sopra e **mettere la mobilità dipendente dal campo elettrico utilizzando i parametri che fornivano i Nordici nell'articolo**(solo grafico, no TRRA).
~~~~
P.a_int = [100 80] * 1e-9; % (m)
P.w_hop = [0.74, 0.76]; % (eV)
P.a_sh = [1.25 2.25] * 1e-9; % (m)
~~~~
![](figs/2023_04_05/Fit_classico_con_mobilita_Nordici.png)
Quello che si vede è che il risultato peggiora 

&nbsp;  

&nbsp;  

&nbsp;

Ora provo a mettere la **mobilità dipendente dal campo elettrico con i parametri trovati dai Nordici**. Uso poi il TRRA per trovare i parametri classici ($\varphi$, B, D, S, $n_{0}$, $n_{0t}$) escludendo la mobilità $\mu$
|| $\varphi$ | B | D | S | n0 | n0t |
|--|--     |--   |--         |-- |-- |-- |
|x0|1.2778  | -0.5556  | -0.5556  | -0.5556  | 21.3333 |  22.8889|
|xv|1.2825  | -0.6783  | -0.6783  | -0.6783  | 19.2925 |  25.8647|

![](figs/2023_04_05/.Fit_classic_mu_E_Nordicpng.png)
Questa figura è la più bella di 10, il TRRA è **MOLTO** dipendente dal punto di partenza

&nbsp;  

&nbsp;  

&nbsp;

Provo a lanciare un fitting con il TRRA in cui considero la **mobilità dipendente dal campo elettrico e vado quindi a fare l'ottimizzazione anche dei parametri ad essa collegati**
* a_sh
* a_int
* w_hop

# Linka
[back](#linkb)

|phih | Bh | Dh | S0 | n_start | N_deep | a_int | w_hop | a_sh | 
|--   |--  |--  |--  |--       |--      |--     |--     |--    |
| 1.3015 |  -1.0232  | -1.0232 |  -1.0232 |  19.0000 |  24.9979  | -7.0155 |   0.7015  | -9.0155  |

![](figs/2023_04_04/mobilita_dipendente_da_E.png)

Provo a lanciare un Particle Swarm per questo caso:  
Alla fine il computer si riavvia da solo dopo una settimana e il PS non aveva ancora finito, ci stava mettendo comunque troppo tempo

&nbsp;  

&nbsp;  

&nbsp;

Ora lancio una simulazione con il TRRA in cui **mantengo i parametri classici fissi al valore che ha prodotto il fit migliore fino ad ora e ottimizzo i parametri relativi alla mobilità dipendente dal campo**
|      | a_int(1) | a_int(2) | w_hop(1) | w_hop(2) | a_sh(1) | a_sh(2) |
|--    |--        |--        |--        |--        |--       |--       |
|  x0  |-7.7500   |-7.7500   |0.6500    |0.6500    |-9.7500  |-9.7500  |
|  xv  |-7.7473   |-7.7473   |0.6459    |0.6459    |-9.7478  |-9.7478  |

![](figs/2023_04_05/Classic_param_fixed_fit_mobE.png)

&nbsp;  

&nbsp;  

&nbsp;

Il prossimo passo è provare a fare un fit di **tutti i parametri del modello dei Nordici** (tenendoli simmetrici). In realtà i parametri non sono tutti ma quasi tutti, quelli non considerati nel fitting sono:
~~~~
L: 3.5000e-04
num_points: 100
T: 333.1500
eps_r: 2
Phi_W: 0
Phi_E: 10500
n_start: [/, /, 0, 0]
P.lambda_e = 1;
P.lambda_h = 1;
P.Pt = [1, 1];
P.Pr = 1; 
~~~~

Ottengo il seguente risultato:

||a_int | w_hop | a_sh | w_tr_int | N_int | N_deep | w_tr_hop | w_tr | S_base | n_start | phih | 
|--|--|--|--|--|--|--|--|--|--|--|--|
|x0|-7|0.7|-9|0.7|23|20|1|1|-3.5|21|1.3|
|xv|-6.9605|0.6961|-8.9605|0.6961|22.6898|20.3280|0.9960|0.9960|-3.4506|19.3698|1.2960|
~~~~
xv = [-6.9605   0.6961   -8.9605   0.6961   22.6898   20.3280   0.9960   0.9960   -3.4506   19.3698   1.2960];
~~~~

![](figs/2023_04_05/fitting_Nordici.png)

Provo a fare anche un Particle Swarm di quest'ultimo caso:

&nbsp;  

&nbsp;  

&nbsp;

## 11/4/2023
Modifico il codice per mettere la possibilità di avere una spaziatura variabile lungo il dominio. Prendo un **caso di riferimento** con spaziatura costante:
~~~~
% Parameters of the simulation
P.L = 3.5e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = P.L * 3e7;
P.mu_h = 1e-13;
P.mu_e = 1e-13;
P.nh0t = 1e25;
P.ne0t = 1e25;
P.phih = 1.3;
P.phie = 1.3;
P.Bh = 1e-2;
P.Be = 1e-2;
P.Dh = 1e-3;
P.De = 1e-3;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 4e-3;
P.n_start = [1e21, 1e21, 0, 0];
~~~~
![](figs/2023_04_11/Spaziatura_costante.png)

Modifico il codice e vado a vedere se mantenendo la spaziatura costante si ottiene lo stesso risultato

![](figs/2023_04_11/Spaziatura_costante_nuovo_codice.png)
I due risultati sono uguali, deduco che ho fatto bene l'implementazione del nuovo codice.  
Ora provo ad infittire la spaziatura in corrispondenza degli elettrodi per vedere se i risultati cambiano

![](figs/2023_04_11/Infittimento_dagli_elettrodi.png)
Come era prevedibile ora l'accumulo in corrispondenza degli elettrodi è maggiore. Si vede che la corrente di polarizzazione non è cambiata perchè nelle fasi iniziali non c'è ancora accumulo agli elettrodi e anche quado si forma il picco di carica in corrispondenza degli elettrodi questo non contribuisce in alcun modo alla conduzione (elettrodi che bloccano l'uscita della carica)

&nbsp;  

&nbsp;  

&nbsp;

## 14/4/2023
Continuo a modificare il codice con le ODE migliorandolo. Dovrei essere riiuscito a mettere la possibilità di utilizzare il Koren limiter. Faccio una prova ("RECTANGLE") in cui metto una distribuzione di number density iniziale rettangolare (per elettroni e lacune). Dopo 100 secondi ottengo queste situazioni (senza l'auto-campo):
 ![](figs/2023_04_14/Koren.png)
 ![](figs/2023_04_14/Upwind.png)
 Se invece considero anche il campo prodotto dalla distribuzione di carica interna al dominio
 ![](figs/2023_04_14/Koren_full.png)
![](figs/2023_04_14/Upwind_full.png)

&nbsp;  

&nbsp;  

&nbsp;

## 19/4/2023
# Linkb
Ero rimasto  ad un [PS non finito](#linka)  
Deduco che il motivo per cui non ha finito era l'intervallo di ricerca dei parametri troppo ampio  
Se restringo l'intervallo di ricerca il PS sembra funzionare  
Sospetto che se l'intervallo è troppo ampio ci saranno in mezzo anche delle combinazioni di parametri che portano la simulazione a fallire, probabilmente è meglio per la riuscita dell'algoritmo eliminare questa condizione   
**TROVATO ERRORE!!**   
Il problema era in parte dovuto al fatto che il valore di fitness di default (utilizzato nel caso in cui la simulazione fallisse) fosse molto basso e quindi l'algoritmo continuava ad utilizzare valori dei parametri che portavano al fallimento delle simulazioni  
Altra cosa da sistemare è il fatto che se le number density diventano < 0 si possono ottenere delle simulazioni estremamente lunghe ("VERY_LONG" impiega circa 90 secondi). Occorre quindi che non appena le number density diventano < 0 l'integrazione si fermi. Per ottenere questo realizzo una funzione evento da passare alle ODE  
Il problema non è legato a number density che diventano minori di zero perchè anche dopo aver realizzato la funzione evento continuo ad avere che la simulazione si blocca nello stesso punto  
Preso dalla disperazione lancio un PS in seriale e faccio degli screen ai parametri delle simulazioni che durano molto per poi andare a controllare singolarmente in debug.  
Ad esempio, questa simulazione si era bloccata, perche?

![](figs/2023_04_19/screen1.png)  
Tutti 1  
![](figs/2023_04_19/screen1_B.png)

&nbsp;  

&nbsp;  

&nbsp;

## 20/4/2023
**TROVATO PROBLEMA!!**  
Ciò che rendeva alcune simulazioni estremamente lunghe era un valore molto elevato di densità di trappole deep (Ndeep). Le simulazioni procedevano molto lentamente senza però mai fallire. Abbassando il valore di Ndeep il PS riesce ad arrivare in fondo  
Provo a rilanciare la simulazione che [non si era ancora fermata dopo una settimana](#linka)  
Questa volta il PS si ferma ma il risultato che fornisce porta le number density a valori minori di 0  
**TROVATO PROBLEMA!!**
Stavo facendo il fitting con dei range(lb-ub) totalmente sballati per i coefficienti di ricombinazione, me ne accorgo perchè anche il TRRA aveva problemi a fare il fitting

Faccio l'ottimizzazione di un parametro alla volta usando il TRRA  
Avevo ottenuto in precedenza un buon fitting con i parametri classici, tenendo quello come riferimento introduco una alla volta la dipendenza dal campo per:
* mobilità
* trapping
* detrapping
* ricombinazione  

Ad ogni giro ottimizzo con il TRRA solo i parameteri relativi a quel parametro tenendo come riferimento i parametri trovati dia fitting precedenti

Fino al detrapping riesco ad ottenere dei buoni fit (tutti con parametri simmetrici tra lacune ed elettroni)  
Quando arrivo alla ricombinazione se la considero uguale per tutti i tipi non riesco ad ottenere un buon fit  
Inoltre sembra che se i coefficienti diventano piccoli oltre un certo valore (1e-25) **non fa più alcuna differenza quale sia il loro valore**(ha senso) 

Provo a non imporre che tutti e 4 abbiano lo stesso valore, ma la situazione non migliora

![](figs/2023_04_20/fitting_E_dependant.png)
La figura sopra è uno dei migliori risultati ottenuti introducendo la dipendenza dal campo nei coefficienti S  

Se mi fermo ad uno step precedente ($\mu$, B e D dipendenti dal campo) invece riesco ad ottenere un risultato molto migliore
![](figs/2023_04_20/mu_B_D_dependant_on_E.png)

&nbsp;

&nbsp;

&nbsp;

## 21/4/2023
Aggiungo il parametro $P_{r}$ ai fitting che stavo facendo ieri per i coefficienti di ricombinazione e riesco ad ottenere un buon risultato con tutti i parametri dipendenti dal campo elettrico
![](figs/2023_04_21/full_Nordic_Fit.png)

Finisce il PS che avevo lanciato ieri con gli stessi parametri di quello famoso [che non aveva finito](#linka)  
Questa volta finisce in tempi ragionevoli e riesco ad ottenere un buon risultato
![](figs/2023_04_21/fitting_PS.png)

&nbsp;  

&nbsp;  

&nbsp;

## 2/5/2023
Scopro che non è possibile killare prima le ODE

&nbsp;  

&nbsp;  

&nbsp;

## 8/5/2023
Correggo un errore dovuto alla variabile "N_deep" invece di "Ndeep"  
Riesco ad ottenere un fitting di tutti i parametri dipendenti dal campo elettrico con il particle swarm (range molto limitato e che sapevo che andava bene).

&nbsp;  

&nbsp;  

&nbsp;

## 9/5/2023
Riesco a killare le ODE se la durata della simulazione dura più di un certo tempo usando la event function. Lancio una simulazione con il PS del modello dei nordici completo (con anche Pr)

&nbsp;  

&nbsp;  

&nbsp;

## 10/5/2023
La simulazione termina e ottengo i seguenti valori, corrispondenti ad un valore della funzione obiettivo di **0.118799**. Salvo i risultati in **FULL_NORDIC_FIT_WITH_PS**
||a_int | w_hop | a_sh | w_tr_int | N_int | Ndeep | w_tr_hop | w_tr | S_base | n_start | phih | Pr |
|--|--|--|--|--|--|--|--|--|--|--|--|--|
| lb |-9 | 0.5 | -10 | 0.7 | 22 | 23 | 0.8 | 0.8 | -25 | 18 | 1.1 | 0.5|
| ub |-7 | 0.7 | -9 | 1 | 24 | 25 | 1 | 1 | -21 | 20 | 1.4 | 1|
| PS |-7.6251|0.6710|-9.9046|0.9996|22.1978|24.0893|0.9008|1.0000|-25.0000|19.8143|1.1641|0.5000|

![](figs/2023_05_10/PS_Full_Nordic.png)
Mi accorgo che c'era un errore ancora una volta relativo ad Ndeep. Avevo lasciato scritto Ndeep(1) e Ndeep(2) invece di Ndeep(:,1) e Ndeep(:,2). Questo fit è stato quindi ottenuto senza poter variare Ndeep. Il valore 24.0893 veniva dai parametri caricati inizialmente. Potrebbe quindi essere che considerando nella maniera corretta Ndeep il fit migliori.  

Il TRRA finisce molto prima ma porta a risultati non altrettanto validi. Lanciando 30 volte l'algoritmo con punto di partenza x0 random il risultato migliore ottenuto, salvato in **FULL_NORDIC_FIT_WITH_TRRA**, è 
||a_int | w_hop | a_sh | w_tr_int | N_int | Ndeep | w_tr_hop | w_tr | S_base | n_start | phih | Pr |
|--|--|--|--|--|--|--|--|--|--|--|--|--|
|TRRA|-7.2965 | 0.6955 | -9.2750 | 0.7626 | 23.3317 | 24.3093 | 0.8188 | 0.8431 | -24.0819 | 19.5531 | 1.1602 | 0.7764|

Questo risultato coincide con il punto di partenza x0

![](figs/2023_05_10/TRRA_Full_Nordic.png)

&nbsp;

CONCLUSIONE:
***IL PS E' MEGLIO DEL TRRA AD ESEGUIRE FITTING DI CORRENTI DI POLARIZZAZIONE***

&nbsp;  

&nbsp;  

&nbsp;

# TODO
* fare le 78.000 corse ($5^7$) &#x2610;
* controllare se le mobilità sono state misurate &#x2610;
* verificare i valori numerici delle mobilità nel caso Nordici vs. LeRoy &#x2610;
* aggiungere un termine di sorgente per i portatori liberi &#x2610;
* fare un semi implicito in MATLAB  &#x2610;
* cambiare impostazioni ODE per killare prima &#x2611;
* aggiungere $P_{r}$ al fitting &#x2611;
* $\mu = \mu(E,n)$  &#x2611;
* mettere la possibilità di spaziatura variabile &#x2611;
* fare un fit con il TRRA mettendo solo la mobilità dipendente dal campo elettrico &#x2611;
* modello Nordici con ODE &#x2611;
* equilibrio termini di sorgente &#x2611;
* sanity check per il fitting &#x2611;
* aumentare n0 e vedere che succede &#x2611;
* fare un full esplicito in MATLAB &#x2611;
* grafico di $\mu = \mu(E,T)$ &#x2611;
* stop quando n <0 nelle ODE &#x2611;
* confronto corrente con $J + \frac{\partial D}{\partial t}$ e Sato  &#x2611;

# DUBBI
* $B_{(e,h)} = \mathrm{mult\_B} \cdot u_{e,h}$ Ma B è per ogni cella e u è alle interfacce
* $e$ o $e^2$ nell'argomento del sinh ? 
* $A_{T_{(e,h)}} = a_{sh_{(h,e)}}^2$ oppure $A_{T_{(e,h)}} = a_{sh_{(e,h)}}^2$ ?
* Ha senso fare una funzione tipo "Compare_mu" per i gli altri coefficienti?

# NOTE
* Non chiamare mai una funzione "odefun" se no MATLAB impazzisce  
&#x2610;  
&#x2611;  
&#x2612;  



