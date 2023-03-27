function [nh, ne, nht, net, rho, phi, E, J, J_from_dDdt] = post_processing(nout, tout, P, flag_mobility_dependent_on_E)
% POST_PROCESSING
% nout -> matrix with each line containing the number density at a time instant
% tout -> column vector with the time instants considered
% P -> struct containing all the parameters of the simulation
% flag_mobility_dependent_on_E -> true if the mobility is dependent on E
num_iter = length(tout);
phi = zeros(P.num_points + 2, num_iter);
nh = nout(:, 1:P.num_points)';
ne = nout(:, P.num_points+1:2*P.num_points)';
nht = nout(:, 2*P.num_points+1:3*P.num_points)';
net = nout(:, 3*P.num_points+1:4*P.num_points)';
rho = (nh - ne + nht - net) * P.e;
rho_aux = rho;
rho_aux(1,:) = rho_aux(1,:) + P.coeff * P.Phi_W;
rho_aux(end,:) = rho_aux(end,:) + P.coeff * P.Phi_E;
phi(2:end-1,:) = P.Kelet\rho_aux;
phi(1,:) = P.Phi_W; 
phi(end,:) = P.Phi_E;
E = Electric_Field(phi(2:end-1,:), P.Delta, P.Phi_W, P.Phi_E);

if flag_mobility_dependent_on_E
    [mu_h, mu_e] = Mobility(E, P.ext_mult_sinh, P.arg_sinh);
else
    mu_h = P.mu_h * ones(size(E));
    mu_e = P.mu_e *  ones(size(E));
end
u_h = E .* mu_h;
u_e = -E .* mu_e;
Diff_h = mu_h * P.kBT / P.e;
Diff_e = mu_e * P.kBT / P.e;
J_cond = compute_J_cond(nh, ne, E, Diff_h, Diff_e, u_h, u_e, P.Delta, P.aT2exp, P.kBT, P.beta, P.e);
dDdt = compute_dDdt(E, tout', P.eps);
J_dDdt = J_cond + dDdt;
J_from_dDdt = -integral_func(J_dDdt', P.Delta) / P.L;

J = zeros(num_iter,1); % Polarization current/current density (unit area)
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

