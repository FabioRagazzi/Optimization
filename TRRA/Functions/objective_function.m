function [error_vector] = objective_function(parametri,Jobjective,time,P)

P.mu_h = 10^parametri(1);
P.mu_e = 10^parametri(1);
P.D_h = P.mu_h * P.T * P.kB / P.e;
P.D_e = P.D_h;
P.nh0t = 10^parametri(2);
P.ne0t = 10^parametri(2);
P.phih = parametri(3);
P.phie = parametri(3);
P.Bh = 10^parametri(4);
P.Be = 10^parametri(4);
P.Dh = 10^parametri(5);
P.De = 10^parametri(5);
P.S0 = 10^parametri(6) * P.e;
P.S1 = P.S0;
P.S2 = P.S0;
P.S3 = P.S0;

n_stato_0 = zeros(P.num_points*4, 1);
n_stato_0(1:P.num_points) = 10^parametri(7);
n_stato_0(P.num_points+1:2*P.num_points) = 10^parametri(7);

[tout, nout] = ode23tb(@(t,n_stato)odefunc_Drift_Diffusion(t, n_stato, P), time, n_stato_0);
[~, ~, ~, ~, ~, ~, ~, J] = post_processing(nout, tout, P);

error_vector = (Jobjective - J)./Jobjective;
