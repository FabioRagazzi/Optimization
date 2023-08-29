function [dndt] = OdeFuncDD(t, n_stato, P, options)
% OdeFuncDD Summary of this function goes here
%   Detailed explanation goes here

n = reshape(n_stato, [], 4);
rho = sum(n.*[1, -1, 1, -1],2) * P.e;
phi = SolveEletStat(P.EletStat, rho, P.Phi_W, P.Phi_E);
E = ComputeE(P.geo, phi, P.Phi_W, P.Phi_E);
[T_int, T] = GetTemperature(t, P.Tstruct, P.geo);
P = TemperatureParameters(P, T_int, T);

% if t > 1
%     ;
% end

arg_sinh_E = P.arg_sinh .* E;
mu = P.ext_mult_sinh .* sinh(arg_sinh_E) ./ E;
% mu([1,end],:) = 0; % charge blocking electrodes
u = E .* mu .* [1 -1];
K = P.kBT_int .* mu / P.e; 
% u_center = (u(1:end-1,:) + u(2:end,:)) / 2;
B = ones(P.geo.np, 2) .* [0.2, 0.1]; % B = P.B0 + P.mult_B .* abs(u_center);
% arg_sinh_E_center = (arg_sinh_E(1:end-1,:) + arg_sinh_E(2:end,:)) / 2;
D = P.add_D; % D = P.mult_D .* sinh(abs(arg_sinh_E_center)) + P.add_D;
mu_center = (mu(1:end-1,:) + mu(2:end,:)) / 2;
S = P.S_base + mu_center * [0, 0, 1, 1; 0, 1, 0, 1] * P.mult_S;
Inj = P.aT2exp .* ( exp( P.beta*sqrt( abs(E([end,1])) )./P.kBT_int([end,1]) ) - 1 );
[~, Gamma] = Fluxes(n(:,1:2), u, K, P.geo, Inj(2), Inj(1));
dndt = Omega(n, P.Ndeep, B, D, S, options);
dndt(1:2*P.geo.np) = dndt(1:2*P.geo.np) - Gamma;

end
