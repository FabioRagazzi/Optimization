clearvars, clc, close all
addpath('Functions\')

% Loading data to fit
load('data\Data_Seri.mat');

% Creating a reference parameter structure for the simulation
P = Parameters("BEST_FIT_SERI");

% Specyfing the parameters to fit
[names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP("CLASSIC");

Num_swipes = 10;
if Num_swipes > 1
    delta_bounds = (ub - lb) / (Num_swipes-1);
end

% Specifying the options for TRRA
OPT_options = optimoptions('lsqnonlin');
OPT_options.Display = 'iter';
OPT_options.StepTolerance = 1e-3; % 1e-6
OPT_options.OptimalityTolerance = 1e-3; % 1e-6
OPT_options.FunctionTolerance = 1e-3; % 1e-6
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
func = @(x) ObjectiveFunctionJ("TRRA", x, tags, names, exp_lin_flags, equals, P, time_instants, Jobjective, options);

% Starting a loop to try different starting points in the TRRA 
xv = zeros(Num_swipes, length(lb));
x0 = zeros(Num_swipes, length(lb));
for i = 1:Num_swipes
%     x0 = [1.3090    -0.4318    -1.4241    -2.8589    19.4116    24.0893]; % to manually select the initial guess
%     x0(i,:) = lb + delta_bounds * (i-1);
    x0(i,:) = RandomX0(lb, ub); 

    TRRA_start_time = tic;
    [xv(i,:), ~, ~, ~, output] = lsqnonlin(func, x0(i,:), lb, ub, OPT_options);
    TRRA_elapsed_time = toc(TRRA_start_time);
    disp(xv(i,:))
    fprintf("Elpsed time is: %f\n\n\n\n", TRRA_elapsed_time)
    save('data\most_recent_output_TRRA','xv','x0')
end  
% After TRRA finished, launch simulations to see the results
options.flag_n = 1; % do this to get an error if number density becomes < 0
for i = 1:Num_swipes
    [out] = RunODEUpdating(xv(i,:), tags, names, exp_lin_flags, equals, P, time_instants, options);
    figure
    CompareSatoJdDdt(out, Jobjective, time_instants)
    title("Swipe #" + num2str(i) + " in TRRA")
end

rmpath('Functions\')
