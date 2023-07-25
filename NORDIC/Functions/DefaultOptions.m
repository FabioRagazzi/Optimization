function [default_options] = DefaultOptions()
% DefaultOptions returns a structure containing the default options
% INPUT
% [] -> none
% OUTPUT
% default_options -> structure containing the default options for the
% simulation
% flagMu = 0; [0 / 1]
% flagB = 0;  [0 / 1]
% flagD = 0;  [0 / 1]
% flagS = 0;  [0 / 1]
% flux_scheme = "Upwind"; ["Upwind" / "Koren"]
% injection = "Schottky"; ["Schottky" / "Fixed"]
% source = "On"; ["On" / "Off"]
% max_time = 2;
% display = "Off"; ["On" / "Off"]
% ODE_options = odeset('Stats','off');

default_options.flagMu = 0;
default_options.flagB = 0;
default_options.flagD = 0;
default_options.flagS = 0;
default_options.flux_scheme = "Upwind";
default_options.injection = "Schottky";
default_options.source = "On";
default_options.max_time = 2;
default_options.display = "Off"; % display fitness value during optimization
default_options.ODE_options = odeset('Stats','off');
default_options.blocking_electrodes = "Off";

end
