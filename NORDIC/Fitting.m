%% LE ROY SYMMETRIC TRRA
MY_START()
load('data\Data_Seri.mat');
P = Parameters("TRUE_LE_ROY");
[names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP("TRUE_CLASSIC");
Num_swipes = 10;
options = DefaultOptions();

% Specifying the options for TRRA
OPT_options = optimoptions('lsqnonlin');
OPT_options.Display = 'iter';
OPT_options.StepTolerance = 1e-6; % 1e-6
OPT_options.OptimalityTolerance = 1e-6; % 1e-6
OPT_options.FunctionTolerance = 1e-6; % 1e-6
OPT_options.UseParallel = true;

rng default
func = @(x)ObjectiveFunctionJ("TRRA", x, tags, names, exp_lin_flags, ...
                              equals, P, time_instants, Jobjective, options);

xv = zeros(Num_swipes, length(lb));
x0 = zeros(Num_swipes, length(lb));
for i = 1:Num_swipes
    x0(i,:) = RandomX0(lb, ub); 
    fprintf("STARTING SIMULATION %d / %d\n", i, Num_swipes)
    TRRA_start_time = tic;
    [xv(i,:), ~, ~, ~, output] = lsqnonlin(func, x0(i,:), lb, ub, OPT_options);
    TRRA_elapsed_time = toc(TRRA_start_time);
    disp(xv(i,:))
    fprintf("Elapsed time is: %f\n\n\n\n", TRRA_elapsed_time)
    save('data\most_recent_output_TRRA','xv','x0')
end  
beep

for i = 1:Num_swipes
    try
        [out] = RunODEUpdating(xv(i,:), tags, names, exp_lin_flags, equals, P, time_instants, options);
        fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );
        PlotFitResult(out, Jobjective, time_instants)
        title("Swipe #" + num2str(i) + " in TRRA, fitness = " + num2str(fitness_value))
    catch
    end
end

%%
function [] = MY_START()
    clearvars, clc, close all
    addpath('Functions\')
end

function [path] = export_path_eps()
    path = "C:\Users\Faz98\Documents\LAVORO\2023_OPTIMIZATION\Figures\eps\";
end

function [path] = export_path_png()
    path = "C:\Users\Faz98\Documents\LAVORO\2023_OPTIMIZATION\Figures\png\";
end

function [fig] = PlotFitResult(out, fit_objective, time_objective)
    fig = figure();
    loglog(fig, out.tout, out.J_Sato, 'k-', 'LineWidth', 2, 'DisplayName','Optimization result')
    hold on
    loglog(time_objective, fit_objective, 'r.', 'MarkerSize', 10, 'DisplayName','Objective')
    grid on
    legend
    xlabel('$t (\mathrm{s})$', 'Interpreter','latex')
    ylabel('$J (\mathrm{\frac{A}{m^2}})$', 'Interpreter','latex')
    set(gca,'TickLabelInterpreter','latex', 'Xscale','log', 'Yscale','log', 'FontSize',15)
end
