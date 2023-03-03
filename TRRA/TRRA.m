%% FIT PARABOLIC CURVE WITH LSQNONLIN
clc, clear variables
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')
lb = [-1e3, -1e3, -1e3];
ub = [1e3, 1e3, 1e3];
x0 = [1e3, 1e3, 1e3];
t = linspace(0,10,20);
fun = @(p) (p(1)*t.^2 + p(2)*t + p(3)) - (537*t.^2-489*t-31);
options = optimoptions('lsqnonlin', 'Display','iter');
[xv,~,~,~,output] = lsqnonlin(fun, x0, lb, ub, options); 
cd(current_path)
clear current_path

%% SET OF STANDARD PARAMETERS
clc, clear variables
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')
% Parameters of the simulation
P.L = 4e-4;
P.num_points = 100;
P.T = 298.15;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = 4e3;
P.mu_h = 5e-14;
P.mu_e = 5e-14;
P.nh0t = 6e20;
P.ne0t = 6e20;
P.phih = 1;
P.phie = 1;
P.Bh = 0.2;
P.Be = 0.2;
P.Dh = 0.1;
P.De = 0.1;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 4e-3;
P.n_start = [1e18, 1e18, 0, 0];

% Physics constants
P.a = 7.5005e12;
P.e = 1.6022e-19;
P.kB = 1.381e-23;
P.eps0 = 8.854e-12;

% Derived parameters
P.Delta = P.L / P.num_points;
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.beta = 6.08e-24 / sqrt(P.eps_r);
P.coeff =  8 * P.eps / (3 * P.Delta^2);
P.aT2exp = P.a * (P.T^2) * exp(-[P.phie, P.phih] * P.e / P.kBT); 
P.D_h = P.mu_h * P.T * P.kB/ P.e;
P.D_e = P.mu_e * P.T * P.kB/ P.e;
P.S0 = P.S0 * P.e;
P.S1 = P.S1 * P.e;
P.S2 = P.S2 * P.e;
P.S3 = P.S3 * P.e;
P.Kelet = Kelectrostatic(P.num_points, P.Delta, P.eps);

cd(current_path)
clear current_path

%% SIMULATION & POST PROCESSING
clc, clear variables
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')
addpath('data\')

% Loading the parameters for the simulation
load('P_standard') 

% Specifying the time instants that will be outputted
time = [0, logspace(0,5,99)];

% Setting initial condition for the number density
n_stato_0 = ones(P.num_points, 4) .* P.n_start;
n_stato_0 = reshape(n_stato_0, [P.num_points*4, 1]);

% Solving with ODE
options = odeset('Stats','off');
tic
[tout, nout] = ode23tb(@(t,n_stato)odefunc_Drift_Diffusion(t, n_stato, P), time, n_stato_0, options);
toc

% Post Processing
[x, x_interfacce, x_interni] = create_x_domain(P.L, P.num_points);
[nh, ne, nht, net, rho, phi, E, J] = post_processing(nout, tout, P);

cd(current_path)
clear current_path

%% FITTING STANDARD PARAMETERS WITH TRRA
clc, clear variables
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')
addpath('data\objective_for_TRRA\')

global P Jobjective time
load('standard_parameters.mat');

% ex -> the parameter is an exponent 
% li -> the parameter is a linear parameter
      %ex   %ex   %li   %ex   %ex   %ex   %ex
      %mu   %n0t  %phi  %B    %D    %S    %n0
    %[-13.3010, 20.7782, 1, -0.6990, -1, -2.3979, 18]
lb = [-15,   19,  0.9,   -1,   -1,   -3,   17];
ub = [-13,   21,  1.1,    0,    0,   -2,   19];
x0 = [-15,   19,  1.1,    0,    0,   -3,   19];

options = optimoptions('lsqnonlin', 'Display','off');
[xv,~,~,~,output] = lsqnonlin(@(p) objective_function(p), x0, lb, ub, options); 

cd(current_path)
clear current_path
