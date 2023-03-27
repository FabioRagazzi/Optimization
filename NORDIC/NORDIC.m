clearvars, clc%, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC\')
addpath('Functions\')
fprintf("-> ODE NM\n")

% Loading the parameters for the simulation
load("Parameters\inbox.mat") 

% Specifying the time instants that will be outputted
time_instants = [0, 4, logspace(1,6,98)];

% Setting initial condition for the number density
n_stato_0 = ones(P.num_points, 4) .* P.n_start;
n_stato_0 = reshape(n_stato_0, [P.num_points*4, 1]);

% Setting the flags for the electric field dependency
flag_mu = true; % set to true to have a mobility dependent on the electric field
flag_B = true; % set to true to have a trapping coefficient dependent on the electric field
flag_D = true; % set to true to have a detrapping coefficient dependent on the electric field
flag_S = true; % set to true to have the recombination coefficients dependent on the electric field

% Solving with ODE
options = odeset('Stats','off');
tic
[tout, nout] = ode23tb(@(t,n_stato)odefunc_Drift_Diffusion_NM(t, n_stato, P, flag_mu, flag_B, flag_D, flag_S), time_instants, n_stato_0, options);
toc

% Post Processing
[x, x_interfacce, x_interni] = create_x_domain(P.L, P.num_points);
[nh, ne, nht, net, rho, phi, E, J, J_dDdt] = post_processing(nout, tout, P, flag_mu);

% This part is useful for a maual fitting of a current
% load('data\SERI_smooth.mat')
% loglog(t_SERI_smooth, J_SERI_smooth, 'r-', 'LineWidth',2, 'DisplayName','Seri')
% hold on
% %loglog(tout, J, 'g-', 'LineWidth',2)
% loglog(tout, J_dDdt, 'k--', 'LineWidth',2, 'DisplayName','PS Fit')
% grid on
% hold off
% xlabel('time (s)')
% ylabel('current density (Am^-^2)')
% title('PS Fit Result')
% legend
% set(gca, 'FontSize', 15)

% This part is useful for see the resulting polarization current
% if flag_mu
%     loglog(tout, J, 'g-', 'LineWidth', 2, 'DisplayName','\mu = \mu(E,T)')
% else
%     loglog(tout, J, 'k--', 'LineWidth', 2, 'DisplayName','\mu = \mu(T)')
% end
% if flag_mu
%     loglog(tout, J, 'g-', 'LineWidth', 2, 'DisplayName','f(E,T)')
% else
%     loglog(tout, J, 'k--', 'LineWidth', 2, 'DisplayName','f(T)')
% end
loglog(tout, J, 'g-', 'LineWidth', 2, 'DisplayName','Sato')
hold on
loglog(tout, J_dDdt, 'k--', 'LineWidth', 2, 'DisplayName','J + dD/dt')
hold off
grid on
xlabel('time (s)')
ylabel('current density (Am^-^2)')
legend
set(gca, 'FontSize', 15)
% title("E = 1e" + num2str(num) + "(Vm^-^1)")

rmpath('Functions\')
cd(current_path)
clear current_path
