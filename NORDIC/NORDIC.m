clearvars, clc%, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC\')
addpath('Functions\')
fprintf("-> ODE NM\n")

% Loading the parameters for the simulation
load("Parameters\inbox.mat") 

% Specifying the time instants that will be outputted
time_instants = [0, logspace(0, 5, 99)];

% Specifying the flags for the electric field dependence
%                   mu    B     D     S
E_flags = logical([ 0,    0,    0,    0]);

% Specifying the options for the ODE
options = odeset('Stats','off');

[out] = NordicODE(P, time_instants, E_flags, options);

compare_Sato_JdDdt(out)

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
% loglog(out.tout, out.J, 'g-', 'LineWidth', 2, 'DisplayName','Sato')
% hold on
% loglog(out.tout, out.J_dDdt, 'k--', 'LineWidth', 2, 'DisplayName','J + dD/dt')
% grid on
% xlabel('time (s)')
% ylabel('current density (Am^-^2)')
% legend
% set(gca, 'FontSize', 15)
% title("E = 1e" + num2str(num) + "(Vm^-^1)")

rmpath('Functions\')
cd(current_path)
clear current_path


%% 
P.Array1 = [0 0];
P.Array2 = [0 0];
P.A = 0;
P.B = 0;

names = ["Array1", "Array2(1)", "A"];
exp_lin_flags = logical([0 0 0]);
x = [1, 2, 3, 8];
tags = [1, 1, 2, 3];
equals = {{"Array2(2)",3}}; % In this way Array2(2) is always set equal to "A"(3rd in names)

[cell_array, array_flags] = vector_to_cell_array(x, tags);
[P] = updateP(P, names, cell_array, exp_lin_flags, array_flags, equals);

disp(P)

