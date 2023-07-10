addpath("..\Functions\")
clearvars, clc, close all
t_Temp = 0:1:10;
Tmatrix = ones(8,11);
Tmatrix = Tmatrix .* t_Temp;
T = GetTemperature(0, Tmatrix, t_Temp);
disp(T)
