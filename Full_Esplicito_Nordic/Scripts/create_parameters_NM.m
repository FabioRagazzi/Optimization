%% CHOOSE THE PARAMETERS
clc, clearvars
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\Full_Esplicito_Nordic\Scripts')
addpath('..\Functions\')
fprintf("-> PARAMETERS NM\n")

% Essential parameters of the simulation
P.L = 3.5e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = P.L * 3e7;
P.phih = 1.148;
P.phie = 0.905;
P.n_start = [1e20, 1e20, 0, 0];

% Fixed parameters not depending on the electric field 
% P.mu_h = 1e-14;
% P.mu_e = 1e-14;
% P.Bh = 2e-1;
% P.Be = 2e-1;
% P.Dh = 1e-1;
% P.De = 1e-1;
% P.S0 = 4e-3;
% P.S1 = 4e-3;
% P.S2 = 4e-3;
% P.S3 = 4e-3;

% Extra Schottky parameter
P.lambda_e = 4.1e-5;
P.lambda_h = 1e-1;
% Extra parameters needed when the mobility is dependent from the electric
% field
P.a_int = [100 80] * 1e-9; % (m)
P.w_hop = [0.74, 0.76]; % (eV)
P.a_sh = [1.25 2.25] * 1e-9; % (m)
% Extra parameters needed when the trapping coefficient is dependent on the
% electric field
P.w_tr_int = [0.79, 0.81]; % (eV)
P.N_int = [1e23, 1e23]; % (m^-3)
P.N_deep = [95, 40] / 1.602176634e-19; % (m^-3)
P.Pt = [1, 1]; % ()
% Extra parameters needed when the detrapping coefficient is dependent on the
% electric field
P.w_tr_hop = [1, 1]; % (eV)
P.w_tr = [1.03, 1.03]; % (eV)
% Extra parameters needed when the recombination coefficients are dependent on the
% electric field
P.S_base = [1e-4, 1e-4, 1e-4, 1e-4];
P.Pr = 1; % ()

% FROM HERE DO NOT TOUCH !!
% Physics constants
P.h = 6.62607015e-34;
P.e = 1.602176634e-19;
P.kB = 1.380649e-23;
P.eps0 = 8.854187817e-12;
P.abs0 = 273.15;
P.A = 1.20173e6;

% Derived parameters
P.a = P.A / P.e;
P.Delta = P.L / P.num_points;
P.T = P.T + P.abs0;
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.beta = sqrt((P.e^3)/(4*pi*P.eps));
P.coeff =  8 * P.eps / (3 * P.Delta^2);
P.aT2exp = P.a * (P.T^2) * [P.lambda_e, P.lambda_h] .* exp(-[P.phie, P.phih] * P.e / P.kBT); 
% P.D_h = P.mu_h * P.kBT / P.e;
% P.D_e = P.mu_e * P.kBT / P.e;
% P.S0 = P.S0 * P.e;
% P.S1 = P.S1 * P.e;
% P.S2 = P.S2 * P.e;
% P.S3 = P.S3 * P.e;
P.S_base = P.S_base * P.e;
P.Kelet = Kelectrostatic_sparse(P.num_points, P.Delta, P.eps);
P.v = P.kBT / P.h;
P.ext_mult_sinh = 2 * P.v * P.a_int .* exp(-P.w_hop * P.e / P.kBT);
P.arg_sinh = P.e * P.a_sh / (2 * P.kBT);
P.At = P.a_sh.^2;
P.mult_B = P.Pt .* P.N_deep .* P.At;
P.B0 = P.v * P.N_deep .* exp(-P.e * P.w_tr_int / P.kBT) ./ P.N_int;
P.mult_D = 2 * P.v * exp(-P.e * P.w_tr_hop / P.kBT);
P.add_D = P.v * exp(-P.e * P.w_tr / P.kBT);
P.mult_S = P.Pr * P.e / P.eps;

% Saving the parameters as "inbox"
save('..\Parameters\inbox', "P");

rmpath('..\Functions\')
cd(current_path)
clear current_path

%% SAVE THE PARAMETERS
clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\Full_Esplicito_Nordic\Parameters\')
addpath('..\Functions\')
fprintf("-> SAVE THE PARAMETERS NM\n")

load('inbox.mat');
save('Nordic_standard', "P");

rmpath('..\Functions\')
cd(current_path)
clear current_path
