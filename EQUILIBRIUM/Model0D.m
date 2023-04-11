clearvars, clc, close all

kB = 1.380649e-23;
abs0 = 273.15;
e = 1.602176634e-19;

% Specifing the parameters
param.num_points = 1;
param.N0t = 1e20;
param.B = 1e-5;             
param.D = 1e-5;
param.S0 = 1e-5;
param.S12 = 1e-5;
param.S3 = 1e-5;
param.U = 0;

% Arrange 
param.S0 = param.S0 * e;
param.S12 = param.S12 * e;
param.S3 = param.S3 * e;

% Setting initial condition
T = 60;
inv_kBT = 1 / (kB * (T + abs0));
n0 = 1e28; % [1/m^3]
Eg_interlevel = 0.5; 
Eg_deep = 2;
n = n0*exp(-(Eg_deep - Eg_interlevel)*e*inv_kBT);
nt = n;
n_stato_0 = [n, n, nt, nt]';

% Uncomment this to have a stable initial condition 
param.U = param.S0*nt^2 + 2*param.S12*nt*n + param.S3*n^2;
param.B = (param.S0*nt^2 + param.S12*nt*n + param.D*nt) / (n * (1 - nt/param.N0t));
disp(param.B)

% Setting time instants
time_instants = [0, logspace(-5,20,99)];

options = odeset('Stats','off');
tic
[tout, nout] = ode23tb(@(t,n)my_odefun(t, n, param), time_instants, n_stato_0, options);
toc

loglog(tout, nout(:,1), 'r-', 'LineWidth', 2, 'DisplayName','nh');
hold on
loglog(tout, nout(:,2), 'k--', 'LineWidth', 2, 'DisplayName','ne');
loglog(tout, nout(:,3), 'm-', 'LineWidth', 2, 'DisplayName','nht');
loglog(tout, nout(:,4), 'b--', 'LineWidth', 2, 'DisplayName','net');

% semilogy(tout, nout(:,1), 'r-', 'LineWidth', 2)
% hold on
% semilogy(tout, nout(:,2), 'k--', 'LineWidth', 2)
% semilogy(tout, nout(:,3), 'm-', 'LineWidth', 2)
% semilogy(tout, nout(:,4), 'b--', 'LineWidth', 2)
% xlim([0, 1e-5])

% plot(tout, nout(:,1), 'r-', 'LineWidth', 2)
% hold on
% plot(tout, nout(:,2), 'k--', 'LineWidth', 2)
% plot(tout, nout(:,3), 'm-', 'LineWidth', 2)
% plot(tout, nout(:,4), 'b--', 'LineWidth', 2)

xlabel('time (s)')
ylabel('number density (m^-^3)')
set(gca, 'FontSize', 15)
legend
grid on
