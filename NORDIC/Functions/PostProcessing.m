function [nh, ne, nht, net, rho, phi, E, J_Sato, J_dDdt, mu_h, mu_e] = PostProcessing(nout, tout, P, options)
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
phi = zeros(P.num_points + 2, num_iter);
nh = nout(:, 1:P.num_points)';
ne = nout(:, P.num_points+1:2*P.num_points)';
nht = nout(:, 2*P.num_points+1:3*P.num_points)';
net = nout(:, 3*P.num_points+1:4*P.num_points)';
rho = (nh - ne + nht - net) * P.e;
phi(2:end-1,:) = SolveEletStat(P.EletStat, rho, P.Phi_W, P.Phi_E);
phi(1,:) = P.Phi_W; 
phi(end,:) = P.Phi_E;
E = ComputeE(phi(2:end-1,:), P.Phi_W, P.Phi_E, P.deltas);

[mu_h, mu_e] = Mobility(E, P.ext_mult_sinh, P.arg_sinh, [P.mu_h, P.mu_e], options);
u_h = E .* mu_h;
u_e = -E .* mu_e;
Diff_h = mu_h * P.kBT / P.e;
Diff_e = mu_e * P.kBT / P.e;

J_cond = ComputeJCond(nh, ne, E, Diff_h, Diff_e, u_h, u_e, P.deltas, P.aT2exp, P.kBT, P.beta, P.e, options);
dDdt = ComputedDdt(E, tout', P.eps);
J_dDdt = -IntegralFunc((J_cond + dDdt)', P.delta_x_face) / P.L;
J_Sato = -IntegralFunc(J_cond', P.delta_x_face) / P.L;

% 
% J = zeros(num_iter,1); % Polarization current/current density (unit area)
% for k = 1:num_iter
%     n_k = reshape(nout(k,:),[P.num_points,4]);
%     if flag_mobility_dependent_on_E
%         [mu_h, mu_e] = Mobility(E(:,k), P.ext_mult_sinh, P.arg_sinh);
%         mu = [mu_h, mu_e];
%     else
%         mu = [P.mu_h, P.mu_e] .* ones(size(E(:,k)));
%     end
%     u_k = E(:,k) .* mu .* [1 -1];
%     Diff = mu * P.kBT / P.e;
%     [~, Gamma_interfaces] = Fluxes(n_k(:,1:2), P.num_points, u_k, P.Delta, Diff, E(1,k), E(end,k), P.aT2exp, P.kBT, P.beta);
%     f = sum(Gamma_interfaces.*[1,-1], 2);
%     J(k) = -integral_func(f', P.Delta) * P.e / P.L;
% end

end

