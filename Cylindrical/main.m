%%
addpath("Functions\")
clearvars, clc, close all
time_instants = [0, logspace(0,5,59)];
[out] = Run("DOEDENS", time_instants, "coordinates","cylindrical", "source","off", "type","sparse");

%% CONFRONTO BASSEL
addpath("Functions\")
clearvars, clc, close all
% time_instants = [0, logspace(-5,log10(3660*24), 200)];
time_instants = linspace(0, 3600*24, (3600*24)/(60*5));
[out] = Run("CONFRONTO_BASSEL", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

% plot(out.P.geo.x_int, out.E(:,1:10:end))
