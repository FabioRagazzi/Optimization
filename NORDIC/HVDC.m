clearvars, clc, close all
addpath('Functions\')

% Creating the parameters for the simulation
P = Parameters("LE_ROY");

% Specifying the time instants that will be outputted
% time_instants = linspace(0, 100);
time_instants = [0, logspace(0, 5, 99)];

% Specifying the options for the simulation
options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flag_n = 1;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off');

[out] = RunODE(P, time_instants, options);

load("data\Data_Seri.mat")
CompareSatoJdDdt(out, Jobjective, time_instants)
% CompareSatoJdDdt(out)

% Movie(P.x_int, out.nht, 0.1)
% Movie(P.x_int, out.ne, 0.1)

rmpath('Functions\')
