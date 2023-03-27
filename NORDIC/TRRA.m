clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC\')
addpath('Functions\')
fprintf("-> FITTING WITH TRRA THE NORDIC MODEL\n")

load('data\Data_for_fit_Seri.mat');

% ex -> the parameter is an exponent 
% li -> the parameter is a linear parameter
      %ex      %ex     %ex    %li      %ex    %ex    %ex   %ex
      %ext     %arg    %n0t   %phi     %B     %D     %S    %n0
lb = [-8,      -10,     20,    1,      -4,    -4,    -4,    19];
ub = [-2,      -1,      25,    1.5,     2,     2,     2,    23];
x0 = [-5,       -7,      21,    1.3,     -1,   -2,    -2,    20];

options = optimoptions('lsqnonlin');
options.Display = 'iter';
options.OptimalityTolerance = 1e-8; % 1e-6
options.FunctionTolerance = 1e-10; % 1e-6
options.UseParallel = true;

tic
[xv,~,~,~,output] = lsqnonlin(@(parametri) objective_function_J_TRRA_NM(parametri, Jobjective, time_instants, P), x0, lb, ub, options); 
toc
disp(xv)

save('data\most_recent_output_TRRA','xv')

rmpath('Functions\')
cd(current_path)
clear current_path