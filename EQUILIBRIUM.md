
Le equazioni per la cinetica sono:

$$\Omega_{h} = -B_{h} n_{h} (1-\frac{n_{ht}}{N_{ht}}) + D_{h}n_{ht} - S_{2}n_{h}n_{et} - S_{3}n_{h} n_{e}$$

$$\Omega_{e} = -B_{e} n_{e} (1-\frac{n_{et}}{N_{et}}) + D_{e}n_{et} - S_{1}n_{e}n_{ht} - S_{3}n_{e}n_{h}$$

$$\Omega_{ht} = +B_{h} n_{h} (1-\frac{n_{ht}}{N_{ht}}) - D_{h}n_{ht} - S_{0}n_{ht}n_{et} - S_{1}n_{ht}n_{e}$$

$$\Omega_{et} = +B_{e} n_{e} (1-\frac{n_{et}}{N_{et}}) - D_{e}n_{et} - S_{0}n_{et}n_{ht} - S_{2}n_{et}n_{h}$$

Si fanno alcune ipotesi  
* Simmetria dei coefficienti di trapping, detrapping e della densità totale di trappole
$$ B_{h} = B_{e} $$
$$ D_{h} = D_{e} $$
$$ N_{ht} = N_{et} $$

* Simmetria del valore di **regime** delle number density dei portatori liberi e intrappolati
$$ n_{e} = n_{h}$$
$$ n_{et} = n_{ht} $$

* Esistenza di un termine di generazione per i portatori liberi

Si vuole verificare l'esistenza di una soluzione di regime non nulla, considerando le ipotesi le equazioni da considerare diventano

$$0 = -B n (1-\frac{n_{t}}{N_{t}}) + Dn_{t} - S_{2}nn_{t} - S_{3}n^2 + \Omega$$

$$0 = -B n (1-\frac{n_{t}}{N_{t}}) + Dn_{t} - S_{1}nn_{t} - S_{3}n^2 + \Omega$$

$$0 = +B n (1-\frac{n_{t}}{N_{t}}) - Dn_{t} - S_{0}n_{t}^2 - S_{1}n_{t}n$$

$$0 = +B n (1-\frac{n_{t}}{N_{t}}) - Dn_{t} - S_{0}n_{t}^2 - S_{2}n_{t}n$$

Si pone

$$ C = -B n (1-\frac{n_{t}}{N_{t}}) + Dn_{t} \tag{1}$$

E quindi le equazioni possono essere riscritte come

$$ 0 = C - S_{2}nn_{t} - S_{3}n^2 + \Omega \tag{2}$$

$$ 0 = C - S_{1}nn_{t} - S_{3}n^2 + \Omega \tag{3}$$

$$ 0 = -C - S_{0}n_{t}^2 - S_{1}n_{t}n \tag{4}$$

$$ 0 = -C - S_{0}n_{t}^2 - S_{2}n_{t}n \tag{5}$$

Considerando le equazioni (4) e (5) è possibile ricavare che deve valere

$$ - S_{0}n_{t}^2 - S_{2}n_{t}n  = - S_{0}n_{t}^2 - S_{1}n_{t}n  => S_{2} = S_{1} $$

Si pone $ \bf{S_{12} = S_{1} = S_{2}} $

Le equazioni (4)-(5) e (2)-(3) sono dunque rispettivamente equivalenti.  
(4) e (5) forniscono la relazione

$$ C = - S_{0}n_{t}^2 - S_{12}n_{t}n \tag{6}$$

che viene sostituita nelle equazioni (2)-(3) fornendo

$$ 0 = - S_{0}n_{t}^2 - 2S_{12}n_{t}n - S_{3}n^2 + \Omega $$

$$ \Omega = S_{0}n_{t}^2 + 2S_{12}n_{t}n + S_{3}n^2 \tag{7}$$

L'equazione (7) permette di calcolare il valore del termine di generazione per i portatori liberi se si conoscono i coefficienti di ricombinazione e le number density a regime. Sarà inoltre necessario rispettare i vincoli
$$ \bf{S_{12} = S_{1} = S_{2}} $$

$$ -B n (1-\frac{n_{t}}{N_{t}}) + Dn_{t} = - S_{0}n_{t}^2 - S_{12}n_{t}n$$

in cui l'ultimo deriva dall'unione delle equazioni (1) e (6)















