function [result] = GeneralDispResults(ID_measure, opt_kind, model, simmetric)
% GeneralDispResults Summary of this function goes here
%   Detailed explanation goes here
arguments
    ID_measure char {mustBeMember(ID_measure,{'XLPE','PP','SGI','BLEND'})}
    opt_kind char {mustBeMember(opt_kind,{'TRRA','PS'})}
    model char {mustBeMember(model,{'LeRoy','Doedens'})}
    simmetric char {mustBeMember(simmetric,{'Yes','No'})}
end
Measure = load("data\Data_" + ID_measure + ".mat");
P = Parameters("START_" + ID_measure + "_SERI");
[names, tags, exp_lin_flags, equals, ~, ~] = SetReferenceP(model + "_" + simmetric);
options = Options("Opt32");
if model == "Doedens"
    options.flagB = 1;
    options.flagD = 1;
    options.flagMu = 1;
    options.flagS = 1;
end
res = load("res\" + ID_measure + "_" + opt_kind + "_" + model + "_" + simmetric + ".mat");
result = res.result;
try
    [out] = RunODEUpdating(result.xv, tags, names, exp_lin_flags, equals, P, Measure.time_instants, options);
    fitness = norm( (log10(Measure.Jobjective) - log10(out.J_dDdt))./log10(Measure.Jobjective) );
    PlotFitResult(out, Measure.Jobjective, Measure.time_instants);
    title({ID_measure + "  " + opt_kind + "  " + model + "  " + simmetric,...
          "wct: " + num2str(result.wct), "fitness: " + num2str(fitness)})
catch
end

end
