function [nh, ne, nht, net, rho, phi, E, J_Sato, J_from_dDdt] = PostProcessing(nout, tout, P, delta_x_face)
% PostProcessing
% nout -> matrix with each line containing the number density at a time instant
% tout -> column vector with the time instants considered
% P -> struct containing all the parameters of the simulation
% delta_x_face -> row vector containig the spacing between the interfaces
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

J_cond = ComputeJCond(nh, ne, E, P.D_h, P.D_e, P.mu_h, P.mu_e, P.deltas, P.aT2exp, P.kBT, P.beta, P.e);
dDdt = Compute_dDdt(E, tout', P.eps);
J_dDdt = J_cond + dDdt;
J_from_dDdt = -IntegralFunc(J_dDdt', delta_x_face) / P.L;
J_Sato = -IntegralFunc(J_cond', delta_x_face) / P.L;

% J = zeros(num_iter,1); % Polarization current/current density (unit area)
% % for k = 1:num_iter
% %     n_k = reshape(nout(k,:),[P.num_points,4]);
% %     u_k = E(:,k) .* [P.mu_h, -P.mu_e];
% %     [~, Gamma_interfaces] = Fluxes(n_k(:,1:2), P.num_points, u_k, P.Delta, P.D_h, P.D_e, E(1,k), E(end,k), P.aT2exp, P.kBT, P.beta);
% %     f = sum(Gamma_interfaces.*[1,-1], 2);
% %     J(k) = -integral_func(f', P.Delta) * P.e / P.L;
% % end

end

