function [nh, ne, nht, net, rho, phi, E, J] = post_processing(nout, tout, P)
% POST_PROCESSING
% nout -> matrix with each line containing the number density at a time instant
% tout -> column vector with the time instants considered
% P -> struct containing all the parameters of the simulation
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

J = zeros(num_iter,1); % Polarization current/current density (unit area)
for k = 1:num_iter
    n_k = reshape(nout(k,:),[P.num_points,4]);
    u_k = E(:,k) .* [P.mu_h, -P.mu_e];
    [~, Gamma_interfaces] = Fluxes(n_k(:,1:2), P.num_points, u_k, P.Delta, P.D_h, P.D_e, E(1,k), E(end,k), P.aT2exp, P.kBT, P.beta);
    f = sum(Gamma_interfaces.*[1,-1], 2);
    J(k) = -integral_func(f',P.Delta) * P.e / P.L;
end

end

