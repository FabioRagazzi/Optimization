function [d_n_stato_dt] = odefunc_Drift_Diffusion(t, n_stato, P)
% ODEFUNC_DRIFT_DIFFUSION Computes dndt given the current values of n
n = reshape(n_stato, [P.num_points, 4]);
rho = sum(n.*[1, -1, 1, -1],2) * P.e;
phi = Electrostatic(rho, P.coeff, P.Phi_W, P.Phi_E, P.Kelet); 
E = Electric_Field(phi, P.Delta, P.Phi_W, P.Phi_E);
u = E .* [P.mu_h, -P.mu_e];
Gamma = Fluxes(n(:,1:2), P.num_points, u, P.Delta, P.D_h, P.D_e, E(1), E(end), P.aT2exp, P.kBT, P.beta);
omega = Omega(n, P.num_points, P.nh0t, P.ne0t, P.Bh, P.Be, P.Dh, P.De, P.S0, P.S1, P.S2, P.S3);
d_n_stato_dt = omega;
d_n_stato_dt(1:2*P.num_points) = d_n_stato_dt(1:2*P.num_points) - Gamma/P.Delta;
end
