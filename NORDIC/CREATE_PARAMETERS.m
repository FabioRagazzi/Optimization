clc, clearvars, close all
addpath('Functions\')

% Geometry (not usable in a fit)
P.L = 3.5e-4;
P.num_points = 100;
P.LW = 2.5e-5;
P.LE = 2.5e-5;
P.nW = 7;
P.nE = 7;

% Essential Parameters (not usable in a fit)
P.T = 333;
P.eps_r = 2.3;
P.Phi_W = 0;
P.Phi_E = P.L * 3e7;

% Fixed parameters not depending on the electric field 
P.phih = 1.3;
P.phie = 1.3;
P.n_start = [1e19, 1e19, 1e2, 1e2];
P.mu_h = 1e-13;
P.mu_e = 1e-13;
P.Bh = 2.4e-2;
P.Be = 1.2e-2;
P.Dh = 1e-3;
P.De = 1e-3;
P.S0 = 5e-22;
P.S1 = 5e-22;
P.S2 = 5e-22;
P.S3 = 5e-22;

% Extra Schottky parameter
P.lambda_e = 1; % ()
P.lambda_h = 1; % ()
% Extra parameters needed when the mobility is dependent from the electric
% field
P.a_int = [100 80] * 1e-9; % (m)
P.w_hop = [0.74, 0.76]; % (eV)
P.a_sh = [1.25 2.25] * 1e-9; % (m)
% Extra parameters needed when the trapping coefficient is dependent on the
% electric field
P.w_tr_int = [0.79, 0.81]; % (eV)
P.N_int = [1e23, 1e23]; % (m^-3)
P.N_deep = [5.9293e20, 2.4966e20]; % (m^-3)
P.Pt = [1, 1]; % ()
% Extra parameters needed when the detrapping coefficient is dependent on the
% electric field
P.w_tr_hop = [1, 1]; % (eV)
P.w_tr = [1.03, 1.03]; % (eV)
% Extra parameters needed when the recombination coefficients are dependent on the
% electric field
P.S_base = [2e-23, 2e-23, 2e-23, 2e-23];
P.Pr = 1; % ()

% Complete P
P = PhysicsConstants(P);
P = DerivedParameters(P);
P = CompleteP(P);

% Saving the parameters as "INBOX"
save('Parameters\INBOX', "P");

rmpath('Functions\')
