function [options] = Options(id)
% Options Summary of this function goes here
%   Detailed explanation goes here
arguments
    id char {mustBeMember(id,{'Default','Opt32'})} = "Default"
end

switch id
    case "Default"
        options = DefaultOptions();
    case "Opt32"
        options.flagMu = 0;
        options.flagB = 0;
        options.flagD = 0;
        options.flagS = 0;
        options.flux_scheme = "Upwind";
        options.injection = "Schottky";
        options.source = "On";
        options.max_time = 20;
        options.display = "Off"; % display fitness value during optimization
        options.ODE_options = odeset('Stats','off');
        options.blocking_electrodes = "Off";
end

end
