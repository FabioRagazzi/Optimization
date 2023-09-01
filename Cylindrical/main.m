%% TRANSITORIO
addpath("Functions\")
clearvars, clc, close all
[out] = Run("Trans_5d_TB852", ...
            [0, 4, 12, 24, 48, 72, 96, 120]*3600, ...
            "coordinates","cylindrical", ...
            "source","on", ...
            "type","sparse");

% [0, 1, [1,5,10,20,30]*60, 3600, (4:4:24)*3600]
% 3600*GenerateTimeArrayMultipleDays([0, 4, 12, 20, 24], 5),...

%% PLOT E
fig1 = figure(); ax1 = axes(fig1);
hold on
ID = gobjects(1,length(out.tout));
for i = 1:length(out.tout)
    ID(i) = plot(ax1, out.P.geo.x_int, out.E(:,i), 'Color',[0.6 0.6 0.6], 'LineWidth',1,...
        'DisplayName',"t = "+ SecondsToString(out.tout(i))); 
end
legend('Location','south','NumColumns',4)
grid on, xlabel('r (m)'), ylabel('E (V/m)'), set(gca, 'FontSize',15)

i = 1; ID(i).Color = [1, 0, 0]; ID(i).LineWidth = 2;
% xlim([0.02456,0.0247])
% ylim([1.8, 2.4]*10^7)

% i=i+1; ID(i).Color = [1, 0, 0]; ID(i).LineWidth = 2; ID(i-1).Color = [0.6, 0.6, 0.6]; ID(i-1).LineWidth = 1;
% i=i-1; ID(i).Color = [1, 0, 0]; ID(i).LineWidth = 2; ID(i+1).Color = [0.6, 0.6, 0.6]; ID(i+1).LineWidth = 1;

% ID(2).Color = [0, 1, 0]; ID(2).LineWidth = 2;
% ID(3).Color = [0, 0, 1]; ID(3).LineWidth = 2;
% ID(5).Color = [0, 0, 0]; ID(5).LineWidth = 3;
% ID(9).Color = [1, 1, 0]; ID(9).LineWidth = 3;
% ID(13).Color = [0, 1, 1]; ID(13).LineWidth = 3;
% ID(17).Color = [1, 0, 1]; ID(17).LineWidth = 3;
% ID(21).Color = [0, 0, 0]; ID(21).LineWidth = 3;

ID(1).Color = [0, 0, 0]; ID(1).LineWidth = 2;
ID(2).Color = [1, 0, 0]; ID(2).LineWidth = 2;
ID(3).Color = [0, 1, 0]; ID(3).LineWidth = 2;
ID(4).Color = [0, 0, 1]; ID(4).LineWidth = 2;
ID(5).Color = [0, 1, 1]; ID(5).LineWidth = 2;
ID(6).Color = [1, 0, 1]; ID(6).LineStyle="none"; ID(6).Marker="o"; ID(6).MarkerSize=8;
ID(7).Color = [255, 128, 0]/255; ID(7).LineStyle="none"; ID(7).Marker="square"; ID(7).MarkerSize=10;
ID(8).Color = [0, 103, 0]/255; ID(8).LineStyle="none"; ID(8).Marker="."; ID(8).MarkerSize=20;



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






%% TEMPERATURE 20, 100 POINTS
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("T_20_100p", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% TEMPERATURE 20, 200 POINTS, REFINED MESH
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("T_20_200p_refined", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% TEMPERATURE 20, 500 POINTS
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("T_20_500p", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% BASSEL 70
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("T_70_100p", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% BASSEL 70 55
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = Run("T_70_55_100p", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% BASSEL 70 55 EXPLICIT
addpath("Functions\")
clearvars, clc, close all
time_instants = linspace(0, 3600*24, 3600*24+1);
[out] = RunExplicit("T_70_55_100p", time_instants, "coordinates","cylindrical", "source","on", "type","sparse");

%% PLOT ELECTRIC FIELD AT CONVENTIONAL INSTANTS
conventional_times = [1, [1,5,10,20,30]*60, (1:24)*3600];
fig1 = figure();
ax1 = axes(fig1);
hold on
for i = 1:length(conventional_times)
    plot(ax1, out.P.geo.x_int, out.E(:,conventional_times(i)+1), 'LineWidth',1,...
        'DisplayName',"t = "+ SecondsToString(conventional_times(i))) 
end
% legend('Location','south','NumColumns',2)
grid on
xlabel('r (m)')
ylabel('E (V/m)')
set(gca, 'FontSize', 15)
% xlim([0.02456,0.0247])
% ylim([1.8, 2.4]*10^7)

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
struct.x_phi = [out.P.geo.x_int(1); out.P.geo.x; out.P.geo.x_int(end)];
struct.phi = zeros(length(conventional_times), out.P.geo.np+2);
struct.E = zeros(length(conventional_times), out.P.geo.np+1);
struct.rho_e = zeros(length(conventional_times), out.P.geo.np);
struct.rho_h = zeros(length(conventional_times), out.P.geo.np);
struct.rho_et = zeros(length(conventional_times), out.P.geo.np);
struct.rho_ht = zeros(length(conventional_times), out.P.geo.np);
struct.labels = string(zeros(1, length(conventional_times)));
for i = 1:length(conventional_times)
    struct.phi(i,:) = out.phi(:,conventional_times(i)+1)';
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

% F = struct;
% plot(F.x_phi, F.phi(30,:))

%% COMPARISON
clearvars, clc, close all
id = "20";
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

%% UPDATED COMPARISON
clearvars, clc, close all
id = "20";
Bassel = load("Bassel\Ghost\Temperature" + id + ".mat");
Me = load("Results_with_phi\Temperature" + id + ".mat");
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

%% rho
Graph(F, B_interp, 30);

%% E
fig = tiledlayout(1,2);
nexttile
plot(B.x, B.E)
nexttile
plot(F.x_int, F.E)

%% E_interp
fig = tiledlayout(1,2);
nexttile
plot(B_interp.x_int, B_interp.E)
nexttile
plot(F.x_int, F.E)

%% Err E
i = 30;
diff = abs(B_interp.E(i,:) - F.E(i,:)/1e6);
err_perc = 100 * abs(B_interp.E(i,:) - F.E(i,:)/1e6) ./ (F.E(i,:)/1e6);
fig = tiledlayout(1,2);
nexttile
plot(F.x_int, err_perc)
title("% Error")
nexttile
plot(F.x_int, diff)
title("Abs difference")

%% Err%
GraphErr(F, B_interp, 30, '%');

%% Diff
GraphErr(F, B_interp, 30);

%%
function [fig] = Graph(F, B, i)

    fig = tiledlayout(2,2);
    ri = 24.5676e-3;
    ro = 24.5676e-3 + 17.9e-3;
    poptF.LineStyle = "none";poptF.Marker = ".";poptF.MarkerSize = 15;poptF.DisplayName = "F";
    poptB.LineStyle = "none";poptB.Marker = "o";poptB.MarkerSize = 5;poptB.DisplayName = "B";

    for s = ["e", "h", "et", "ht"]
        nexttile
        eval("plot(F.x, F.rho_" + s + "(i,:), poptF)")
        hold on
        eval("plot(B.x, B.rho_" + s + "(i,:), poptB)")
        grid on
        xlim([ri, ro])
        xlabel("$r (\mathrm{m})$", "Interpreter","latex")
        eval("ylabel('$\rho_{" + s + "} (\mathrm{Cm^{-3}})$','Interpreter','latex')")
        legend("Interpreter","latex")
        set(gca, "FontSize",15)
    end
end

function [fig] = GraphErr(F, B, i, kind)

    arguments
        F
        B
        i
        kind char {mustBeMember(kind,{'%','Diff'})} = "Diff"
    end

    fig = tiledlayout(2,2);
    ri = 24.5676e-3;
    ro = 24.5676e-3 + 17.9e-3;
    plotoptions.LineStyle = "none";
    plotoptions.Marker = ".";
    plotoptions.MarkerSize = 15;

    for s = ["e", "h", "et", "ht"]
        nexttile
        if kind == "%"
            eval("err_" + s + " = 100 * (F.rho_" + s + "(i,:) - B.rho_" + s + "(i,:))./(F.rho_" + s + "(i,:));")
        elseif kind == "Diff"
            eval("err_" + s + " = F.rho_" + s + "(i,:) - B.rho_" + s + "(i,:);")
        end
        eval("plot(F.x, err_" + s + ", plotoptions)")
        grid on
        xlim([ri, ro])
        xlabel("$r (\mathrm{m})$", "Interpreter","latex")
        if kind == "%"
            eval("ylabel('$\% Difference \; \rho_{" + s + "}$','Interpreter','latex')")
        elseif kind == "Diff"
            eval("ylabel('$Difference \; \rho_{" + s + "}$','Interpreter','latex')")
        end
        set(gca, "FontSize",15)
    end

end
