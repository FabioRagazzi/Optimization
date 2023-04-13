clearvars, clc, close all
addpath('Functions\')

% Loading the parameters for the simulation
load("Parameters\INBOX.mat") 

% Specifying the time instants that will be outputted
time_instants = [0, logspace(0, 5, 99)] + 4.4694;

% Specifying the flags for the electric field dependence
%                   mu    B     D     S
E_flags = logical([ 0,    0,    0,    0]);

% Specifying the options for the ODE
ODE_options = odeset('Stats','off');

% Deciding if stopping when number density becomes < 0
flag_n = true;
[out] = NordicODE(P, time_instants, E_flags, ODE_options, flag_n);

load("data\Data_Seri.mat")
CompareSatoJdDdt(out, Jobjective, time_instants)

rmpath('Functions\')
