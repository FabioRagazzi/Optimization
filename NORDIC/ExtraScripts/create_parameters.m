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
P.phih = 1.3090;
P.phie = 1.3090;
P.n_start = [10^(19.4116), 10^(19.4116), 0, 0];

% Fixed parameters not depending on the electric field 
P.mu_h = 10^(-12.9162);
P.mu_e = 10^(-12.9162);
P.Bh = 10^(-0.4318);
P.Be = 10^(-0.4318);
P.Dh = 10^(-1.4241);
P.De = 10^(-1.4241);
P.S0 = 10^(-2.8589);
P.S1 = 10^(-2.8589);
P.S2 = 10^(-2.8589);
P.S3 = 10^(-2.8589);

% Extra Schottky parameter
P.lambda_e = 1;
P.lambda_h = 1;
% Extra parameters needed when the mobility is dependent from the electric
% field
P.a_int = [10^(-6.9605), 10^(-6.9605)]; % (m)
P.w_hop = [0.6961, 0.6961]; % (eV)
P.a_sh = [10^(-8.9605), 10^(-8.9605)]; % (m)
% Extra parameters needed when the trapping coefficient is dependent on the
% electric field

P.w_tr_int = [0.6961, 0.6961]; % (eV)
P.N_int = [10^22.6898, 10^22.6898]; % (m^-3)
P.N_deep = [10^(24.0893), 10^(24.0893)]; % (m^-3)
P.Pt = [1, 1]; % ()
% Extra parameters needed when the detrapping coefficient is dependent on the
% electric field
P.w_tr_hop = [0.9960, 0.9960]; % (eV)
P.w_tr = [0.9960, 0.9960]; % (eV)
% Extra parameters needed when the recombination coefficients are dependent on the
% electric field
P.S_base = [10^(-3.4506), 10^(-3.4506), 10^(-3.4506), 10^(-3.4506)];
P.Pr = 1; % ()

% Complete P with the derived parameters (all flags set to true)
flagT = true;
flagS = true;
flagSbase = true;
[P] = CompleteP(P, flagT, flagS, flagSbase);

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
save('Best_fit_Seri', "P");

rmpath('..\Functions\')
cd(current_path)
clear current_path
