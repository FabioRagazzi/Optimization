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
P.num_points = 40;
P.LW = 2.5e-5;
P.LE = 2.5e-5;
P.nW = 7;
P.nE = 7;
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



P.L = 3.5e-4;
P.num_points = 40;
P.LW = 2.5e-5;
P.LE = 2.5e-5;
P.nW = 7;
P.nE = 7;
P.T = 60;
P.Phi_W = 0;
P.Phi_E = P.L * 1e7;
P.deltas = CreateDeltas(P.LW, P.LE, P.nW, P.nE, P.num_points, P.L);
P.EletStat = EletStat1D(P.deltas, P.eps, "sparse");

P.eps_r = 2.3;
P.phih = 1.148;
P.phie = 0.905;
P.n_start = [1e21, 1e21, 1e5, 1e5];

% Fixed parameters not depending on the electric field 
P.mu_h = 1e-13;
P.mu_e = 1e-13;
P.Bh = 2.4e-2;
P.Be = 1.2e-2;
P.Dh = 1e-3;
P.De = 1e-3;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 4e-3;



options.flagMu = 0;
options.flagB = 0;
options.flagD = 0;
options.flagS = 0;
options.flux_scheme = "Upwind";


rmpath('Functions\')








