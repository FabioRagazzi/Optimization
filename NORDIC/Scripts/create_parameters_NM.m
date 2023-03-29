%% CHOOSE THE PARAMETERS
clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC\Scripts')
addpath('..\Functions\')
fprintf("-> PARAMETERS NM\n")

% Essential parameters of the simulation
P.L = 3.5e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = P.L * 3e7;
P.phih = 1.3;
P.phie = 1.3;
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

% Complete P with the derived parameters
[P] = CompleteP(P);

% Saving the parameters as "inbox"
save('..\Parameters\inbox', "P");

rmpath('..\Functions\')
cd(current_path)
clear current_path

%% SAVE THE PARAMETERS
clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC\Parameters\')
addpath('..\Functions\')
fprintf("-> SAVE THE PARAMETERS NM\n")

load('inbox.mat');
save('Nordic_standard', "P");

rmpath('..\Functions\')
cd(current_path)
clear current_path
