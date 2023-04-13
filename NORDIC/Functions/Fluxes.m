function [Gamma_close, Gamma_interfaces] = Fluxes(n, u, deltas, Vol, Diff, BC, options)
% Fluxes computes the outgoing fluxes for every cell/interface of the domain
% INPUT
% n -> matrix with two columns, the first containing the number density 
% for holes and the second for electrons
% u -> matrix with the velocity values at the interfaces
% deltas -> row vector containing the values of the spacing between the
% points of the domain
% Vol -> column vector containing the values of the volumes 
% Diff -> matrix containing the values of the diffusion coefficients
% BC -> 2x2 matrix containing the border conditions
% options -> options for the simulation
% OUTPUT
% Gamma_close -> column vector with the values of the flux outgoing from
% every cell (yet divided for the volume of the cells)
% Gamma_interfaces -> matrix with two column, the first containing the
% values of the flux at the interfaces for holes and the second for electrons
Gamma_interfaces = zeros(size(u));
Umax = max(0,u);
umin = min(0,u);
Grad_n = (n(2:end,:) - n(1:end-1,:)) ./ deltas(2:end-1)';
if ~ exist('options','var') || options.flux_scheme == "Upwind" 
    Gamma_interfaces(2:end-1,:) = -Diff(2:end-1,:).*Grad_n +... 
                                  n(1:end-1,:).*Umax(2:end-1,:) +... 
                                  n(2:end,:).*umin(2:end-1,:);
else
    error("Invalid value for options.flux_scheme")
end

% Assigning the border conditions
Gamma_interfaces(1,1) = BC(1,1); % West holes (usually 0)
Gamma_interfaces(1,2) = BC(1,2); % West electrons
Gamma_interfaces(end,1) = BC(end,1); % Est holes 
Gamma_interfaces(end,2) = BC(end,2); % Est electrons (usually 0)

Gamma_close = (Gamma_interfaces(2:end, :) - Gamma_interfaces(1:end-1, :)) ./ Vol;
Gamma_close = reshape(Gamma_close, [], 1);
end
