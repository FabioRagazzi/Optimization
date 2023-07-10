clearvars, clc, close all
addpath('Functions\')

PARAMETER_ID_NAME = "LE_ROY"; ParametersScript;

time_instants = [0, logspace(0, 5, 49)];

[options] = DefaultOptions();
options.max_time = 3;

[out] = RunODE(P, time_instants, options);

%% 
clearvars, clc, close all
addpath('Functions\')

PARAMETER_ID_NAME = "NORDIC_STANDARD"; ParametersScript;

time_instants = [0, logspace(0, 5, 49)];

[options] = DefaultOptions();
options.flagB = 1;
options.flagD = 1;
options.flagMu = 1;
options.flagS = 1;

[out] = RunODE(P, time_instants, options);

% loglog(out.tout, out.J_dDdt)
% plot(P.x_int, out.rho(:,end))
