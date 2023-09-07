%% GeneralOptimization
clearvars, clc, close all
rng default
for m = ["BLEND", "PP", "XLPE", "SGI"]
    for t = ["LeRoy", "Doedens"]
        for a = ["TRRA", "PS"]
            for s = ["Yes", "No"]
                [xv, wct, fitness] = GeneralOptimization(m, a, t, s);
            end
        end
    end
end

%% GeneralDispResults
clearvars, clc, close all
for m = ["BLEND", "PP", "XLPE", "SGI"]
    for t = ["LeRoy", "Doedens"]
        for a = ["TRRA", "PS"]
            for s = ["Yes", "No"]
                [result] = GeneralDispResults(m, a, t, s);
            end
        end
    end
end

%% TableResults
clearvars, clc, close all
T = cell(1,4);
k = 0;
for t = ["LeRoy", "Doedens"]
    for s = ["Yes", "No"]
        k = k + 1;
        tab = mytable(t,s);
        i = 0;
        for m = ["BLEND", "PP", "XLPE", "SGI"]
            for a = ["TRRA", "PS"]
                i = i + 1;
                current_result = load("res/" + m + "_" + a + "_" + t + "_" + s + ".mat");
                current_result = current_result.result;
                cell_array = cell(1,length(current_result.xv)+3);
                cell_array(1) = {m + " " + a};
                cell_array(2:end-2) = num2cell(current_result.xv);
                cell_array(end-1) = num2cell(current_result.fitness);
                cell_array(end) = num2cell(current_result.wct);
                tab(i,1:end) = cell_array;
            end
        end
        disp(tab)
        T{k} = tab;
    end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%% BLEND SYMMETRIC LE ROY TRRA
[xv, output] = MY_TRRA("START_BLEND_SERI", "TRUE_CLASSIC", "Data_BLEND", 20);

%% BLEND SYMMETRIC LE ROY TRRA RESULT
xv = [1.32310281975007,-0.0918262798750277,0.971670416153717,-22.5711156754095,19.3706748198428,...	
      19.4386760067290,-12.8521659613389];
DispFitResults("START_BLEND_SERI", "TRUE_CLASSIC", "Data_BLEND", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% SGI SYMMETRIC LE ROY TRRA
[xv, output] = MY_TRRA("START_SGI_SERI", "TRUE_CLASSIC", "Data_SGI", 20);

%% SGI SYMMETRIC LE ROY TRRA RESULT
xv = [1.25401912354342,-1.20034471776847,0.885474641143992,-20.3141942577816,17.7211623369495,...
      18.4716086410845,-12.8353318915172];
DispFitResults("START_SGI_SERI", "TRUE_CLASSIC", "Data_SGI", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% PP SYMMETRIC LE ROY TRRA
[xv, output] = MY_TRRA("START_PP_SERI", "TRUE_CLASSIC", "Data_PP", 20);

%% PP SYMMETRIC LE ROY TRRA RESULT
xv = [1.46398491013855,-2.88748878698830,1.45980803706502,-23.9976047136964,...
      20.2065879300356,20.6441718925240,-13.1279553336477];
DispFitResults("START_PP_SERI", "TRUE_CLASSIC", "Data_PP", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% PP NON SYMMETRIC LE ROY PS
[xv, output] = MY_PS("START_PP_SERI", "FULL_TRUE_CLASSIC", "Data_PP");

%% PP NON SYMMETRIC LE ROY PS RESULT
xv = [1.27873813416751,1.27572023033734,-5.44500482937879,-5.60927060316597,1.34804780720091,...
      0.751429063225356,-23.1023180349707,-20.8147084852354,-21.4991917803229,-21.5527085378617,...
  	  19.0836167425836,18.6503414038600,21.9204734393934,18.0143732787469,-14.8945433258179,...
  	 -11.2762782246860];
DispFitResults("START_PP_SERI", "FULL_TRUE_CLASSIC", "Data_PP", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% XLPE SYMMETRIC LE ROY TRRA
[xv, output] = MY_TRRA("START_XLPE_SERI", "TRUE_CLASSIC", "Data_XLPE", 20);

%% XLPE SYMMETRIC LE ROY TRRA RESULT
xv = [1.48516569772331,-4.07853669769302,1.32529472797869,-23.7805445219140,20.7595836782174,...
      20.6106743435557,-14.0203393552630];
DispFitResults("START_XLPE_SERI", "TRUE_CLASSIC", "Data_XLPE", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% XLPE NON SYMMETRIC LE ROY PS
[xv, output] = MY_PS("START_XLPE_SERI", "FULL_TRUE_CLASSIC", "Data_XLPE");

%% XLPE NON SYMMETRIC LE ROY PS RESULT
xv = [1.50000000000000,1.43354746543884,-5.91830373201479,0.764179073342868,0.500270117503534,...
      0.507941290678355,-20.4877330016408,-18.4322460033018,-23.2712439796579,-23.9781020818320,...
  	  20.8763442483004,20.8040662217656,22.4086111519853,19.2471427774611,-13.8448296755648,...
  	 -14.9999922181205];
DispFitResults("START_XLPE_SERI", "FULL_TRUE_CLASSIC", "Data_XLPE", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %




%% XLPE SYMMETRIC DOEDENS TRRA
[xv, output] = MY_TRRA("START_XLPE_SERI", "FULL_NORDIC", "Data_XLPE", 20, "Doedens");

%% XLPE SYMMETRIC DOEDENS TRRA RESULT
xv = [-7.28712086733337,0.783110140200551,-9.30410472738227,0.601771984468158,25.2650881328825,...
      19.2496939200255,0.897598706245208,0.886150103425552,-23.5945898171682,20.0128618590717,...
  	  1.16214150986390,0.501414694213317];
DispFitResults("START_XLPE_SERI", "FULL_NORDIC", "Data_XLPE", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY SYMMETRIC TRRA
[xv, output] = MY_TRRA("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_BLEND", 20);
% 10 -> 420 s 20°C
% 20 -> 400 s 60°C rng default

%% LE ROY SYMMETRIC TRRA 20°C
xv = [1.14466152869048,-0.205394026303417,0.852727895646774,-22.9032974939108,...
    19.5520981621147,19.6625441200987,-12.5504216616092];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_BLEND", xv)

%% LE ROY SYMMETRIC TRRA 60°C
xv = [1.17186544044036,-2.21253557417779,1.15927067238965,-19.8054600313473,19.2947389761163,...
      21.0013275821345,-12.5183887836011];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_BLEND", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY SYMMETRIC PS
[xv, output] = MY_PS("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_BLEND");
% 9370 s

%% LE ROY SYMMETRIC PS RESULT
xv = [0.985584840519110,-3.51829804276860,1.22735925525313,-20.0834363570646,...	
      20.0050440290858,21.8356502131041,-12.9837477717737];
DispFitResults("TRUE_LE_ROY", "TRUE_CLASSIC", "Data_BLEND", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY NON SYMMETRIC TRRA
[xv, output] = MY_TRRA("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_BLEND", 100);
% 920 s

%% LE ROY NON SYMMETRIC TRRA RESULT
xv = [1.11986196979152,1.12151928259801,-1.20480069136874,-1.81440855231278,1.28936394364191,...
      0.867652918437877,-22.7638328429688,-23.4800007156268,-19.3683964974054,-22.7659528712114,...
      17.9413581552390,18.7588926597861,19.1447662601155,21.2097031019959,-13.0620785104073,...
      -14.3926178995349];
DispFitResults("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_BLEND", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% LE ROY NON SYMMETRIC PS
[xv, output] = MY_PS("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_BLEND");
% 22103

%% LE ROY NON SYMMETRIC PS RESULT
xv = [1.02527804627667,1.11383993536304,-1.83893085373972,-2.64948915797569,1.38712029764445,...
      1.22660921404251,-23.8508696848515,-20.1130718517903,-21.7738389270539,-22.1041896265616,...
  	  18.8147853517462,18.2456474781861,22.5228209183392,22.2628264362716,-12.5308547365440,...
      -11.0000000057027];
DispFitResults("TRUE_LE_ROY", "FULL_TRUE_CLASSIC", "Data_BLEND", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS SYMMETRIC TRRA
[xv, output] = MY_TRRA("START_BLEND_SERI", "FULL_NORDIC", "Data_BLEND", 10, "Doedens");
% 440 s

%% DOEDENS SYMMETRIC TRRA RESULT
xv = [-5.96421299945314,0.709193084021555,-8.50577386892104,0.625825812877258,24.1816363024905,...
      21.4958715527729,1.08811192998616,0.819224468304739,-24.0459564218075,...
  	  19.2978728533116,1.10413382781455,0.522850307947828];
DispFitResults("NORDIC_START_FIT", "FULL_NORDIC", "Data_BLEND", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS SYMMETRIC PS
[xv, output] = MY_PS("NORDIC_START_FIT", "FULL_NORDIC", "Data_BLEND", "Doedens");
% 2721

%% DOEDENS SYMMETRIC PS RESULT
xv = [-8.99979933650981,0.500056989437757,-9.07872469235397,0.538349179975172,25.9739700157571,...
      21.9976139812332,0.801975306264041,0.847956795556850,-24.9983837578946,19.3275963521225,...
  	  1.10000000000000,0.500001275595050];
DispFitResults("NORDIC_START_FIT", "FULL_NORDIC", "Data_BLEND", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS NON SYMMETRIC TRRA
[xv, output] = MY_TRRA("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", "Data_BLEND", 100, "Doedens");

%% DOEDENS NON SYMMETRIC TRRA RESULT
% None



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% DOEDENS NON SYMMETRIC PS
[xv, output] = MY_PS("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", "Data_BLEND", "Doedens");
% 30737

%% DOEDENS NON SYMMETRIC PS RESULT
xv = [-6.31644936554235,-5.00027975810908,0.676823289934431,0.675910728186360,-9.59768333050806,...
      -9.44471059028319,0.690529581299641,0.685030512407795,25.8416619094333,23.5553326472779,...	
      21.8521206326506,21.9337672066199,1.16306094816778,1.20000000000000,1.19899603917177,...
      0.834802345055576,-25,-24.9249505394296,-24.9997395580170,-25,19.2210983828365,19.0000004248512,...
  	  1.10000000198334,1.10000006742579,0.500000000157463];
DispFitResults("NORDIC_START_FIT", "FULL_NORDIC_NON_SYMMETRIC", "Data_BLEND", xv, "Doedens")



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % NEW MEASURE FOUND!! % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%% SGI SYMMETRIC LE ROY TRRA
[xv, output] = MY_TRRA("START_SGI_SERI", "TRUE_CLASSIC", "Data_SGI", 20);

%% SGI SYMMETRIC LE ROY TRRA RESULT
xv = [1.25401912354342,-1.20034471776847,0.885474641143992,-20.3141942577816,17.7211623369495,...
      18.4716086410845,-12.8353318915172];
DispFitResults("START_SGI_SERI", "TRUE_CLASSIC", "Data_SGI", xv)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% SGI SYMMETRIC LE ROY PS
[xv, output] = MY_PS("START_SGI_SERI", "TRUE_CLASSIC", "Data_SGI");
% xv = [1.1139   -5.3216    0.6857  -22.8431   17.7419   21.5226  -15.0000];

%% SGI NON-SYMMETRIC LE ROY TRRA
[xv, output] = MY_TRRA("START_SGI_SERI", "FULL_TRUE_CLASSIC", "Data_SGI", 100);

%% SGI NON-SYMMETRIC LE ROY PS
[xv, output] = MY_PS("START_SGI_SERI", "FULL_TRUE_CLASSIC", "Data_SGI");
% xv = [1.2391    1.1362   -3.0564   -1.4791    0.5818    0.7068  -18.4519  -23.8309  -24.0000  -22.1278   17.2010   18.5385   19.1888   22.9133  -14.9189  -14.6785];



%%
function [] = MY_START()
    clearvars, clc, close all
    clear EventFcn ObjectiveFunctionJ
    addpath('Functions\')
end

function [path] = export_path_eps()
    path = "C:\Users\Faz98\Documents\LAVORO\2023_OPTIMIZATION\Figures\eps\";
end

function [path] = export_path_png()
    path = "C:\Users\Faz98\Documents\LAVORO\2023_OPTIMIZATION\Figures\png\";
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
    options.max_time = 5;
%     disp("Changig options")
%     options.max_time = 1e-10;
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
%     disp("Changig options")
%     options.max_time = 1e-10;
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
        save('data\most_recent_output\most_recent_output_TRRA','xv','x0')
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
%     disp("Changig options")
%     options.max_time = 1e-10;
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
    
    rng default
    func = @(x) ObjectiveFunctionJ("PS", x, tags, names, exp_lin_flags, ...
                                   equals, P, time_instants, Jobjective, options);
    
    PS_start_time = tic;
    [xv, ~, ~, output] = particleswarm(func, length(ub), lb, ub, OPT_options);
    PS_elapsed_time = toc(PS_start_time);
    disp(xv)
    fprintf("Elpsed time is: %f\n\n\n\n", PS_elapsed_time)
    save('data\most_recent_output\most_recent_output_PS','xv')
    beep
    
    [out] = RunODEUpdating(xv, tags, names, exp_lin_flags, equals, P, time_instants, options);
    fitness_value = norm( (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective) );
    PlotFitResult(out, Jobjective, time_instants);
    title("Fit with PS, fitness = " + num2str(fitness_value))

end

function [t] = mytable(a,b)

switch_var = a + "_" + b;
switch switch_var
    case "LeRoy_Yes"
        names = ["phi", "B", "w_tr", "S", "n0", "N", "mu"];
    case "LeRoy_No"
        names = ["phi_h", "phi_e", "B_h", "B_e", "w_tr_h", "w_tr_e", "S0", "S1", "S2", "S3", ...
                "n0_h", "n0_e", "N_h", "N_e", "mu_h", "mu_e"];
    case "Doedens_Yes"
        names = ["a_int", "w_hop", "a_sh",...
                 "w_tr_int", "N_int", "N",...
                 "w_tr_hop", "w_tr", "S_base",...
                 "n0", "phi", "Pr"];
    case "Doedens_No"
        names = ["a_int_h", "a_int_e", "w_hop_h", "w_hop_e", "a_sh_h", "a_sh_e", ...
                 "w_tr_int_h", "w_tr_int_e", "N_int_h", "N_int_e", "N_h", "N_e", ...
                 "w_tr_hop_h", "w_tr_hop_e", "w_tr_h", "w_tr_e", "S_base1", "S_base2", ...
                 "S_base3", "S_base4", "n0_h", "n0_e", "phi_h", "phi_e", "Pr"];

end
names = ["ID", names, "C(P)", "Wall Clock Time"];
nc = length(names);
sz = [8 nc];
types = ["string", repmat("double",1,nc-1)];
t = table('Size',sz,'VariableTypes',types,'VariableNames',names);

end
