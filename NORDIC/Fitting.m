%% FITTING PP SERI
% [xv, output] = MY_TRRA("START_PP_SERI", "TRUE_CLASSIC", "Data_PP", 10);
[xv, output] = MY_PS("START_PP_SERI", "TRUE_CLASSIC", "Data_PP");

%% FITTING PP SERI RESULT
xv = [1.26918057560840,-1.36941496730563,1.33647119469998,-18.7068570711036,18.3037404982900,...
      21.2505579354235,-11];
DispFitResults("START_PP_SERI", "TRUE_CLASSIC", "Data_PP", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% FITTING XLPE SERI
% [xv, output] = MY_PS("START_XLPE_SERI", "FULL_NORDIC_NON_SYMMETRIC_LARGE", "Data_XLPE", "Doedens");
[xv, output] = MY_PS("START_XLPE_SERI", "FULL_TRUE_CLASSIC", "Data_XLPE", "Doedens");

%% FITTING XLPE SERI RESULT 1
xv = [-6.21924476161837,-6.45362642202462,0.793005259372378,0.878473385454713,-8.34201379366606,...
      -8.13875222009366,0.535026075456034,0.632437777592963,22.7082806634559,22.8944035055223,...
      18.7767002481071,20.5756271490805,1.06054030298891,1.10689574343425,0.951555269494678,...	
      0.928049113481009,-22.0130681703340,-20.7137106683941,-23.9915325709671,-18.4923739338282,...	
      19.4790458463077,19.2088790577598,1.26693178239417,1.19079262543002,0.921724358603225];
DispFitResults("START_XLPE_SERI", "FULL_NORDIC_NON_SYMMETRIC", "Data_XLPE", xv, "Doedens")

%% FITTING XLPE SERI RESULT 2
xv = [-9.35097270785221,-11.9467680246605,1.48337975881124,0.302415510917004,-12.5517806496643,...
      -13.5268122284071,1.31075828129823,1.21174398938576,18.1708367329943,18.8681828289692,...
      18.8994577479176,21.5062094295260,0.439016070591408,0.434742260379139,0.581291586600989,...
      0.226379265996608,-22.1949253574677,-33.9806888542678,-32.1566313438777,-34.6171587851871,...
      13.5935114777230,20.2416314376150,1.54265547308282,1.99909118274077,0.100000000000000];
DispFitResults("START_XLPE_SERI", "FULL_NORDIC_NON_SYMMETRIC_LARGE", "Data_XLPE", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY SYMMETRIC TRRA
[xv, output] = MY_TRRA("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_Seri", 20);
% 10 -> 420 s 20°C
% 20 -> 400 s 60°C rng default

%% LE ROY SYMMETRIC TRRA 20°C
xv = [1.14466152869048,-0.205394026303417,0.852727895646774,-22.9032974939108,...
    19.5520981621147,19.6625441200987,-12.5504216616092];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_Seri", xv)

%% LE ROY SYMMETRIC TRRA 60°C
xv = [1.17186544044036,-2.21253557417779,1.15927067238965,-19.8054600313473,19.2947389761163,...
      21.0013275821345,-12.5183887836011];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_Seri", xv)


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY SYMMETRIC PS
[xv, output] = MY_PS("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_Seri");
% 9370 s

%% LE ROY SYMMETRIC PS RESULT
xv = [0.985584840519110,-3.51829804276860,1.22735925525313,-20.0834363570646,...	
      20.0050440290858,21.8356502131041,-12.9837477717737];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_Seri", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY NON SYMMETRIC TRRA
[xv, output] = MY_TRRA("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_Seri", 100);
% 920 s

%% LE ROY NON SYMMETRIC TRRA RESULT
xv = [1.11986196979152,1.12151928259801,-1.20480069136874,-1.81440855231278,1.28936394364191,...
      0.867652918437877,-22.7638328429688,-23.4800007156268,-19.3683964974054,-22.7659528712114,...
      17.9413581552390,18.7588926597861,19.1447662601155,21.2097031019959,-13.0620785104073,...
      -14.3926178995349];
DispFitResults("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_Seri", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY NON SYMMETRIC PS
[xv, output] = MY_PS("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_Seri");
% 22103

%% LE ROY NON SYMMETRIC PS RESULT
xv = [1.02527804627667,1.11383993536304,-1.83893085373972,-2.64948915797569,1.38712029764445,...
      1.22660921404251,-23.8508696848515,-20.1130718517903,-21.7738389270539,-22.1041896265616,...
  	  18.8147853517462,18.2456474781861,22.5228209183392,22.2628264362716,-12.5308547365440,...
      -11.0000000057027];
DispFitResults("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_Seri", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS SYMMETRIC TRRA
[xv, output] = MY_TRRA("NORDIC_START_FIT", "FULL_NORDIC", "Data_Seri", 10, "Doedens");
% 440 s

%% DOEDENS SYMMETRIC TRRA RESULT
xv = [-5.96421299945314,0.709193084021555,-8.50577386892104,0.625825812877258,24.1816363024905,...
      21.4958715527729,1.08811192998616,0.819224468304739,-24.0459564218075,...
  	  19.2978728533116,1.10413382781455,0.522850307947828];
DispFitResults("NORDIC_START_FIT", "FULL_NORDIC", "Data_Seri", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS SYMMETRIC PS
[xv, output] = MY_PS("NORDIC_START_FIT", "FULL_NORDIC", "Data_Seri", "Doedens");
% 2721

%% DOEDENS SYMMETRIC PS RESULT
xv = [-8.99979933650981,0.500056989437757,-9.07872469235397,0.538349179975172,25.9739700157571,...
      21.9976139812332,0.801975306264041,0.847956795556850,-24.9983837578946,19.3275963521225,...
  	  1.10000000000000,0.500001275595050];
DispFitResults("NORDIC_START_FIT", "FULL_NORDIC", "Data_Seri", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS NON SYMMETRIC TRRA
[xv, output] = MY_TRRA("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", 100, "Doedens");

%% DOEDENS NON SYMMETRIC TRRA RESULT
% None



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS NON SYMMETRIC PS
[xv, output] = MY_PS("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", "Doedens");
% 30737

%% DOEDENS NON SYMMETRIC PS RESULT
xv = [-6.31644936554235,-5.00027975810908,0.676823289934431,0.675910728186360,-9.59768333050806,...
      -9.44471059028319,0.690529581299641,0.685030512407795,25.8416619094333,23.5553326472779,...	
      21.8521206326506,21.9337672066199,1.16306094816778,1.20000000000000,1.19899603917177,...
      0.834802345055576,-25,-24.9249505394296,-24.9997395580170,-25,19.2210983828365,19.0000004248512,...
  	  1.10000000198334,1.10000006742579,0.500000000157463];
DispFitResults("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



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

function [] = DispFitResults(param_string, reference_string, data_string, xv, type)
    arguments
        param_string
        reference_string
        data_string
        xv
        type char {mustBeMember(type,{'Doedens','LeRoy'})} = 'LeRoy'
    end
    MY_START()
    load("data\" + data_string + ".mat");
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
    format long
    disp(fitness_value)
    format short
    %title(num2str(fitness_value))
end

function [xv, output] = MY_TRRA(param_string, reference_string, data_string, Num_swipes, type)
    arguments
        param_string
        reference_string
        data_string
        Num_swipes
        type char {mustBeMember(type,{'Doedens','LeRoy'})} = 'LeRoy'
    end
    MY_START()
    load("data\" + data_string + ".mat");
    P = Parameters(param_string);
    [names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP(reference_string);
    options = DefaultOptions();
    if type == "Doedens"
        options.flagB = 1;
        options.flagD = 1;
        options.flagMu = 1;
        options.flagS = 1;
    end
%     options.display = "On";
    
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

function [xv, output] = MY_PS(param_string, reference_string, data_string, type)
    arguments
        param_string
        reference_string
        data_string
        type char {mustBeMember(type,{'Doedens','LeRoy'})} = 'LeRoy'
    end
    MY_START()
    load("data\" + data_string + ".mat");
    P = Parameters(param_string);
    [names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP(reference_string);
    options = DefaultOptions();
    if type == "Doedens"
        options.flagB = 1;
        options.flagD = 1;
        options.flagMu = 1;
        options.flagS = 1;
    end
    options.display = "On";
    
    % specifying the options for PS
    OPT_options = optimoptions('particleswarm');
    OPT_options.Display = 'final';
    OPT_options.FunctionTolerance = 1e-6; % 1e-6
%     OPT_options.MaxIterations = 200*7; % 200*nvars
    OPT_options.MaxStallIterations = 20; % 20
    OPT_options.UseParallel = true;
    
%     rng default
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
