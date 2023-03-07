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

% Loading the parameters for the simulation
load('data\P_standard') 

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
fit_what = "N";
options = optimoptions(solver);
options.Display = 'iter';
options.OptimalityTolerance = 1e-8; % 1e-6
options.FunctionTolerance = 1e-10; % 1e-6
options.UseParallel = false;

tic
if fit_what == "J"
    [xv,~,~,~,output] = lsqnonlin(@(p) objective_function_J(p,Jobjective,time,P,solver), x0, lb, ub, options); 
elseif fit_what == "N"
    [xv,~,~,~,output] = lsqnonlin(@(p) objective_function_N(p,Nobjective,time,P,solver), x0, lb, ub, options); 
end
toc

save(solver + "_" + fit_what,'xv')

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
fit_what = "J";
options = optimoptions(solver);
options.UseParallel = false; %false
options.FunctionTolerance = 1e-3; %1e-6
options.MaxIterations = 1e5; %200*nvars
options.MaxStallIterations = 20; %20
options.Display = 'final'; %final

tic
if fit_what == "J"
    [xv,~,~,output] = particleswarm(@(parametri)objective_function_N(parametri,Nobjective,time,P,solver), length(ub), lb, ub, options);
elseif fit_what == "N"
    [xv,~,~,output] = particleswarm(@(parametri)objective_function_J(parametri,Jobjective,time,P,solver), length(ub), lb, ub, options);
end
toc

save(solver + "_" + fit_what,'xv')

cd(current_path)
clear current_path

%% COMPARE RESULTS (J)
xv = [-13.4015 18.2590 1 0.9938 0.7860 -2.3746 18.0529];
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

%% COMPARE RESULTS (N)
xv = [-13.5409   19.0552    1.1000   -0.0599   -0.0081   -2.9521   17.8963];
load('data\objective_for_TRRA\standard_parameters.mat')

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

% Post processing
[~, ~, x_interni] = create_x_domain(P.L, P.num_points);

% Confronting real result with fitted one
N = reshape(Nobjective, [100, 400]);
err = abs((N - nout)) ./ N;
err(isnan(err)) = 0;

low_bar_lim = 0;
high_bar_lim = 10;
figure
tiledlayout(1,4);
nexttile
imagesc(err(:,1:P.num_points))
clim([low_bar_lim, high_bar_lim])
nexttile
imagesc(err(:,P.num_points+1:2*P.num_points))
clim([low_bar_lim, high_bar_lim])
nexttile
imagesc(err(:,2*P.num_points+1:3*P.num_points))
clim([low_bar_lim, high_bar_lim])
nexttile
imagesc(err(:,3*P.num_points+1:4*P.num_points))
colorbar('southoutside')
clim([low_bar_lim, high_bar_lim])

% N = reshape(Nobjective, [100, 400]);
% figure
% ID(1) = plot(x_interni, N(1,1:P.num_points),'r-','LineWidth',2,'DisplayName','Objective');
% hold on
% ID(2) = plot(x_interni, nout(1,1:P.num_points),'b--','LineWidth',2,'DisplayName','Fit');
% grid on
% legend
% xlabel('time (s)')
% ylabel('nh (1/m^3)')
% pause(2)
% for i = 1:size(nout,1)
%     delete(ID)
%     ID(1) = plot(x_interni, N(i,1:P.num_points),'r-','LineWidth',2,'DisplayName','Objective');
%     ID(2) = plot(x_interni, nout(i,1:P.num_points),'b--','LineWidth',2,'DisplayName','Fit');
%     grid on
%     legend
%     xlabel('time (s)')
%     ylabel('nh (1/m^3)')
%     pause(0.2)
% end

%% COLOR PLOT OBJECTIVE
load('data\objective_for_TRRA\standard_parameters.mat')
N = reshape(Nobjective, [100,400]);
rho = P.e * (+N(:,1:P.num_points) ...
             -N(:,P.num_points+1:2*P.num_points) ...
             +N(:,2*P.num_points+1:3*P.num_points) ...
             -N(:,3*P.num_points+1:4*P.num_points));
figure
imagesc(rho')
colorbar
% clim([-15, 15])
xlim = get(gca, 'XLim');
num_x_tick = 6;
xold_wanted = linspace(xlim(1), xlim(end), num_x_tick);
x_label = logspace(0, log10(time(end)), num_x_tick);
set(gca, 'XTick',xold_wanted, 'XTickLabel',x_label)
xlabel('time (s)')

ylim = get(gca, 'YLim');
num_y_tick = 5;
yold_wanted = linspace(ylim(1), ylim(end), num_y_tick);
y_label = linspace(0,P.L,num_y_tick);
set(gca, 'YTick',yold_wanted, 'YTickLabel',y_label)
ylabel('space (m)')

%% COLOR PLOT FITTED
rho = P.e * (+nout(:,1:P.num_points) ...
             -nout(:,P.num_points+1:2*P.num_points) ...
             +nout(:,2*P.num_points+1:3*P.num_points) ...
             -nout(:,3*P.num_points+1:4*P.num_points));
figure
imagesc(rho')
colorbar
% clim([-15, 15])
xlim = get(gca, 'XLim');
num_x_tick = 6;
xold_wanted = linspace(xlim(1), xlim(end), num_x_tick);
x_label = logspace(0, log10(time(end)), num_x_tick);
set(gca, 'XTick',xold_wanted, 'XTickLabel',x_label)
xlabel('time (s)')

ylim = get(gca, 'YLim');
num_y_tick = 5;
yold_wanted = linspace(ylim(1), ylim(end), num_y_tick);
y_label = linspace(0,P.L,num_y_tick);
set(gca, 'YTick',yold_wanted, 'YTickLabel',y_label)
ylabel('space (m)')



