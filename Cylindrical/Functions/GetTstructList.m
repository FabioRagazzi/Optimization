function [Tstruct] = GetTstructList(name, t_start, t_end, r, ri, ro)
% GetTstructList Summary of this function goes here
%   Detailed explanation goes here
arguments
    name char {mustBeMember(name,[ ...
        "T20", ...
        "T70", ...
        "T70_55", ...
        "Trans_1d_lin", ...
        "Trans_5d_lin", ...
        "Trans_1d_exp", ...
        "Trans_5d_exp", ...
        "Trans_5d_TB852"
        ])}
    t_start
    t_end
    r
    ri
    ro
end

switch name
    case "T20"
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, ones(1,2) * 20, ones(1,2) * 20);
        Tstruct.time = [t_start; t_end];
    case "T70"
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, ones(1,2) * 70, ones(1,2) * 70);
        Tstruct.time = [t_start; t_end];
    case "T70_55"
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, ones(1,2) * 68.0877, ones(1,2) * 55.7619);
        Tstruct.time = [t_start; t_end];
    case "Trans_1d_lin"
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, [20, 68.0877, 68.0877, 20], [20, 55.7619, 55.7619, 20]);
        Tstruct.time = [0; 3600*2; 3600*22; 3600*24];
        Tstruct.temporal_interpolation = "linear";
    case "Trans_5d_lin"
        Tstruct.days = 5;
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, ...
            GenerateTemperatureArrayMultipleDays([20, 68.0877, 68.0877, 20], Tstruct.days), ...
            GenerateTemperatureArrayMultipleDays([20, 55.7619, 55.7619, 20], Tstruct.days));
        Tstruct.time = GenerateTimeArrayMultipleDays([0; 4; 20; 24], Tstruct.days);
        Tstruct.time = Tstruct.time*3600;
        Tstruct.temporal_interpolation = "linear";
    case "Trans_1d_exp"
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, [20, 68.0877, 68.0877, 20], [20, 55.7619, 55.7619, 20]);
        Tstruct.time = [0; 3600*2; 3600*22; 3600*24];
        Tstruct.temporal_interpolation = "exponential";
    case "Trans_5d_exp"
        Tstruct.days = 5;
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, ...
            GenerateTemperatureArrayMultipleDays([20, 68.0877, 68.0877, 20], Tstruct.days), ...
            GenerateTemperatureArrayMultipleDays([20, 55.7619, 55.7619, 20], Tstruct.days));
        Tstruct.time = GenerateTimeArrayMultipleDays([0; 2; 22; 24], Tstruct.days);
        Tstruct.time = Tstruct.time*3600;
        Tstruct.temporal_interpolation = "exponential";
    case "Trans_5d_TB852"
        Tstruct.days = 5;
        Tstruct.matrix = TemperatureDistribution(r, ri, ro, ...
            GenerateTemperatureArrayMultipleDays([20, 68.0877, 68.0877, 20], Tstruct.days), ...
            GenerateTemperatureArrayMultipleDays([20, 55.7619, 55.7619, 20], Tstruct.days));
        Tstruct.time = GenerateTimeArrayMultipleDays([0; 6; 8; 24], Tstruct.days);
        Tstruct.time = Tstruct.time*3600;
        Tstruct.temporal_interpolation = "TB852";
end

end
