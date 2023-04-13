clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC\')
addpath('Functions\')
fprintf("-> FITTING WITH TRRA THE NORDIC MODEL\n")

load('data\Data_for_fit_Seri_N0trap_1e5.mat');
% load('Parameters\Best_fit_Seri.mat')

% Specyfing the parameter to fit

% CLASSIC
names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "N_deep(1)", "mu_h"]; 
tags = [1, 2, 3, 4, 5, 6, 7];
exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1]);
equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
          {"S1",4}, {"S2",4}, {"S3",4}....
          {"n_start(2)",5}, {"N_deep(2)",6}, {"mu_e",7}};
lb = [1.0,  -5,  -5,  -5,  18,  19, -15];
ub = [1.5,   3,   3,   3,  24,  26, -12];

% names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "N_deep(1)"]; 
% tags = [1, 2, 3, 4, 5, 6];
% exp_lin_flags = logical([0, 1, 1, 1, 1, 1]);
% equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
%           {"S1",4}, {"S2",4}, {"S3",4}, ....
%           {"n_start(2)",5}, {"N_deep(2)",6}};
% lb = [1.1,  -4,  -4,  -4,  19,  20];
% ub = [1.5,   2,   2,   2,  23,  25];

% names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "N_deep(1)", "a_int(1)", "w_hop(1)", "a_sh(1)"]; 
% tags = [1, 2, 3, 4, 5, 6, 7, 8, 9];
% exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1, 0, 1]);
% equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
%           {"S1",4}, {"S2",4}, {"S3",4}, ....
%           {"n_start(2)",5}, {"N_deep(2)",6}, ... 
%           {"a_int(2)",7}, {"w_hop(2)",8}, {"a_sh(2)",9}};
% lb = [1.1,  -4,  -4,  -4,  19,  20,  -9,  0.5,  -11];
% ub = [1.5,   2,   2,   2,  23,  25,  -5,  0.9,   -7];

% % MOBILITY DEPENDENT ON E
% names = ["a_int", "w_hop", "a_sh"]; 
% tags = [1, 1, 2, 2, 3, 3];
% exp_lin_flags = logical([1, 0, 1]);
% equals = {};
% lb = [-10,  -10,   0.5,   0.5,  -12,  -12];
% ub = [-7 ,   -7,   0.7,   0.7,   -9,   -9];

% % FULL NORDIC 
% names = ["a_int(1)", "w_hop(1)", "a_sh(1)",...
%          "w_tr_int(1)", "N_int(1)", "N_deep(1)",...
%          "w_tr_hop(1)", "w_tr(1)", "S_base(1)",...
%          "n_start(1)", "phih"]; 
% tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11];
% exp_lin_flags = logical([1, 0, 1,...
%                          0, 1, 1,...
%                          0, 0, 1,...
%                          1, 0]);
% equals = {{"a_int(2)",1}, {"w_hop(2)",2}, {"a_sh(2)",3}, ...
%           {"w_tr_int(2)",4}, {"N_int(2)",5}, {"N_deep(2)",6}, ....
%           {"w_tr_hop(2)",7}, {"w_tr(2)",8}, {"S_base(2)",9}, {"S_base(3)",9}, {"S_base(4)",9},...
%           {"n_start(2)",10}, {"phie",11}};
% lb = [-9,  0.5,  -11,  0.5,  20,  18,  0.8,  0.8,  -6,  19,  1.1];
% ub = [-5,  0.9,  - 7,  0.9,  26,  22,  1.2,  1.2,  -1,  23,  1.5];

[F.flagT, F.flagS, F.flagSbase] = flags_from_names(names);

Num_swipes = 5;
if Num_swipes > 1
    delta_bounds = (ub - lb) / (Num_swipes-1);
end

% Specifying the options for TRRA
options = optimoptions('lsqnonlin');
options.Display = 'iter';
option.StepTolerance = 1e-8; % 1e-6
options.OptimalityTolerance = 1e-8; % 1e-6
options.FunctionTolerance = 1e-8; % 1e-6
options.UseParallel = true;

% Specifying the options for the ODE
ODE_options = odeset('Stats','off');

% Setting the flags for the electric field dependency
E_flags = false(1,4);
E_flags(1) = false; %(mu) set to true to have a mobility dependent on the electric field
E_flags(2) = false; %(B) set to true to have a trapping coefficient dependent on the electric field
E_flags(3) = false; %(D) set to true to have a detrapping coefficient dependent on the electric field
E_flags(4) = false; %(S) set to true to have the recombination coefficients dependent on the electric field

% Defining the objective function
obj_func_TRRA = @(x) objective_function_J_NM("TRRA", x, tags, names, exp_lin_flags, equals, P, F,...
                                                  time_instants, E_flags, ODE_options, Jobjective);

% Starting a loop to try different starting points in the TRRA 
xv = zeros(Num_swipes, length(lb));
x0 = zeros(Num_swipes, length(lb));
for i = 1:Num_swipes
%     x0 = [1.3090    -0.4318    -1.4241    -2.8589    19.4116    24.0893]; % to manually select the initial guess
%     x0(i,:) = lb + delta_bounds * (i-1);
    x0(i,:) = RandomX0(lb, ub); 

    tic
    [xv(i,:),~,~,~,output] = lsqnonlin(obj_func_TRRA, x0(i,:), lb, ub, options); 
    toc
    disp(xv(i,:))
    save('data\most_recent_output_TRRA','xv')
   
    % After TRRA finished, launching a simulation to see the result
    flag_n = true; % do this to get an error if number density becomes < 0
    [out] = nordicODE_updating(xv(i,:), tags, names, exp_lin_flags, equals, P, F, time_instants, E_flags, ODE_options, flag_n);
    
    figure
    compare_Sato_JdDdt(out, Jobjective, time_instants)
    title("Swipe #" + num2str(i) + " in TRRA")
end

rmpath('Functions\')
cd(current_path)
clear current_path
