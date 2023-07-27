function [xv, wct, fitness] = GeneralOptimization(ID_measure, opt_kind, model, simmetric)
% GeneralOptimization Summary of this function goes here
%   Detailed explanation goes here
arguments
    ID_measure char {mustBeMember(ID_measure,{'XLPE','PP','SGI','BLEND'})}
    opt_kind char {mustBeMember(opt_kind,{'TRRA','PS'})}
    model char {mustBeMember(model,{'LeRoy','Doedens'})}
    simmetric char {mustBeMember(simmetric,{'Yes','No'})}
end
Measure = load("data\Data_" + ID_measure + ".mat");
P = Parameters("START_" + ID_measure + "_SERI");
[names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP(model + "_" + simmetric);
options = Options("Opt32");
if model == "Doedens"
    options.flagB = 1;
    options.flagD = 1;
    options.flagMu = 1;
    options.flagS = 1;
end
warning('off','all')
func = @(x)ObjectiveFunctionJ(opt_kind, x, tags, names, exp_lin_flags, ...
                          equals, P, Measure.time_instants, Measure.Jobjective, options);

if opt_kind == "TRRA"
    OPT_options = optimoptions('lsqnonlin');
    OPT_options.Display = 'final';
    OPT_options.StepTolerance = 1e-6; % 1e-6
    OPT_options.OptimalityTolerance = 1e-6; % 1e-6
    OPT_options.FunctionTolerance = 1e-6; % 1e-6
    OPT_options.UseParallel = true;

    nvars = length(lb);
    Num_swipes = 5 * nvars;
    xv_matrix = zeros(Num_swipes, nvars);
    x0 = zeros(Num_swipes, nvars);
    wct = 0;
    for i = 1:Num_swipes
        x0(i,:) = RandomX0(lb, ub); 
        TRRA_start_time = tic;
        [xv_matrix(i,:), ~, ~, ~, ~] = lsqnonlin(func, x0(i,:), lb, ub, OPT_options);
        TRRA_elapsed_time = toc(TRRA_start_time);
        wct = wct + TRRA_elapsed_time;
    end  
    
    fitness = Inf;
    index = 1;
    for i = 1:Num_swipes
        try
            [out] = RunODEUpdating(xv_matrix(i,:), tags, names, exp_lin_flags, equals, P, Measure.time_instants, options);
            fitness_i = norm( (log10(Measure.Jobjective) - log10(out.J_dDdt))./log10(Measure.Jobjective) );
            if fitness_i < fitness
                fitness = fitness_i;
                index = i;
            end
        catch
        end
    end
    xv = xv_matrix(index,:);

elseif opt_kind == "PS"
    OPT_options = optimoptions('particleswarm');
    OPT_options.Display = 'final';
    OPT_options.FunctionTolerance = 1e-6; % 1e-6
    OPT_options.MaxIterations = 5000; % 200*nvars
    OPT_options.MaxStallIterations = 20; % 20
    OPT_options.UseParallel = true;

    nvars = length(lb);
    PS_start_time = tic;
    [xv, ~, ~, ~] = particleswarm(func, nvars, lb, ub, OPT_options);
    wct = toc(PS_start_time);    
    [out] = RunODEUpdating(xv, tags, names, exp_lin_flags, equals, P, Measure.time_instants, options);
    fitness = norm( (log10(Measure.Jobjective) - log10(out.J_dDdt))./log10(Measure.Jobjective) );
end

result.xv = xv;
result.wct = wct;
result.fitness = fitness;
save("res\" + ID_measure + "_" + opt_kind + "_" + model + "_" + simmetric + ".mat", "result")

warning('on','all')

end
