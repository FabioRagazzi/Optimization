function [d_n_stato_dt] = odefunc_Drift_Diffusion_NM(t, n_stato, P,...
    flag_mobility_dependent_on_E, flag_B_dependent_on_E, flag_D_dependent_on_E, flag_S_dependent_on_E)
% ODEFUNC_DRIFT_DIFFUSION Computes dndt given the current values of n

% % Stop if number density became negative
% if find(n_stato<0)
%     error("Number density became less than 0 at t = " + num2str(t))
% end

n = reshape(n_stato, [P.num_points, 4]);
rho = sum(n.*[1, -1, 1, -1],2) * P.e;
phi = Electrostatic(rho, P.coeff, P.Phi_W, P.Phi_E, P.Kelet); 
E = Electric_Field(phi, P.Delta, P.Phi_W, P.Phi_E);

% Compute mobility based on the relative flag
if flag_mobility_dependent_on_E
    [mu_h, mu_e] = Mobility(E, P.ext_mult_sinh, P.arg_sinh);
    mu = [mu_h, mu_e];
else
    mu = [P.mu_h, P.mu_e] .* ones(size(E));
end

% Compute drift velocity 
u = E .* mu .* [1 -1];

% Compute trapping coefficient based on the relative flag
u_center = (u(1:end-1,:) + u(2:end,:)) / 2;
if flag_B_dependent_on_E
    B = P.B0 + P.mult_B .* u_center;
else
    B = [P.Bh, P.Be] .* ones(size(E,1)-1, size(E,2));
end

% Compute detrapping coefficient based on the relative flag
E_center = (E(1:end-1,:) + E(2:end,:)) / 2;
if flag_D_dependent_on_E
    D = P.mult_D .* sinh(E_center .* P.arg_sinh) + P.add_D;
else
    D = [P.Dh, P.De] .* ones(size(E,1)-1, size(E,2));
end

% Compute recombination coefficients based on the relative flag
mu_center = (mu(1:end-1,:) + mu(2:end,:)) / 2;
if flag_S_dependent_on_E
    S = mu_center * [0, 0, 1, 1; 0, 1, 0, 1] * P.mult_S;
    S = S + P.S_base;
else
    S = [P.S0, P.S1, P.S2, P.S3] .* ones(size(E));
end

% Compite diffusion coefficients with Einstein relation
Diff = mu * P.kBT / P.e;

Gamma = Fluxes(n(:,1:2), P.num_points, u, P.Delta, Diff, E(1), E(end), P.aT2exp, P.kBT, P.beta);
omega = Omega_NM(n, P.num_points, P.N_deep, B, D, S);
d_n_stato_dt = omega;
d_n_stato_dt(1:2*P.num_points) = d_n_stato_dt(1:2*P.num_points) - Gamma/P.Delta;
end
