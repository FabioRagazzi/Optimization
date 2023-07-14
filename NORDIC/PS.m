clc, clearvars, close all
addpath('Functions\')

% loading data to fit
load('data\Data_Seri.mat');

% creating a reference parameter structure for the simulation
P = Parameters("BEST_FIT_SERI");

% specyfing the parameters to fit
[names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP("FULL_CLASSIC");

% specifying the options for PS
OPT_options = optimoptions('particleswarm');
OPT_options.Display = 'final';
OPT_options.FunctionTolerance = 1e-6; % 1e-6
OPT_options.MaxIterations = 200*16; % 200*nvars
OPT_options.MaxStallIterations = 20; % 20
OPT_options.UseParallel = true;

% specifying the options for the simulation
options = DefaultOptions();
% options.flagMu = 1;
% options.flagB = 1;
% options.flagD = 1;
% options.flagS = 1;

% defining the objective function
func = @(x) ObjectiveFunctionJ("PS", x, tags, names, exp_lin_flags, equals, P, time_instants, Jobjective, options);

PS_start_time = tic;
[xv, ~, ~, output] = particleswarm(func, length(ub), lb, ub, OPT_options);
PS_elapsed_time = toc(PS_start_time);
disp(xv)
fprintf("Elpsed time is: %f\n\n\n\n", PS_elapsed_time)
save('data\most_recent_output_PS','xv')

% play sound to signal simulation ended
beep

% xv = [-7.6251	0.6710	-9.9046	0.9996	22.1978	24.9810	0.9008	1.0000	-25.0000	19.8143	1.1641	0.5000];

% after PS finished, launch a simulation to see the results
[out] = RunODEUpdating(xv, tags, names, exp_lin_flags, equals, P, time_instants, options);
fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );
figure
CompareSatoJdDdt(out, Jobjective, time_instants)
title("Fit with PS, fitness = " + num2str(fitness_value))
