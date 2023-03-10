clear, clc
nh = linspace(1,5,8).*ones(5,8) * 1e18;
ne = linspace(1,5,8).*ones(5,8) * 1e18;
E = -ones(6,8) * 5e6;
t = 1:8;
K_diff_h = 1e-5; 
K_diff_e = 1e-5;
mu_h = 1e-12;
mu_e = 1e-12;
Delta = 1e-3;
a = 7.5005e12;
eps_r = 2;
aps = 8.854e-12 * eps_r;
T = 273.15 + 60;
phi_e = 0.5;
phi_h = 0.5;
kBT = 1.3801e-23 * T;
beta = 6.08e-24 / sqrt(eps_r);
e = 1.6022e-19;
aT2exp = a * (T^2) * exp(-[phi_e, phi_h] * e / kBT); 

J_cond = compute_J_cond(nh, ne, E, K_diff_h, K_diff_e, mu_h, mu_e, Delta, aT2exp, kBT, beta, e);
% disp(J_cond)

dDdt = compute_dDdt(E, t, eps);
disp(dDdt)