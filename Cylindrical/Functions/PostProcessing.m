function [nh, ne, nht, net, rho, phi, E, J_Sato] = PostProcessing(nout, tout, P)
% PostProcessing extracts all the useful informations from a simulation
% INPUT
% nout -> matrix with each line containing the number density at a time instant
% tout -> column vector with the time instants considered
% P -> struct containing all the parameters of the simulation
% options -> struct with the options for the simulation
% OUTPUT
% nh -> free holes (each column corresponds to a time instant)
% ne -> free electrons (each column corresponds to a time instant)
% nh -> trapped holes (each column corresponds to a time instant)
% nh -> trapped electrons (each column corresponds to a time instant)
% rho -> charge density (each column corresponds to a time instant)
% phi -> electric potential (each column corresponds to a time instant)
% E -> electric field (each column corresponds to a time instant)
% J_Sato -> column vector with the current density calculated using Sato formula
% J_dDdt -> column vector with the current density calculated with calssical approach
num_iter = length(tout);
phi = zeros(P.geo.np + 2, num_iter);
nh = nout(:, 1:P.geo.np)';
ne = nout(:, P.geo.np+1:2*P.geo.np)';
nht = nout(:, 2*P.geo.np+1:3*P.geo.np)';
net = nout(:, 3*P.geo.np+1:4*P.geo.np)';
rho = (nh - ne + nht - net) * P.e;
phi(2:end-1,:) = SolveEletStat(P.EletStat, rho, P.Phi_W, P.Phi_E);
phi(1,:) = P.Phi_W; 
phi(end,:) = P.Phi_E;
E = ComputeE(P.geo, phi(2:end-1,:), P.Phi_W, P.Phi_E);

T_struct_matrix = zeros(P.geo.np+1,num_iter);
for i = 1:num_iter
    T_struct_matrix(:,i) = GetTemperature(tout(i), P.Tstruct, P.geo);
end

%kBT_matrix = P.kB * P.Tstruct.matrix;
kBT_matrix = P.kB * T_struct_matrix;
v_matrix = kBT_matrix / P.h;
Boltz_num_matrix = P.e ./ kBT_matrix;

ext_mult_sinh_h = 2 * v_matrix * P.a_int(1) .* exp(-P.w_hop(1) * Boltz_num_matrix);
ext_mult_sinh_e = 2 * v_matrix * P.a_int(2) .* exp(-P.w_hop(2) * Boltz_num_matrix);
arg_sinh_h = P.e * P.a_sh(1) ./ (2 * kBT_matrix);
arg_sinh_e = P.e * P.a_sh(2) ./ (2 * kBT_matrix);

mu_h = ext_mult_sinh_h .* sinh(arg_sinh_h .* E) ./ E;
mu_e = ext_mult_sinh_e .* sinh(arg_sinh_e .* E) ./ E;

u_h = E .* mu_h;
u_e = -E .* mu_e;

K_h = kBT_matrix .* mu_h / P.e;
K_e = kBT_matrix .* mu_e / P.e;

% aT2exp_e = P.lambda_e * P.a * P.Tstruct.matrix(1,:).^2 .* exp(-P.phie .* Boltz_num_matrix(1,:));
% aT2exp_h = P.lambda_h * P.a * P.Tstruct.matrix(end,:).^2 .* exp(-P.phih .* Boltz_num_matrix(end,:));

aT2exp_e = P.lambda_e * P.a * T_struct_matrix(1,:).^2 .* exp(-P.phie .* Boltz_num_matrix(1,:));
aT2exp_h = P.lambda_h * P.a * T_struct_matrix(end,:).^2 .* exp(-P.phih .* Boltz_num_matrix(end,:));

Inj_e = aT2exp_e .* ( exp( P.beta*sqrt( abs(E(1,:)) )./kBT_matrix(1,:) ) - 1 );
Inj_h = aT2exp_h .* ( exp( P.beta*sqrt( abs(E(end,:)) )./kBT_matrix(end,:) ) - 1 );

J_cond = ComputeJCond(nh, ne, E, K_h, K_e, u_h, u_e, Inj_e, Inj_h, P.geo.dx, P.e);

J_Sato = -IntegralFunc(J_cond', P.geo.dx_int') / P.geo.L;

end
