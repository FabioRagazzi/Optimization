clearvars, clc, close all
addpath('Functions\')

% Creating the parameters for the simulation
P = Parameters("BEST_FIT_SERI_MOB_&_B_&_D_&_S_E");

% Specifying the time instants that will be outputted
% time_instants = linspace(0, 100);
% time_instants = [0, logspace(0, 5, 99)] + 4.469412622781944;
% time_instants = linspace(1,60);
load("data\Data_Seri.mat")

% Specifying the options for the simulation
options.flagMu = 1;
options.flagB = 1;
options.flagD = 1;
options.flagS = 1;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.display = "Off";
options.ODE_options = odeset('Stats','off', ...
                             'Events',@(t, n_stato)EventFcn(t, n_stato));
                             
[out] = RunODE(P, time_instants, options);
% fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );

load("data\Data_Seri.mat")
CompareSatoJdDdt(out, Jobjective, time_instants)
% CompareSatoJdDdt(out)

% Movie(P.x_int, out.nht, 0.1)
% Movie(P.x_int, out.ne, 0.1)

rmpath('Functions\')
