clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC\')
addpath('Functions\')
fprintf("-> FITTING WITH TRRA THE NORDIC MODEL\n")

load('data\Data_for_fit_Seri.mat');

% Specyfing the parameter of the model to fit
names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "mu_h"]; 
tags = [1, 2, 3, 4, 5, 6];
exp_lin_flags = logical([0, 1, 1, 1, 1, 1]);
equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
          {"S1",4}, {"S2",4}, {"S3",4}....
          {"n_start(2)",5}, {"mu_e",6}};
lb = [1,      -10,     -10,    -10,      17,    -16];
ub = [1.5,     10,      10,     10,      25,    -11];
x0 = [1.2,     -1,       2,     -3,      20,    -13];

% Specifying the options for TRRA
options = optimoptions('lsqnonlin');
options.Display = 'iter';
options.OptimalityTolerance = 1e-8; % 1e-6
options.FunctionTolerance = 1e-10; % 1e-6
options.UseParallel = true;

% Specifying the options for the ODE
ODE_options = odeset('Stats','off');

% Setting the flags for the electric field dependency
E_flags = false(1,4);
E_flags(1) = false; %(mu) set to true to have a mobility dependent on the electric field
E_flags(2) = false; %(B) set to true to have a trapping coefficient dependent on the electric field
E_flags(3) = false; %(D) set to true to have a detrapping coefficient dependent on the electric field
E_flags(4) = false; %(S) set to true to have the recombination coefficients dependent on the electric field

obj_func_TRRA = @(x) objective_function_J_TRRA_NM(x, tags, names, exp_lin_flags, equals, Parameters, ...
                                                  time_instants, E_flags, ODE_options, Jobjective);
tic
[xv,~,~,~,output] = lsqnonlin(obj_func_TRRA, x0, lb, ub, options); 
toc
disp(xv)
save('data\most_recent_output_TRRA','xv')

% After TRRA finished launching a simulation to see the result
[out] = nordicODE_updating(xv, tags, names, exp_lin_flags, equals, Parameters, time_instants, E_flags, ODE_options);

compare_Sato_JdDdt(out)

rmpath('Functions\')
cd(current_path)
clear current_path
