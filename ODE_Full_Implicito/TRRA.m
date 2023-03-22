clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\ODE_Full_Implicito\')
addpath('Functions\')
fprintf("-> FITTING WITH TRRA\n")

load('data\Data_for_fit_Seri.mat');

% ex -> the parameter is an exponent 
% li -> the parameter is a linear parameter
      %ex    %ex    %li      %ex    %ex    %ex   %ex
      %mu    %n0t   %phi     %B     %D     %S    %n0
lb = [-15,    20,    1,      -4,    -4,    -4,    19];
ub = [-12,    25,    1.5,     2,     2,     2,    23];
x0 = [-13,    21,    1.3,     -1,   -2,    -2,    20];

options = optimoptions('lsqnonlin');
options.Display = 'iter';
options.OptimalityTolerance = 1e-8; % 1e-6
options.FunctionTolerance = 1e-10; % 1e-6
options.UseParallel = true;

tic
[xv,~,~,~,output] = lsqnonlin(@(parametri) objective_function_J_TRRA(parametri, Jobjective, time_instants, P), x0, lb, ub, options); 
toc
disp(xv)

save('data\most_recent_output_TRRA','xv')

rmpath('Functions\')
cd(current_path)
clear current_path
