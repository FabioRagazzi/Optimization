function [dndt] = OdeFuncDD(t, n_stato, P, options)
% OdeFuncDD Summary of this function goes here
%   Detailed explanation goes here

n = reshape(n_stato, [], 4);
rho = sum(n.*[1, -1, 1, -1],2) * P.e;
phi = SolveEletStat(P.EletStat, rho, P.Phi_W, P.Phi_E, options);
E = ComputeE(phi, P.Phi_W, P.Phi_E, P.dx);
T = GetTemperature(t, P.Tmatrix, P.t_Temp);
mu = ComputeMobility(P, T, options);
u = E .* mu .* [1 -1];
K = ComputeK(P, T, options);
B = ComputeB(P, T, options);
D = ComputeD(P, T, options);
S = ComputeS(P, T, options);
Inj = Schottky(E([1, end])', P.aT2exp, P.kBT, P.beta);
Gamma = Fluxes(n, u, K, P, Inj(1), Inj(2), options);
dndt = Omega(n, P.Ndeep, B, D, S, options);
dndt(1:2*P.np) = dndt(1:2*P.np) - Gamma;

end
