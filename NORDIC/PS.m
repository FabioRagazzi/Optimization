clc, clearvars, close all
addpath('Functions\')

% Loading data to fit
load('data\Data_Seri.mat');

% Creating a reference parameter structure for the simulation
P = Parameters("BEST_FIT_SERI");

% Specyfing the parameters to fit
[names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP("CLASSIC");

% Specifying the options for PS
OPT_options = optimoptions('particleswarm');
OPT_options.Display = 'iter';
OPT_options.FunctionTolerance = 1e-1; % 1e-6
OPT_options.MaxIterations = 200; % 200*nvars
OPT_options.MaxStallIterations = 5; % 20
OPT_options.UseParallel = true;

% Specifying the options for the simulation
options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flag_n = 0;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off');

% Defining the objective function
func = @(x) ObjectiveFunctionJ("PS", x, tags, names, exp_lin_flags, equals, P, time_instants, Jobjective, options);

PS_start_time = tic;
[xv, ~, ~, output] = particleswarm(func, length(ub), lb, ub, OPT_options);
PS_elapsed_time = toc(PS_start_time);
disp(xv)
fprintf("Elpsed time is: %f\n\n\n\n", PS_elapsed_time)
save('data\most_recent_output_PS','xv')

% After PS finished, launch a simulation to see the results
options.flag_n = 1; % do this to get an error if number density becomes < 0
[out] = RunODEUpdating(xv, tags, names, exp_lin_flags, equals, P, time_instants, options);

figure
CompareSatoJdDdt(out, Jobjective, time_instants)
title("Fit with PS")

rmpath('Functions\')
