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

%% PLOT CURRENT SERI
clearvars, clc, close all
load('data\G1B166C-T60_30_kV-mm.mat')
J_seri = savemat.curr/savemat.A;
t_seri = savemat.time;
% Si buttano via i primi 5 punti della corrente e 6 del tempo
J_seri = J_seri(6:end);
t_seri = t_seri(7:end);
ax1 = gca;
loglog(t_seri, J_seri)
grid on
xlabel('time (s)')
ylabel('current density (A/m^2)')
set(gca,'FontSize',15)
t_interp = logspace(log10(t_seri(1)),log10(t_seri(end)),100);
J_interp = interp1(t_seri,J_seri,t_interp); 
J_interp_mean = smoothdata(J_interp);
figure
loglog(t_interp,J_interp_mean)
xlim(get(ax1,'Xlim'))
ylim(get(ax1,'Ylim'))
grid on
t_smooth = t_interp;
J_smooth = J_interp_mean;

%% FIT A MANO #1
% Parameters of the simulation
P.L = 4e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 4;
P.Phi_W = 0;
P.Phi_E = 12e3;
P.mu_h = 9e-15;
P.mu_e = 9e-15;
P.nh0t = 1e24;
P.ne0t = 1e24;
P.phih = 0.65;
P.phie = 0.65;
P.Bh = 2e-1;
P.Be = 1e-1;
P.Dh = 1e-1;
P.De = 5e-2;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 0;
P.n_start = [4e21, 4e21, 0, 0];

% Physics constants
P.a = 7.5005e12;
P.e = 1.6022e-19;
P.kB = 1.381e-23;
P.eps0 = 8.854e-12;
P.abs0 = 273.15;

% Derived parameters
P.Delta = P.L / P.num_points;
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.T = P.T + P.abs0;
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

%% FIT A MANO #2
% Parameters of the simulation
P.L = 3e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 4;
P.Phi_W = 0;
P.Phi_E = 9e3;
P.mu_h = 1e-12;
P.mu_e = 1e-12;
P.nh0t = 1e25;
P.ne0t = 1e25;
P.phih = 1;
P.phie = 1;
P.Bh = 2;
P.Be = 1;
P.Dh = 1e-2;
P.De = 5e-3;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 0;
P.n_start = [1e20, 1e20, 0, 0];

% Physics constants
P.a = 7.5005e12;
P.e = 1.6022e-19;
P.kB = 1.381e-23;
P.eps0 = 8.854e-12;
P.abs0 = 273.15;

% Derived parameters
P.Delta = P.L / P.num_points;
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.T = P.T + P.abs0;
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

%% SET OF [STANDARD, SERI] PARAMETERS
clc, clear variables
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')

%SERI
P.L = 3.5e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = 1.05e4;

% Parameters of the simulation
% P.L = 4e-4;
% P.num_points = 100;
% P.T = 25;
% P.eps_r = 2;
% P.Phi_W = 0;
% P.Phi_E = 4e3;
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
P.abs0 = 273.15;

% Derived parameters
P.Delta = P.L / P.num_points;
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.T = P.T + P.abs0;
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
load('data\Fit_a_mano_1.mat') 

% Specifying the time instants that will be outputted
time = [0, logspace(0,5,60)];

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

%% J + dD / dt
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')

J_cond = compute_J_cond(nh, ne, E, P.D_h, P.D_e, P.mu_h, P.mu_e, P.Delta, P.aT2exp, P.kBT, P.beta, P.e);
dDdt = compute_dDdt(E, tout', P.eps);
J_dDdt = -(J_cond);
% surf(J_dDdt)

J_from_dDdt = integral_func(J_dDdt', P.Delta) / P.L;
figure
loglog(tout,J_from_dDdt,'g-')
hold on
plot(tout,J,'k--')

% figure
% id = plot(J_dDdt(:,1));
% for i = 2:size(J_dDdt,2)
%     delete(id);
%     id = plot(J_dDdt(:,i));
%     pause(0.1)
% end

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

% load('data\objective_for_TRRA\standard_parameters.mat');
load('data\Seri_objective.mat');

% ex -> the parameter is an exponent 
% li -> the parameter is a linear parameter
      %ex   %ex   %li   %ex   %ex   %ex   %ex
      %mu   %n0t  %phi  %B    %D    %S    %n0
    %[-13.3010, 20.7782, 1, -0.6990, -1, -2.3979, 18]
lb = [-16,   19,  0.5,   -5,   -5,   -5,   16];
ub = [-12,   25,  1.5,    1,    1,   -1,   20];

solver = 'particleswarm';
fit_what = "J";
options = optimoptions(solver);
options.UseParallel = true; %false
options.FunctionTolerance = 1e-3; %1e-6
options.MaxIterations = 1e5; %200*nvars
options.MaxStallIterations = 20; %20
options.Display = 'final'; %final

tic
if fit_what == "N"
    [xv,~,~,output] = particleswarm(@(parametri)objective_function_N(parametri,Nobjective,time,P,solver), length(ub), lb, ub, options);
elseif fit_what == "J"
    [xv,~,~,output] = particleswarm(@(parametri)objective_function_J(parametri,Jobjective,time,P,solver), length(ub), lb, ub, options);
end
toc

save("data\" + solver + "_" + fit_what,'xv')

cd(current_path)
clear current_path

%% COMPARE RESULTS (J)
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')

% load('data\objective_for_TRRA\standard_parameters.mat');
load('data\Seri_objective.mat');

% xv = [  -15.0521, 21.9994, 1.3488, -2.0000,  0.9927, -1.6929, 19.8905;
%         -13.7688, 19.6215, 0.9803, -1.7340, -0.7647, -1.9544, 18.1863;
%         -14.3044, 18.6844, 1.3037, -1.5070, -1.2044, -1.1258, 17.5855;
%         -13.5613, 18.4901, 0.9680, -1.1268, -1.0439, -1.3199, 18.1837;
%         -13.6049, 19.9784, 0.9997, -0.9889, -0.7097, -2.5412, 18.0487;
%         -13.5188, 19.8481, 1.0058, -0.5853, -0.5179, -2.4820, 18.0743;
%         -13.5023, 21.0258, 1.0189, -0.2705, -0.2111, -2.2225, 18.0881;
%         -13.1998, 20.8002, 1.1999,  0.1005,  0.1001, -1.9003, 18.8000;
%         -12.7999, 21.2002, 1.3000,  0.4000,  0.4000, -1.6000, 19.2000 ];
xv = [-14.0000 , 19.0075 , 0.50000 , -3.5000 , 0 , -3.9901 , 19.7327];

% Fixed Parameters
P.L = 4e-4;
P.num_points = 100;
P.T = 298.15;
P.eps_r = 1.5; %!!!!!
P.Phi_W = 0;
P.Phi_E = 4e3;

% Physics constants
P.a = 7.5005e12;
P.e = 1.6022e-19;
P.kB = 1.381e-23;
P.eps0 = 8.854e-12;

for i = 1:size(xv,1)

    % Parameters fitted 
    P.mu_h = 10^xv(i,1);
    P.mu_e = 10^xv(i,1);
    P.nh0t = 10^xv(i,2);
    P.ne0t = 10^xv(i,2);
    P.phih = xv(i,3);
    P.phie = xv(i,3);
    P.Bh = 10^xv(i,4);
    P.Be = 10^xv(i,4);
    P.Dh = 10^xv(i,5);
    P.De = 10^xv(i,5);
    P.S0 = 10^xv(i,6);
    P.S1 = 10^xv(i,6);
    P.S2 = 10^xv(i,6);
    P.S3 = 10^xv(i,6);
    P.n_start = [10^xv(i,7), 10^xv(i,7), 0, 0];
    
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
    if i == 1
        figure1 = figure;
        loglog(time,Jobjective,'r-','LineWidth',2,'DisplayName','Objective')
        hold on
    end
    loglog(time,J_fitted,'b--','LineWidth',2,'DisplayName', "Fit_" + num2str(i))
end
grid on
legend
xlabel('time (s)')
ylabel('J (A/m^2)')
set(gca,'FontSize',15)

% x1 = 900;
% x2 = 1100;
% y1 = 1.4e-8;
% y2 = 2.4e-8;
% rectangle('Position',[x1, y1, x2-x1, y2-y1])
% ax = axes('Position',[.3 .3 .3 .3]);
% box on
% loglog(time, J_fitted, 'r-','LineWidth',2,'DisplayName','Objective')
% hold on
% loglog(time, Jobjective, 'b--','LineWidth',2,'DisplayName', 'Fit')
% grid on
% ax.XLim = [x1, x2];
% ax.YLim = [y1, y2];
% annotation(figure1,'arrow',[0.511 0.598],[0.610 0.721]);

cd(current_path)
clear current_path

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



