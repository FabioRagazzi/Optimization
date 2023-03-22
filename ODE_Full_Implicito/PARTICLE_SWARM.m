clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\ODE_Full_Implicito\')
addpath('Functions\')
fprintf("-> FITTING WITH PARTICLE SWARM\n")

load('data\Data_for_fit_Seri.mat');

% ex -> the parameter is an exponent 
% li -> the parameter is a linear parameter
      %ex    %ex    %li      %ex    %ex    %ex   %ex
      %mu    %n0t   %phi     %B     %D     %S    %n0
lb = [-15,    20,    1,      -4,    -4,    -4,    19];
ub = [-12,    25,    1.5,     2,     2,     2,    23];

options = optimoptions('particleswarm');
options.UseParallel = true; %false
options.FunctionTolerance = 1e-3; %1e-6
options.MaxIterations = 1e5; %200*nvars
options.MaxStallIterations = 20; %20
options.Display = 'final'; %final

tic
[xv,~,~,output] = particleswarm(@(parametri)objective_function_J_PS(parametri, Jobjective, time_instants, P), length(ub), lb, ub, options);
toc
disp(xv)

save('data\most_recent_output_PS','xv')

rmpath('Functions\')
cd(current_path)
clear current_path
