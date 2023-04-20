%% Test Selecting parameters for Fit
clear, clc, close all
addpath("Functions\")

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
rmpath("Functions\")

%% Test Omega
clear, clc, close all
addpath("Functions\")
np = 10;
n = ones(np,4);
Ndeep = ones(np,2)/2;
B = ones(np,2);
D = ones(np,2);
S = ones(np,4);
[omega] = Omega(n, Ndeep, B, D, S);
disp(omega)
rmpath("Functions\")

%% Test Fluxes
clear, clc, close all
addpath("Functions\")
np = 10;
n = ones(np,2);
u = ones(np+1,2);
deltas = ones(1,np+1);
Vol = ones(np,1);
Diff = ones(np+1,2);
BC = magic(2);
options.flux_scheme = "Upwind";
[Gamma_close, Gamma_interfaces] = Fluxes(n, u, deltas, Vol, Diff, BC, options);
disp(Gamma_close)
disp(Gamma_interfaces)
rmpath("Functions\")

%% Test Recombination
clear, clc, close all
addpath("Functions\")
np = 10;
mu_center = ones(np,2);
mu_center(:,1) = mu_center(:,1) * 2;
mult_S = 3;
S_base = [1,7,3,11];
s = [2,4,6,8];
options.flagS = 'a';
[S] = Recombination(mu_center, mult_S, S_base, s);
disp(S)
rmpath('Functions\')

%% Test Detrapping
clear, clc, close all
addpath("Functions\")
np = 10;
E_center = ones(np,1);
mult_D = [1,2];
arg_sinh = [1,2];
add_D = [0, 3];
d = [-3, 5];
options.flagD = 1;
[D] = Detrapping(E_center, mult_D, arg_sinh, add_D, d, options);
disp(D)
rmpath('Functions\')

%% Test Trapping
clear, clc, close all
addpath("Functions\")
np = 10;
u_center = ones(np,2);
B0 = ones(np,2).*[2,-5];
mult_B = rand(np,2) * 1;
b = [-3, 5];
options.flagB = 1;
[B] = Trapping(u_center, B0, mult_B, b, options);
disp(B)
rmpath('Functions\')

%% Test Mobility
clear, clc, close all
addpath("Functions\")
E = ones(8,5);
ext_mult_sinh = [2,3];
arg_sinh = [4,5];
mu = [1,-1];
options.flagMu = 0;
[mu_h, mu_e] = Mobility(E, ext_mult_sinh, arg_sinh, mu, options);
disp(mu_h)
disp(mu_e)
rmpath('Functions\')

%% Test CreateDeltas & CreateX
clear, clc, close all
addpath("Functions\")
P.L = 3.5e-4;
P.num_points = 100;
P.LW = 2.5e-5;
P.LE = 2.5e-5;
P.nW = 1;
P.nE = 1;
P.deltas = CreateDeltas(P.LW, P.LE, P.nW, P.nE, P.num_points, P.L);
[x, x_int, x_face] = CreateX(P.deltas);

plot(x_int,zeros(size(x_int)),'b.','MarkerSize',15)
hold on
plot(x([1, end]),zeros(1,2),'r.','MarkerSize',15)
for i = 1:length(x_face)-1
    rectangle('Position', [x_face(i), -0.1, x_face(i+1)-x_face(i), 0.2])
end
ylim([-1, 1])
rmpath('Functions\')

%% Test OdefuncDriftDiffusion
clear, clc, close all
addpath("Functions\")

P = Parameters("CASE1");

% Specifying the options for the simulation
options.flagMu = 1;
options.flagB = 1;
options.flagD = 1;
options.flagS = 1;
options.flag_n = 1;
options.flux_scheme = "Upwind";
options.injection = "Fixed"; % Schottky / Fixed
options.ODE_options = odeset('Stats','off');

n_stato = rand(4*P.num_points,1);

[dndt] = OdefuncDriftDiffusion(3, n_stato, P, options);
disp(dndt)

rmpath('Functions\')

%% Test ComputeJCond
clear, clc, close all
addpath("Functions\")

np = 10;
nt = 5;
nh = rand(np, nt);
ne = rand(np, nt);
E = rand(np+1, nt);
Diff_h = rand(np+1, nt);
Diff_e = rand(np+1, nt);
u_h = rand(np+1, nt);
u_e = rand(np+1, nt);
deltas = rand(1, np+1);
aT2exp = [1, 1];
kBT = 1;
beta = 1;
e = 1;
options.flux_scheme = "Upwind";

[J_cond] = ComputeJCond(nh, ne, E, Diff_h, Diff_e, u_h, u_e, deltas, aT2exp, kBT, beta, e, options);
disp(J_cond)

rmpath('Functions\')

%% Test ComputedDdt
clear, clc, close all
addpath("Functions\")

np = 10;
nt = 7;
E = rand(np+1, nt);
t = rand(1,nt);
eps = 1;
dDdt = ComputedDdt(E, t, eps);
disp(dDdt)

rmpath('Functions\')

%% Name-Value Arguments
disp(myFunction(3, a=2, b=5))

% function result = myFunction(x, options)
%     arguments
%         x
%         options.a = 1;
%         options.b = 1;
%     end
%     result = x + options.a * options.b;
% end

%% Test TRRA
clearvars, clc, close all
addpath("Functions\")

load('data\Data_Seri.mat');
[names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP("CLASSIC");
P = Parameters("BEST_FIT_SERI");

options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flag_n = 1;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off');

names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "Ndeep(1)", "mu_h"]; 
tags = [1, 2, 3, 4, 5, 6, 7];

x = [1.3090, -0.4318, -1.4241, -2.8589-18.7953, 19.4116, 24.0893, -12.9162];

[out] = RunODEUpdating(x, tags, names, exp_lin_flags, equals, P, time_instants, options);
% [out] = RunODE(P, time_instants, options);
CompareSatoJdDdt(out, Jobjective, time_instants)

rmpath('Functions\')

%% EEEIC PHI
clearvars, clc, close all
addpath('Functions\')

P = Parameters("LE_ROY");
time_instants = [0, logspace(0, 5, 99)];

% Specifying the options for the simulation
options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off', 'Events',@(t,y)EventFcn(t,y));

phi_values = [1.3, 1.32, 1.34, 1.36];
linestyles = ["-", "--", ":", "-."];

for i = 1:length(phi_values)
    eval("P.phih = phi_values(" + num2str(i) + ");")
    eval("P.phie = phi_values(" + num2str(i) + ");")
    P = CompleteP(P);
    eval("out" + num2str(i) + " = RunODE(P, time_instants, options);")
end

for i = 1:4
    eval("graph" + num2str(i) + ".LineWidth = 2;")
    name = "φ = " + num2str(phi_values(i));
    eval("graph" + num2str(i) + ".DisplayName = name;")
    eval("graph" + num2str(i) + ".LineStyle = linestyles("+ num2str(i) +");")
end

x_zoom_interval = [0.6e4, 3e4];
y_zoom_interval = [0.2e-11, 2e-11];

% Big Figure
fig1 = figure;
hold on
grid on
for i = 1:4
    eval("loglog(out" + num2str(i) + ".tout, out" + num2str(i) + ".J_dDdt, graph" + num2str(i) + ")")
end
rectangle('Position',[x_zoom_interval(1), ...
                      y_zoom_interval(1), ...
                      x_zoom_interval(2) - x_zoom_interval(1), ...
                      y_zoom_interval(2) - y_zoom_interval(1)])
legend('Location','southwest')
xlim([1, x_zoom_interval(2)])
xticks(10.^[0, 1, 2, 3, 4])
xlabel('time (s)')
ylabel('current density (A/m^-^2)')
set(gca,'Xscale','log', 'Yscale','log', 'FontSize',15)

% Small Figure
ax = axes('Position',[0.45 0.55 0.3 0.3]);
box on
hold on
grid on
for i = 1:4
    eval("graph"+ num2str(i) +".Parent = ax;")
    eval("loglog(out" + num2str(i) + ".tout, out" + num2str(i) + ".J_dDdt, graph" + num2str(i) + ")")
end
ax.XLim = x_zoom_interval;
ax.YLim = y_zoom_interval;
set(gca,'Xscale','log', 'Yscale','log', 'FontSize',10)

annotation(fig1,'arrow',[0.75 0.88],[0.55 0.325]);

% Saving to .eps format
exportgraphics(fig1, 'data\PaperEEEICfigures\phi.eps')

rmpath('Functions\')

%% EEEIC MU
clearvars, clc, close all
addpath('Functions\')

P = Parameters("LE_ROY");
time_instants = [0, logspace(0, 4, 99)];

% Specifying the options for the simulation
options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off', 'Events',@(t,y)EventFcn(t,y));

mu_values = [1e-12, 1e-13, 1e-14, 1e-15];
linestyles = ["-", "--", ":", "-."];

% Simulations
for i = 1:length(mu_values)
    eval("P.mu_h = mu_values(" + num2str(i) + ");")
    eval("P.mu_e = mu_values(" + num2str(i) + ");")
    eval("out" + num2str(i) + " = RunODE(P, time_instants, options);")
end

% Settings for the various graphs
for i = 1:length(mu_values)
    eval("graph" + num2str(i) + ".LineWidth = 2;")
    name = "μ = " + num2str(mu_values(i));
    eval("graph" + num2str(i) + ".DisplayName = name;")
    eval("graph" + num2str(i) + ".LineStyle = linestyles("+ num2str(i) +");")
end

% Big Figure
fig1 = figure;
hold on
grid on
for i = 1:length(mu_values)
    eval("loglog(out" + num2str(i) + ".tout, out" + num2str(i) + ".J_dDdt, graph" + num2str(i) + ")")
end
legend
xlabel('time (s)')
ylabel('current density (A/m^-^2)')
set(gca,'Xscale','log', 'Yscale','log', 'FontSize',15)

% Saving to .eps format
exportgraphics(fig1, 'data\PaperEEEICfigures\mu.eps')

rmpath('Functions\')

%% EEEIC N0
clearvars, clc, close all
addpath('Functions\')

P = Parameters("LE_ROY");
time_instants = [0, logspace(0, 4, 99)];

% Specifying the options for the simulation
options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off', 'Events',@(t,y)EventFcn(t,y));

n0_values = [1e20, 1e19, 1e18, 1e17];
linestyles = ["-", "--", ":", "-."];

% Simulations
for i = 1:length(n0_values)
    eval("P.n_start(1) = n0_values(" + num2str(i) + ");")
    eval("P.n_start(2) = n0_values(" + num2str(i) + ");")
    eval("out" + num2str(i) + " = RunODE(P, time_instants, options);")
end

% Settings for the various graphs
for i = 1:length(n0_values)
    eval("graph" + num2str(i) + ".LineWidth = 2;")
    name = "n_0 = " + num2str(n0_values(i));
    eval("graph" + num2str(i) + ".DisplayName = name;")
    eval("graph" + num2str(i) + ".LineStyle = linestyles("+ num2str(i) +");")
end

% Big Figure
fig1 = figure;
hold on
grid on
for i = 1:length(n0_values)
    eval("loglog(out" + num2str(i) + ".tout, out" + num2str(i) + ".J_dDdt, graph" + num2str(i) + ")")
end
legend
xlabel('time (s)')
ylabel('current density (A/m^-^2)')
set(gca,'Xscale','log', 'Yscale','log', 'FontSize',15)

% Saving to .eps format
exportgraphics(fig1, 'data\PaperEEEICfigures\n0.eps')

rmpath('Functions\')

%% EEEIC FIT 1
clearvars, clc, close all
addpath('Functions\')

P = Parameters("EEEIC_FIT_1");
time_instants = [0, logspace(0, 5, 99)];

options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off', 'Events',@(t,y)EventFcn(t,y));

[out] = RunODE(P, time_instants, options);

load("data\Data_Seri_Original.mat")

% Big Figure
fig1 = figure;
hold on
grid on
index = find(out.tout>time_instants(1), 1) - 1;
loglog(t_Seri_original, J_Seri_original, 'LineWidth',2, 'LineStyle','-', 'DisplayName','Experimental Result')
loglog(out.tout(index:end), out.J_dDdt(index:end), 'LineWidth',2, 'LineStyle',':', 'DisplayName','Fitting #1')
legend
xlabel('time (s)')
ylabel('current density (A/m^-^2)')
set(gca,'Xscale','log', 'Yscale','log', 'FontSize',15)
ylim([2e-7, 5e-5])
xlim([1, 2e5])
xticks(10.^[0, 1, 2, 3, 4, 5])

% Saving to .eps format
exportgraphics(fig1, 'data\PaperEEEICfigures\fitting1.eps')

rmpath('Functions\')

%% EEEIC FIT 2
clearvars, clc, close all
addpath('Functions\')

P = Parameters("EEEIC_POSSIBLE_FIT_2");
time_instants = [0, logspace(0, 5, 99)] + 4.4694;

options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flux_scheme = "Upwind";
options.injection = "Schottky"; % Schottky / Fixed
options.source = "On";
options.ODE_options = odeset('Stats','off', 'Events',@(t,y)EventFcn(t,y));

[out] = RunODE(P, time_instants, options);

load("data\Data_Seri_Original.mat")

% Big Figure
fig1 = figure;
hold on
grid on
loglog(t_Seri_original, J_Seri_original, 'LineWidth',2, 'LineStyle','-', 'DisplayName','Experimental Result')
loglog(out.tout, out.J_dDdt, 'LineWidth',2, 'LineStyle',':', 'DisplayName','Fitting #2')
legend
xlabel('time (s)')
ylabel('current density (A/m^-^2)')
set(gca,'Xscale','log', 'Yscale','log', 'FontSize',15)
ylim([2e-7, 5e-5])
xlim([1, 2e5])
xticks(10.^[0, 1, 2, 3, 4, 5])

% Saving to .eps format
exportgraphics(fig1, 'data\PaperEEEICfigures\fitting2.eps')

rmpath('Functions\')

%% ARGUMENTS VALIDATION
clearvars, clc, close all
addpath('Functions\')

x = [3, 2, 5];
v = [1, 3, 2];
method = "spline";
out = myInterp(x, v, method, extra="A"); % x, v, method, extra="A"
disp(out)

rmpath('Functions\')

function [out] = myInterp(x,v,method,options)
    arguments
        x (1,:) {mustBeNumeric, mustBeReal} = [1,1,1]
        v (1,:) {mustBeNumeric, mustBeReal, mustBeEqualSize(v,x)} = [1,1,1]
        method (1,:) char {mustBeMember(method,{'linear','cubic','spline'})} = 'linear'
    end
    arguments
        options.extra (1,:) char {mustBeMember(options.extra,{'DefaultExtra','A','B'})} = 'DefaultExtra'
    end
    switch method
        case 'linear'
            out = x + v;
        case 'cubic'
            out = x .* v;
        case 'spline'
            out = x.^v;
    end
    fprintf(options.extra + "\n");
end

% Custom validation function
function mustBeEqualSize(a, b)
    % Test for equal size
    if ~isequal(size(a), size(b))
        eid = 'Size:notEqual';
        msg = 'Size of first input must equal size of second input.';
        throwAsCaller(MException(eid, msg))
    end
end

