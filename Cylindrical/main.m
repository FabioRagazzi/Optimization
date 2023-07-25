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

%% PLOT E HOUR
plot(out.P.geo.x_int, out.E(:,1), 'LineWidth',2, 'DisplayName','t = 0h')
hold on
for i = 1:6
    plot(out.P.geo.x_int, out.E(:,3600*i+1), 'LineWidth',2, 'DisplayName',"t = "+ num2str(i) +"h") 
end
% plot(out.P.geo.x_int, out.E(:,end), 'k.', 'MarkerSize',20, 'LineWidth',2, 'DisplayName','t = 24h')
legend('Location','south','NumColumns',2)
grid on
xlabel('r (m)')
ylabel('E (V/m)')
set(gca, 'FontSize', 15)






%% BASSEL 20
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("BASSEL_20", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% BASSEL 70
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("BASSEL_70", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% BASSEL 70 55
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("BASSEL_70_55", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% BASSEL 70 55 EXPLICIT
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = RunExplicit("BASSEL_70_55", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% PLOT ELECTRIC FIELD AT CONVENTIONAL INSTANTS
conventional_times = [1, [1,5,10,20,30]*60, (1:24)*3600];
fig1 = figure();
ax1 = axes(fig1);
hold on
for i = 1:length(conventional_times)
    plot(ax1, out.P.geo.x_int, out.E(:,conventional_times(i)+1), 'LineWidth',1,...
        'DisplayName',"t = "+ SecondsToString(conventional_times(i))) 
end
legend('Location','south','NumColumns',2)
grid on
xlabel('r (m)')
ylabel('E (V/m)')
set(gca, 'FontSize', 15)

%% CREATE CONVENTIONAL ELECTRIC FIELD STRUCT
conventional_times = [1, [1,5,10,20,30]*60, (1:24)*3600];
struct.x = out.P.geo.x_int;
struct.E = zeros(length(conventional_times), out.P.geo.np+1);
struct.labels = string(zeros(1, length(conventional_times)));
for i = 1:length(conventional_times)
    struct.E(i,:) = out.E(:,conventional_times(i)+1)';
    struct.labels(i) = SecondsToString(conventional_times(i));
end

%% CREATE CONVENTIONAL CHARGE DENSITY STRUCT
conventional_times = [1, [1,5,10,20,30]*60, (1:24)*3600];
struct.x = out.P.geo.x;
struct.rho_e = zeros(length(conventional_times), out.P.geo.np);
struct.rho_h = zeros(length(conventional_times), out.P.geo.np);
struct.rho_et = zeros(length(conventional_times), out.P.geo.np);
struct.rho_ht = zeros(length(conventional_times), out.P.geo.np);
struct.labels = string(zeros(1, length(conventional_times)));
for i = 1:length(conventional_times)
    struct.rho_e(i,:) = out.ne(:,conventional_times(i)+1)';
    struct.rho_h(i,:) = out.nh(:,conventional_times(i)+1)';
    struct.rho_et(i,:) = out.net(:,conventional_times(i)+1)';
    struct.rho_ht(i,:) = out.nht(:,conventional_times(i)+1)';
    struct.labels(i) = SecondsToString(conventional_times(i));
end

struct.rho_e = struct.rho_e * out.P.e;
struct.rho_h = struct.rho_h * out.P.e;
struct.rho_et = struct.rho_et * out.P.e;
struct.rho_ht = struct.rho_ht * out.P.e;

% semilogy(struct.x, struct.rho_e)
% i = 2; semilogy(struct.x, [struct.rho_e(i,:); struct.rho_h(i,:); struct.rho_et(i,:); struct.rho_ht(i,:)]')

%% CREATE GLOBAL CONVENTIONAL STRUCTURE
conventional_times = [1, [1,5,10,20,30]*60, (1:24)*3600];
struct.x_int = out.P.geo.x_int;
struct.x = out.P.geo.x;
struct.E = zeros(length(conventional_times), out.P.geo.np+1);
struct.rho_e = zeros(length(conventional_times), out.P.geo.np);
struct.rho_h = zeros(length(conventional_times), out.P.geo.np);
struct.rho_et = zeros(length(conventional_times), out.P.geo.np);
struct.rho_ht = zeros(length(conventional_times), out.P.geo.np);
struct.labels = string(zeros(1, length(conventional_times)));
for i = 1:length(conventional_times)
    struct.E(i,:) = out.E(:,conventional_times(i)+1)';
    struct.rho_e(i,:) = out.ne(:,conventional_times(i)+1)';
    struct.rho_h(i,:) = out.nh(:,conventional_times(i)+1)';
    struct.rho_et(i,:) = out.net(:,conventional_times(i)+1)';
    struct.rho_ht(i,:) = out.nht(:,conventional_times(i)+1)';
    struct.labels(i) = SecondsToString(conventional_times(i));
end

struct.rho_e = struct.rho_e * out.P.e;
struct.rho_h = struct.rho_h * out.P.e;
struct.rho_et = struct.rho_et * out.P.e;
struct.rho_ht = struct.rho_ht * out.P.e;

%% COMPARISON
clearvars, clc, close all
id = "70_55";
Bassel = load("Bassel\Temperature" + id + ".mat");
Me = load("MyResults\Temperature" + id + ".mat");
F = Me.("T" + id);
B = Bassel.("T" + id);
clear id Bassel Me

B_interp = B;
B_interp.rho_e = interp1(B.x, B.rho_e', F.x)';
B_interp.rho_h = interp1(B.x, B.rho_h', F.x)';
B_interp.rho_et = interp1(B.x, B.rho_et', F.x)';
B_interp.rho_ht = interp1(B.x, B.rho_ht', F.x)';
B_interp.E = interp1(B.x, B.E', F.x_int)';
B_interp.x = F.x;
B_interp.x_int = F.x_int;

Graph(F, B_interp, 20);

%%
function [fig] = Graph(F, B, i)

    fig = tiledlayout(2,2);
    ri = 24.5676e-3;
    ro = 24.5676e-3 + 17.9e-3;
    poptF.LineStyle = "none";poptF.Marker = ".";poptF.MarkerSize = 15;poptF.DisplayName = "F";
    poptB.LineStyle = "none";poptB.Marker = "o";poptB.MarkerSize = 5;poptB.DisplayName = "B";

    for s = ["e", "h", "et", "ht"]
        nexttile
        eval("semilogy(F.x, F.rho_" + s + "(i,:), poptF)")
        hold on
        eval("semilogy(B.x, B.rho_" + s + "(i,:), poptB)")
        grid on
        xlim([ri, ro])
        xlabel("$r (\mathrm{m})$", "Interpreter","latex")
        eval("ylabel('$\rho_" + s + " (\mathrm{Cm^{-3}})$','Interpreter','latex')")
        legend("Interpreter","latex")
        set(gca, "FontSize",15)
    end
end
