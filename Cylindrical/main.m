%%
addpath("Functions\")
clearvars, clc, close all
time_instants = [0, logspace(0,5,59)];
[out] = Run("DOEDENS", time_instants, "coordinates","cylindrical", "source","off", "type","sparse");

%% CONFRONTO BASSEL
addpath("Functions\")
clearvars, clc, close all
% time_instants = [0, logspace(-5,log10(3660*24), 200)];
time_instants = linspace(0, 3600*24, (3600*24)/(1)+1);
[out] = Run("CONFRONTO_BASSEL", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% PLOT N
semilogy(out.P.geo.x, out.nh(:,1:12:end))
ylabel('$n_h (\mathrm{\frac{1}{m^3}})$','Interpreter','latex')
xlabel('$r (\mathrm{m})$','Interpreter','latex')
set(gca, 'FontSize', 15)
xlim([0.024, 0.042])

%% PLOT E
plot(out.P.geo.x_int, out.E(:,1), 'LineWidth',2, 'DisplayName','t = 0h')
hold on
plot(out.P.geo.x_int, out.E(:,13), 'LineWidth',2, 'DisplayName','t = 1h')
plot(out.P.geo.x_int, out.E(:,25), 'LineWidth',2, 'DisplayName','t = 2h')
plot(out.P.geo.x_int, out.E(:,37), 'LineWidth',2, 'DisplayName','t = 3h')
plot(out.P.geo.x_int, out.E(:,49), 'LineWidth',2, 'DisplayName','t = 4h')
plot(out.P.geo.x_int, out.E(:,61), 'LineWidth',2, 'DisplayName','t = 5h')
plot(out.P.geo.x_int, out.E(:,73), 'LineWidth',2, 'DisplayName','t = 6h')
plot(out.P.geo.x_int, out.E(:,end), 'k.', 'MarkerSize',20, 'LineWidth',2, 'DisplayName','t = 24h')
legend('Location','south','NumColumns',2)
xlabel('r (m)')
ylabel('E (V/m)')
set(gca, 'FontSize', 15)

%% PLOT ALL N
index_plot = 61;
semilogy(out.P.geo.x, out.ne(:,index_plot), 'DisplayName','ne', 'LineWidth',2)
hold on
semilogy(out.P.geo.x, out.nh(:,index_plot), 'DisplayName','nh', 'LineWidth',2)
semilogy(out.P.geo.x, out.net(:,index_plot), 'DisplayName','net', 'LineWidth',2)
semilogy(out.P.geo.x, out.nht(:,index_plot), 'DisplayName','nht', 'LineWidth',2)
legend('Location','south','NumColumns',2)
xlabel('r (m)')
ylabel('n (m^-^3)')
title('Number density at t = 1h')
set(gca, 'FontSize', 15)

%% PLOT ALL RHO
index_plot = 601;
semilogy(out.P.geo.x, out.P.e * out.ne(:,index_plot), 'DisplayName','ne', 'LineWidth',2)
hold on
semilogy(out.P.geo.x, out.P.e * out.nh(:,index_plot), 'DisplayName','nh', 'LineWidth',2)
semilogy(out.P.geo.x, out.P.e * out.net(:,index_plot), 'DisplayName','net', 'LineWidth',2)
semilogy(out.P.geo.x, out.P.e * out.nht(:,index_plot), 'DisplayName','nht', 'LineWidth',2)
legend('Location','south','NumColumns',2)
xlabel('r (m)')
ylabel('n (m^-^3)')
title('Charge density at t = 10m')
set(gca, 'FontSize', 15)

%% PLOT T
[x,t] = meshgrid(out.P.Tstruct.time/3600, out.P.geo.x_int); 
surf(x, t, out.P.Tstruct.matrix-out.P.abs0)

