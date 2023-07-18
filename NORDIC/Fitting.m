%% LE ROY SYMMETRIC TRRA
[xv, output] = MY_TRRA("TRUE_LE_ROY", "TRUE_CLASSIC", 10);
% 420 s

%% LE ROY SYMMETRIC TRRA RESULT
xv = [1.14466152869048,-0.205394026303417,0.852727895646774,-22.9032974939108,...
    19.5520981621147,19.6625441200987,-12.5504216616092];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", xv)



%% LE ROY SYMMETRIC PS
[xv, output] = MY_PS("TRUE_LE_ROY", "TRUE_CLASSIC");
% 9370 s

%% LE ROY SYMMETRIC PS RESULT
xv = [0.985584840519110,-3.51829804276860,1.22735925525313,-20.0834363570646,...	
      20.0050440290858,21.8356502131041,-12.9837477717737];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", xv)



%% LE ROY NON SYMMETRIC TRRA
[xv, output] = MY_TRRA("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", 100);
% 920 s

%% LE ROY NON SYMMETRIC TRRA RESULT
xv = [1.11986196979152,1.12151928259801,-1.20480069136874,-1.81440855231278,1.28936394364191,...
      0.867652918437877,-22.7638328429688,-23.4800007156268,-19.3683964974054,-22.7659528712114,...
      17.9413581552390,18.7588926597861,19.1447662601155,21.2097031019959,-13.0620785104073,...
      -14.3926178995349];
DispFitResults("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", xv)



%% LE ROY NON SYMMETRIC PS
[xv, output] = MY_PS("TRUE_LE_ROY", "FULL_TRUE_CLASSIC");



%% DOEDENS SYMMETRIC TRRA
[xv, output] = MY_TRRA("NORDIC_START_FIT", "FULL_NORDIC", 10, "Doedens");
% 440 s

%% DOEDENS SYMMETRIC TRRA RESULT
xv = [-5.96421299945314,0.709193084021555,-8.50577386892104,0.625825812877258,24.1816363024905,...
      21.4958715527729,1.08811192998616,0.819224468304739,-24.0459564218075,...
  	  19.2978728533116,1.10413382781455,0.522850307947828];
DispFitResults("NORDIC_START_FIT", "FULL_NORDIC", xv, "Doedens")



%% DOEDENS SYMMETRIC PS
[xv, output] = MY_PS("NORDIC_START_FIT", "FULL_NORDIC", "Doedens");


%% DOEDENS NON SYMMETRIC TRRA
[xv, output] = MY_TRRA("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", 100, "Doedens");

%% DOEDENS NON SYMMETRIC TRRA RESULT
% None



%% DOEDENS NON SYMMETRIC PS
[xv, output] = MY_PS("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", "Doedens");



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
    ax = axes(fig);
    loglog(ax, out.tout, out.J_Sato, 'r.', 'MarkerSize', 15, 'DisplayName','Optimization result')
    hold on
    loglog(ax, time_objective, fit_objective, 'k-', 'LineWidth', 2, 'DisplayName','Objective')
    grid on
    legend('Interpreter','latex')
    xticks(10.^(0:1:10))
    yticks(10.^(-10:1:10))
    xlabel('$t (\mathrm{s})$', 'Interpreter','latex')
    ylabel('$J (\mathrm{\frac{A}{m^2}})$', 'Interpreter','latex')
    set(gca,'TickLabelInterpreter','latex', 'Xscale','log', 'Yscale','log', 'FontSize',15)
end

function [] = DispFitResults(param_string, reference_string, xv, type)
    arguments
        param_string
        reference_string
        xv
        type char {mustBeMember(type,{'Doedens','LeRoy'})} = 'LeRoy'
    end
    MY_START()
    load('data\Data_Seri.mat');
    P = Parameters(param_string);
    [names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP(reference_string);
    options = DefaultOptions();
    if type == "Doedens"
        options.flagB = 1;
        options.flagD = 1;
        options.flagMu = 1;
        options.flagS = 1;
    end
    [out] = RunODEUpdating(xv, tags, names, exp_lin_flags, equals, P, time_instants, options);
    fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );
    PlotFitResult(out, Jobjective, time_instants);
    title(num2str(fitness_value))
end

function [xv, output] = MY_TRRA(param_string, reference_string, Num_swipes, type)
    arguments
        param_string
        reference_string
        Num_swipes
        type char {mustBeMember(type,{'Doedens','LeRoy'})} = 'LeRoy'
    end
    MY_START()
    load('data\Data_Seri.mat');
    P = Parameters(param_string);
    [names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP(reference_string);
    options = DefaultOptions();
    if type == "Doedens"
        options.flagB = 1;
        options.flagD = 1;
        options.flagMu = 1;
        options.flagS = 1;
    end
    
    % Specifying the options for TRRA
    OPT_options = optimoptions('lsqnonlin');
    OPT_options.Display = 'iter';
    OPT_options.StepTolerance = 1e-6; % 1e-6
    OPT_options.OptimalityTolerance = 1e-6; % 1e-6
    OPT_options.FunctionTolerance = 1e-6; % 1e-6
    OPT_options.UseParallel = true;
    
%     rng default
    func = @(x)ObjectiveFunctionJ("TRRA", x, tags, names, exp_lin_flags, ...
                              equals, P, time_instants, Jobjective, options);
    
    xv = zeros(Num_swipes, length(lb));
    x0 = zeros(Num_swipes, length(lb));
    Total_time = 0;
    for i = 1:Num_swipes
        x0(i,:) = RandomX0(lb, ub); 
        fprintf("STARTING SIMULATION %d / %d\n", i, Num_swipes)
        TRRA_start_time = tic;
        [xv(i,:), ~, ~, ~, output] = lsqnonlin(func, x0(i,:), lb, ub, OPT_options);
        TRRA_elapsed_time = toc(TRRA_start_time);
        Total_time = Total_time + TRRA_elapsed_time;
        disp(xv(i,:))
        fprintf("Elapsed time is: %f\n\n\n\n", TRRA_elapsed_time)
        save('data\most_recent_output_TRRA','xv','x0')
    end  
    fprintf("The total elapsed time for %d swipes is: %f\n\n\n\n", Num_swipes, Total_time)
    beep
    
    for i = 1:Num_swipes
        try
            [out] = RunODEUpdating(xv(i,:), tags, names, exp_lin_flags, equals, P, time_instants, options);
            fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );
            PlotFitResult(out, Jobjective, time_instants);
            title("Swipe #" + num2str(i) + " in TRRA, fitness = " + num2str(fitness_value))
        catch
        end
    end
end

function [xv, output] = MY_PS(param_string, reference_string, type)
    arguments
        param_string
        reference_string
        type char {mustBeMember(type,{'Doedens','LeRoy'})} = 'LeRoy'
    end
    MY_START()
    load('data\Data_Seri.mat');
    P = Parameters(param_string);
    [names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP(reference_string);
    options = DefaultOptions();
    if type == "Doedens"
        options.flagB = 1;
        options.flagD = 1;
        options.flagMu = 1;
        options.flagS = 1;
    end
    
    % specifying the options for PS
    OPT_options = optimoptions('particleswarm');
    OPT_options.Display = 'final';
    OPT_options.FunctionTolerance = 1e-6; % 1e-6
    OPT_options.MaxIterations = 200*7; % 200*nvars
    OPT_options.MaxStallIterations = 20; % 20
    OPT_options.UseParallel = true;
    
    rng default
    func = @(x) ObjectiveFunctionJ("PS", x, tags, names, exp_lin_flags, ...
                                   equals, P, time_instants, Jobjective, options);
    
    PS_start_time = tic;
    [xv, ~, ~, output] = particleswarm(func, length(ub), lb, ub, OPT_options);
    PS_elapsed_time = toc(PS_start_time);
    disp(xv)
    fprintf("Elpsed time is: %f\n\n\n\n", PS_elapsed_time)
    save('data\most_recent_output_PS','xv')
    beep
    
    [out] = RunODEUpdating(xv, tags, names, exp_lin_flags, equals, P, time_instants, options);
    fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );
    PlotFitResult(out, Jobjective, time_instants);
    title("Fit with PS, fitness = " + num2str(fitness_value))
end