%%
addpath("Functions\")
clearvars, clc, close all
time_instants = [0, logspace(0,5,59)];
[out] = Run("DOEDENS", time_instants, "coordinates","cylindrical", "source","off", "type","sparse");

%%
addpath("Functions\")
clearvars, clc, close all
time_instants = [0, logspace(0,5,59)];
[out] = Run("TEST_CYLINDRICAL", time_instants, "coordinates","cylindrical", "source","off", "type","sparse");


