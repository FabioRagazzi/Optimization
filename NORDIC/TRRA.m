clearvars, clc, close all
addpath('Functions\')

% Loading data to fit
load('data\Data_Seri.mat');

% Creating a reference parameter structure for the simulation
P = Parameters("BEST_FIT_SERI_MOB_&_B_E");

% Specyfing the parameters to fit
[names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP("ONLY_S_E");

Num_swipes = 10;
if Num_swipes > 1
    delta_bounds = (ub - lb) / (Num_swipes-1);
end

% Specifying the options for TRRA
OPT_options = optimoptions('lsqnonlin');
OPT_options.Display = 'iter';
OPT_options.StepTolerance = 1e-6; % 1e-6
OPT_options.OptimalityTolerance = 1e-6; % 1e-6
OPT_options.FunctionTolerance = 1e-6; % 1e-6
OPT_options.UseParallel = true;

% Specifying the options for the simulation
options.flagMu = 1;
options.flagB = 1;
options.flagD = 1;
options.flagS = 1;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.display = "Off";
options.ODE_options = odeset('Stats','off', 'Events',@(t,y)EventFcn(t,y));

% Defining the objective function
func = @(x)ObjectiveFunctionJ("TRRA", x, tags, names, exp_lin_flags, equals, P, time_instants, Jobjective, options);

% Starting a loop to try different starting points in the TRRA 
xv = zeros(Num_swipes, length(lb));
x0 = zeros(Num_swipes, length(lb));
for i = 1:Num_swipes
%     x0(i,:) = [1.2    -0.6990    -2.5229    -19.7953    19.4771    21    -12.3010]; % to manually select the initial guess
%     x0(i,:) = [1.3090    -0.4318    -1.4241      -21.6542    19.4116    24.0893  -7    0.75   1e-9]; % to manually select the initial guess
%     x0(i,:) = lb + delta_bounds * (i-1);
    x0(i,:) = RandomX0(lb, ub); 

    fprintf("STARTING SIMULATION %d / %d\n", i, Num_swipes)
    TRRA_start_time = tic;
    [xv(i,:), ~, ~, ~, output] = lsqnonlin(func, x0(i,:), lb, ub, OPT_options);
    TRRA_elapsed_time = toc(TRRA_start_time);
    disp(xv(i,:))
    fprintf("Elapsed time is: %f\n\n\n\n", TRRA_elapsed_time)
    save('data\most_recent_output_TRRA','xv','x0')
end  

% Play sound to signal simulation ended
beep

% xv(1,:) = [1.4614   -2.8242   -0.9264  -19.4363   19.8986   20.1257   -8.6806    0.5180   -8.8524];
% After TRRA finished, launch simulations to see the results
for i = 1:Num_swipes
    [out] = RunODEUpdating(xv(i,:), tags, names, exp_lin_flags, equals, P, time_instants, options);
    fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );
    figure
    CompareSatoJdDdt(out, Jobjective, time_instants)
    title("Swipe #" + num2str(i) + " in TRRA, fitness = " + num2str(fitness_value))
end

rmpath('Functions\')
