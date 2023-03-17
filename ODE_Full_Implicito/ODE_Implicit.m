% clc, clearvars, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\ODE_Full_Implicito\')
addpath('Functions\')
fprintf("-> ODE\n")

% Loading the parameters for the simulation
% load('Parameters\STANDARD.mat') 

% Specifying the time instants that will be outputted
time_instants = [0, 4, logspace(1,5,98)];

% Setting initial condition for the number density
n_stato_0 = ones(P.num_points, 4) .* P.n_start;
n_stato_0 = reshape(n_stato_0, [P.num_points*4, 1]);

% Solving with ODE
options = odeset('Stats','off');
tic
[tout, nout] = ode23tb(@(t,n_stato)odefunc_Drift_Diffusion(t, n_stato, P), time_instants, n_stato_0, options);
toc

% Post Processing
[x, x_interfacce, x_interni] = create_x_domain(P.L, P.num_points);
[nh, ne, nht, net, rho, phi, E, J, J_dDdt] = post_processing(nout, tout, P);


% This part is useful for a maual fitting of a current
load('data\SERI_smooth.mat')
loglog(t_SERI_smooth, J_SERI_smooth, 'r-', 'LineWidth',2, 'DisplayName','Seri')
hold on
% loglog(tout, J, 'g-', 'LineWidth',2)
loglog(tout, J_dDdt, 'k--', 'LineWidth',2, 'DisplayName','TRRA Fit')
grid on
hold off
xlabel('time (s)')
ylabel('current density (Am^-^2)')
title('TRRA Fit Result')
legend
set(gca, 'FontSize', 15)


rmpath('Functions\')
cd(current_path)
clear current_path
