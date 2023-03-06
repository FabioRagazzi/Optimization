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
clc, clearvars
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')

load('data\objective_for_TRRA\standard_parameters.mat');

% ex -> the parameter is an exponent 
% li -> the parameter is a linear parameter
      %ex   %ex   %li   %ex   %ex   %ex   %ex
      %mu   %n0t  %phi  %B    %D    %S    %n0
    %[-13.3010, 20.7782, 1, -0.6990, -1, -2.3979, 18]
lb = [-15,   19,  0.9,   -1,   -1,   -3,   17];
ub = [-13,   21,  1.1,    0,    0,   -2,   19];
x0 = [-14,   19,  1.1,    0,    0,   -3,   19];

solver = 'lsqnonlin';
options = optimoptions(solver);
options.Displey = 'iter';
options.OptimalityTolerance = 1e-8; % 1e-6
options.FunctionTolerance = 1e-10; % 1e-6
options.UseParallel = false;

tic
[xv,~,~,~,output] = lsqnonlin(@(p) objective_function(p,Jobjective,time,P), x0, lb, ub, options); 
toc

cd(current_path)
clear current_path

%% FITTING STANDARD PARAMETERS WITH PARTICLE SWARM
clc, clearvars
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')

load('data\objective_for_TRRA\standard_parameters.mat');

% ex -> the parameter is an exponent 
% li -> the parameter is a linear parameter
      %ex   %ex   %li   %ex   %ex   %ex   %ex
      %mu   %n0t  %phi  %B    %D    %S    %n0
    %[-13.3010, 20.7782, 1, -0.6990, -1, -2.3979, 18]
lb = [-15,   19,  0.9,   -1,   -1,   -3,   17];
ub = [-13,   21,  1.1,    0,    0,   -2,   19];

solver = 'particleswarm';
options = optimoptions(solver);
options.UseParallel = false; %false
options.FunctionTolerance = 1e-3; %1e-6
options.MaxIterations = 1e5; %200*nvars
options.MaxStallIterations = 20; %20
options.Display = 'final'; %final
tic
[xv,~,~,output] = particleswarm(@(parametri)objective_function(parametri,Jobjective,time,P,solver), length(ub), lb, ub, options);
toc

cd(current_path)
clear current_path

%% COMPARE RESULTS
% xv = [-13.7234, 19.9050, 0.9562, -0.1778, -0.0014, -2.5003, 17.4705];
P.L = 4e-4;
P.num_points = 100;
P.T = 298.15;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = 4e3;

% Parameters fitted 
P.mu_h = 10^xv(1);
P.mu_e = 10^xv(1);
P.nh0t = 10^xv(2);
P.ne0t = 10^xv(2);
P.phih = xv(3);
P.phie = xv(3);
P.Bh = 10^xv(4);
P.Be = 10^xv(4);
P.Dh = 10^xv(5);
P.De = 10^xv(5);
P.S0 = 10^xv(6);
P.S1 = 10^xv(6);
P.S2 = 10^xv(6);
P.S3 = 10^xv(6);
P.n_start = [10^xv(7), 10^xv(7), 0, 0];

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

% Setting initial condition for the number density
n_stato_0 = ones(P.num_points, 4) .* P.n_start;
n_stato_0 = reshape(n_stato_0, [P.num_points*4, 1]);

% Solving with ODE
options = odeset('Stats','off');
[tout, nout] = ode23tb(@(t,n_stato)odefunc_Drift_Diffusion(t, n_stato, P), time, n_stato_0, options);

% Post Processing
[x, x_interfacce, x_interni] = create_x_domain(P.L, P.num_points);
[nh, ne, nht, net, rho, phi, E, J_fitted] = post_processing(nout, tout, P);

% Confronting real result with fitted one
loglog(time,Jobjective,'r-','LineWidth',2,'DisplayName','Objective')
hold on
loglog(time,J_fitted,'b--','LineWidth',2,'DisplayName','Fit')
grid on
legend
xlabel('time (s)')
ylabel('J (A/m^2)')
set(gca,'FontSize',15)
