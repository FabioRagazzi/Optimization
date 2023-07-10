%% TEST 1
my_start()
np = 100;
R0 = 5;
deltas = logspace(1e-2, 1, np+1);
RF = R0 + sum(deltas);
[~, x_int, x_face] = CreateX(deltas);
r_int = x_int + R0;
r_face = x_face + R0;
V0 = 0; 
VF = 100;
dV = VF - V0;
phi_analytical = @(r) V0 + dV * log(r / R0) / log(RF / R0);
E_analytical = @(r) -dV ./ (log(RF / R0) * r);
eps = 1;
rho = zeros(np,1);

Check(R0, RF, deltas, eps, rho, V0, VF, r_int, r_face, phi_analytical, E_analytical);

%% TEST 2
my_start()
np = 100;
R0 = 5;
deltas = logspace(1e-2, 1, np+1);
RF = R0 + sum(deltas);
[~, x_int, x_face] = CreateX(deltas);
r_int = x_int + R0;
r_face = x_face + R0;
V0 = 0; 
VF = 100;
dV = VF - V0;
K = 1e2;
A = (-dV - K*(RF^2 - R0^2)/4) / (log(RF/R0));
B = V0 + K*R0^2/4 + A*log(R0);
phi_analytical = @(r) -K*r.^2/4 - A*log(r) + B;
E_analytical = @(r) K*r/2 + A./r;
eps = rand(np, 1);
rho = K * eps;

Check(R0, RF, deltas, eps, rho, V0, VF, r_int, r_face, phi_analytical, E_analytical);

%%
function [] = Check(R0, RF, deltas, eps, rho, PhiW, PhiE, r_int, r_face, phi_analytical, E_analytical)
    [EletStat] = EletStatCylindrical(R0, deltas, eps, "type","normal");
    [phi] = SolveEletStat(EletStat, rho, PhiW, PhiE);
    [E] = ComputeE(phi, PhiW, PhiE, deltas);
    r = linspace(R0, RF, 1000);
    figure
    plot(r, phi_analytical(r))
    hold on
    plot(r_int, phi, 'r.', 'MarkerSize',20);
    figure
    plot(r, E_analytical(r))
    hold on
    plot(r_face, E, 'g.', 'MarkerSize',20);
end

function [] = my_start()
    addpath("..\Functions\")
    clearvars, clc, close all
end
