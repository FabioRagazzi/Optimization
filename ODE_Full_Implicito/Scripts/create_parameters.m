%% CHOOSE THE PARAMETERS
clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\ODE_Full_Implicito\Scripts')
addpath('..\Functions\')
fprintf("-> PARAMETERS\n")

% Geometry
P.L = 3.5e-4;
P.num_points = 100;
P.LW = 2e-5;
P.LE = 2e-5;
P.nW = 10;
P.nE = 10;

% P.LW = 0;
% P.LE = 0;
% P.nW = 0;
% P.nE = 0;

% Parameters
P.T = 60;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = P.L * 3e7;
P.mu_h = 1e-13;
P.mu_e = 1e-13;
P.nh0t = 1e25;
P.ne0t = 1e25;
P.phih = 1.3;
P.phie = 1.3;
P.Bh = 1e-2;
P.Be = 1e-2;
P.Dh = 1e-3;
P.De = 1e-3;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 4e-3;
P.n_start = [1e21, 1e21, 0, 0];

% % Check the parameters obtained by the optimization algorithm
% P.mu_h = 10^xv(1);
% P.mu_e = 10^xv(1);
% P.nh0t = 10^xv(2);
% P.ne0t = 10^xv(2);
% P.phih = xv(3);
% P.phie = xv(3);
% P.Bh = 10^xv(4);
% P.Be = 10^xv(4);
% P.Dh = 10^xv(5);
% P.De = 10^xv(5);
% P.S0 = 10^xv(6);
% P.S1 = 10^xv(6);
% P.S2 = 10^xv(6);
% P.S3 = 10^xv(6);
% P.n_start = [10^xv(7), 10^xv(7), 0, 0];

%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------
% FROM HERE DO NOT TOUCH !!!
%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------

% Physics constants
P.h = 6.62607015e-34;
P.e = 1.602176634e-19;
P.kB = 1.380649e-23;
P.eps0 = 8.854187817e-12;
P.abs0 = 273.15;
P.A = 1.20173e6;

% Derived parameters
P.a = P.A / P.e;
P.T = P.T + P.abs0;
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.beta = sqrt((P.e^3)/(4*pi*P.eps));
P.aT2exp = P.a * (P.T^2) * exp(-[P.phie, P.phih] * P.e / P.kBT); 
P.D_h = P.mu_h * P.kBT / P.e;
P.D_e = P.mu_e * P.kBT / P.e;
P.S0 = P.S0 * P.e;
P.S1 = P.S1 * P.e;
P.S2 = P.S2 * P.e;
P.S3 = P.S3 * P.e;
P.deltas = CreateDeltas(P.LW, P.LE, P.nW, P.nE, P.num_points, P.L);
P.EletStat = EletStat1D(P.deltas, P.eps, "sparse");
P.Vol = CreateV(P.deltas);

% Default Saving to INBOX
save("..\Parameters\INBOX", "P");

rmpath('..\Functions\')
cd(current_path)
clear current_path

% % This is usefull for a manual fitting of a polarization current
% cd('C:\Users\Faz98\Documents\GitHub\Optimization\ODE_Full_Implicito')
% ODE_Implicit;

%% SAVE THE PARAMETERS
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\ODE_Full_Implicito\Scripts')
addpath('..\Functions\')
fprintf("-> SAVE THE PARAMETERS\n")

parameters_save_name = "CONSTANT_SPACING";
save("..\Parameters\" + parameters_save_name, "P");

rmpath('..\Functions\')
cd(current_path)
clear current_path
