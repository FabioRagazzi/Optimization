function [Gamma_close, Gamma_interfaces] = Fluxes(n, num_points, u, deltas, Vol, D_h, D_e, E1, Eend, aT2exp, kBT, beta)
% FLUXES Computes the outgoing fluxes for every cell of the domain
Gamma_interfaces = zeros(num_points+1, 2);
Umax = max(0,u);
umin = min(0,u);
Grad_n = (n(2:end,:) - n(1:end-1,:)) ./ deltas(2:end-1)';
Gamma_interfaces(2:end-1,:) = -[D_h, D_e].*Grad_n +... 
                              n(1:end-1,:).*Umax(2:end-1,:) +... 
                              n(2:end,:).*umin(2:end-1,:);
Gamma_interfaces(end,1) = -Schottky(Eend, aT2exp(end), kBT, beta);
Gamma_interfaces(1,2) = Schottky(E1, aT2exp(1), kBT, beta);
Gamma_close = Gamma_interfaces(2:end, :) - Gamma_interfaces(1:end-1, :);
Gamma_close = Gamma_close ./ Vol;
Gamma_close = reshape(Gamma_close, [2*num_points, 1]);
end
