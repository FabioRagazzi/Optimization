clear, clc, close all
np = 100;
dx = rand(np+1,1);
options.geometry = "cartesian";
options.type = "sparse";
x0 = 1;
geometry = CreateGeometry1D(1, dx);
eps = ones(np,1);
rho = zeros(np,1);
PhiW = 0;
PhiE = 100;
EletStat = CreateEletStat(geometry, eps, options);
phi = SolveEletStat(EletStat, rho, PhiW, PhiE);
E = ComputeE(phi, PhiW, PhiE, dx);

% phi_analytical = @(r) PhiW + (PhiE - PhiW) * log(r / x0) / log(geometry.x_int(end) / x0);
% E_analytical = @(r) -(PhiE - PhiW) ./ (log(geometry.x_int(end) / x0) * r);

phi_analytical = @(x) PhiW + (PhiE - PhiW) * (x - x0) / (geometry.x_int(end) - x0) ;
E_analytical = -(PhiE - PhiW) / (geometry.x_int(end) - x0) ;

x_analytical = linspace(x0, geometry.x_int(end), 1000);

figure
plot(geometry.x, phi, '.', 'MarkerSize',20)
hold on
plot(x_analytical, phi_analytical(x_analytical))

figure
plot(geometry.x_int, E, '.', 'MarkerSize',20)
hold on
plot(x_analytical, E_analytical * ones(size(x_analytical)))
