clear, clc, close all
np = 20;
dx = rand(np+1,1) * 5;
options.coordinates = "cylindrical";
options.type = "normal";
x0 = 1;
eps = ones(np,1);
rho = zeros(np,1);
PhiW = 0;
PhiE = 1000;

geo = CreateGeometry1D(x0, dx, options);
EletStat = CreateEletStat(geo, eps, options);
phi = SolveEletStat(EletStat, rho, PhiW, PhiE);
E = ComputeE(geo, phi, PhiW, PhiE);

x_analytical = linspace(x0, geo.x_int(end), 1000);
if options.coordinates == "cylindrical"
    phi_analytical = @(r) PhiW + (PhiE - PhiW) * log(r / x0) / log(geo.x_int(end) / x0);
    E_analytical = @(r) -(PhiE - PhiW) ./ (log(geo.x_int(end) / x0) * r);
elseif options.coordinates == "cartesian"
    phi_analytical = @(x) PhiW + (PhiE - PhiW) * (x - x0) / (geo.x_int(end) - x0);
    E_analytical = -(PhiE - PhiW) / (geo.x_int(end) - x0);
end

figure
plot(geo.x, phi, '.', 'MarkerSize',20)
hold on
plot(x_analytical, phi_analytical(x_analytical))

figure
plot(geo.x_int, E, '.', 'MarkerSize',20)
hold on
if options.coordinates == "cylindrical"
    plot(x_analytical, E_analytical(x_analytical))
elseif options.coordinates == "cartesian"
    plot(x_analytical, E_analytical * ones(size(x_analytical)))
end
