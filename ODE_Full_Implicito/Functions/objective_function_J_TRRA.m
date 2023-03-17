function [error_vector] = objective_function_J_TRRA(parametri, Jobjective, time_instants, P)
% OBJECTIVE_FUNCTION_J_TRRA Fitness function for a fit with TRRA  

num = 1;
P.mu_h = 10^parametri(num);
P.mu_e = 10^parametri(num);
P.D_h = P.mu_h * P.T * P.kB;
P.D_e = P.D_h;

num = num + 1;
P.nh0t = 10^parametri(num);
P.ne0t = 10^parametri(num);

num = num + 1;
P.phih = parametri(num);
P.phie = parametri(num);
P.aT2exp = P.a * (P.T^2) * exp(-[P.phie, P.phih] * P.e / P.kBT); 

num = num + 1;
P.Bh = 10^parametri(num);
P.Be = 10^parametri(num);

num = num + 1;
P.Dh = 10^parametri(num);
P.De = 10^parametri(num);

num = num + 1;
P.S0 = 10^parametri(num) * P.e;
P.S1 = P.S0;
P.S2 = P.S0;
P.S3 = P.S0;

num = num + 1;
n_stato_0 = zeros(P.num_points*4, 1);
n_stato_0(1:P.num_points) = 10^parametri(num);
n_stato_0(P.num_points+1:2*P.num_points) = 10^parametri(num);

[tout, nout] = ode23tb(@(t,n_stato)odefunc_Drift_Diffusion(t, n_stato, P), time_instants, n_stato_0);
[~, ~, ~, ~, ~, ~, ~, ~, J_dDdt] = post_processing(nout, tout, P);

error_vector = (log10(Jobjective) - log10(J_dDdt))./log10(Jobjective);

end
