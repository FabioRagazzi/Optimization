clearvars, clc, close all
addpath('Functions\')

% creating the parameters for the simulation
PARAMETER_ID_NAME = "FULL_NORDIC_FIT_WITH_PS"; ParametersScript;
% P = Parameters("FULL_NORDIC_FIT_WITH_PS2");

% specifying the time instants that will be outputted
% time_instants = linspace(0, 100);
% time_instants = [0, logspace(0, 5, 99)];% + 4.469412622781944;
% time_instants = linspace(1,60);
load("data\Data_Seri.mat")

% specifying the options for the simulation
[options] = DefaultOptions();
options.flagMu = 1;
options.flagB = 1;
options.flagD = 1;
options.flagS = 1;
                             
[out] = RunODE(P, time_instants, options);
fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );

load("data\Data_Seri.mat")
CompareSatoJdDdt(out, Jobjective, time_instants)
title(fitness_value)
% CompareSatoJdDdt(out)

% Movie(P.x_int, out.nht, 0.1)
% Movie(P.x_int, out.ne, 0.1)

rmpath('Functions\')
