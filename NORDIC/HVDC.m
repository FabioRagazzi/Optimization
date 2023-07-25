clearvars, clc%, close all
addpath('Functions\')

% creating the parameters for the simulation
% PARAMETER_ID_NAME = "NORDIC_STANDARD"; ParametersScript;
P = Parameters("START_SGI_SERI");

% specifying the time instants that will be outputted
% time_instants = linspace(0, 100);
% time_instants = [0, logspace(0, 5, 99)] + 4.469412622781944;
% time_instants = linspace(1,60);
load("data\Data_SGI.mat")
time_instants2 = [0, time_instants];

% specifying the options for the simulation
[options] = DefaultOptions();
% options.flagMu = 1;
% options.flagB = 1;
% options.flagD = 1;
% options.flagS = 1;
options.max_time = 10;
                             
[out] = RunODE(P, time_instants2, options);
% fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );


% CompareSatoJdDdt(out, J_SGI_original, t_SGI_original)
fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt(2:end)))./log10(Jobjective) );
CompareSatoJdDdt(out, Jobjective, time_instants)
title(fitness_value)
% CompareSatoJdDdt(out)

% Movie(P.x_int, out.nht, 0.1)
% Movie(P.x_int, out.ne, 0.1)
