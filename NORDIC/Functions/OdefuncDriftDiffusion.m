function [dndt, den_for_stab] = OdefuncDriftDiffusion(t, n_stato, P, options)
% OdefuncDriftDiffusion computes dndt given the current values of n
% INPUT
% t -> current value of time
% n_stato -> column vector containing the number density
% P -> structure with all the parameters
% options -> options for the simulation
% OUTPUT
% dndt -> first derivative of the number density 
% den_for_stab -> npx4 matrix useful to compute the time step dt in an explicit
% solver 

% Solving the Electrostatic problem
n = reshape(n_stato, [], 4);
rho = sum(n.*[1, -1, 1, -1],2) * P.e;
phi = SolveEletStat(P.EletStat, rho, P.Phi_W, P.Phi_E);
E = ComputeE(phi, P.Phi_W, P.Phi_E, P.deltas);

% Compute mobility
[mu_h, mu_e] = Mobility(E, P.ext_mult_sinh, P.arg_sinh, [P.mu_h, P.mu_e], options);
mu = [mu_h, mu_e];

if options.blocking_electrodes == "On"
    % the electrodes block the charge
    mu([1,end],:) = 0;
elseif options.blocking_electrodes == "Off"
else
    error("Invalid value for options.blocking_electrodes")
end

% Compute drift velocity 
u = E .* mu .* [1 -1];

% Compute trapping coefficients
u_center = (u(1:end-1,:) + u(2:end,:)) / 2;
B = Trapping(u_center, P.B0, P.mult_B, [P.Bh, P.Be], options);

% Compute detrapping coefficients 
E_center = (E(1:end-1,:) + E(2:end,:)) / 2;
D = Detrapping(E_center, P.mult_D, P.arg_sinh, P.add_D, [P.Dh, P.De], options);

% Compute recombination coefficients
mu_center = (mu(1:end-1,:) + mu(2:end,:)) / 2;
S = Recombination(mu_center, P.mult_S, P.S_base, [P.S0, P.S1, P.S2, P.S3], options);

% Compute diffusion coefficients with Einstein relation
Diff = mu * P.kBT / P.e;

% Compute border conditions 
if options.injection == "Schottky"
    gamma = Schottky(E([1, end])', P.aT2exp, P.kBT, P.beta);
    BC = [0, gamma(1); gamma(2), 0];
elseif options.injection == "Fixed"
    BC = P.fix_inj;
else
    error("Invalid value for options.injection")
end

% Compute fluxes and source terms to obtain dndt
[Gamma, ~, den_for_stab_flux] = Fluxes(n(:,1:2), u, P.deltas, P.Vol, Diff, BC, options);
if options.source == "On"
    [dndt, den_for_stab_omega] = Omega(n, P.Ndeep, B, D, S);
elseif options.source == "Off"
    dndt = zeros(4*P.num_points,1);
    den_for_stab_omega = zeros(P.num_points,4);
else
    error("Invalid value for options.source")
end

% computing the denominator useful for estimating the dt for stability 
den_for_stab = den_for_stab_omega;
den_for_stab(:,1:2) = den_for_stab(:,1:2) + den_for_stab_flux; 

dndt(1:2*P.num_points) = dndt(1:2*P.num_points) - Gamma;
end
