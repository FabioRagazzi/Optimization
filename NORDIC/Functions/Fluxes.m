function [Gamma_close, Gamma_interfaces, den_for_stab] = Fluxes(n, u, deltas, Vol, Diff, BC, options)
% Fluxes computes the outgoing fluxes for every cell/interface of the domain
% INPUT
% n -> matrix with two columns, the first containing the number density 
% for holes and the second for electrons
% u -> matrix with the velocity values at the interfaces
% deltas -> row vector containing the values of the spacing between the
% points of the domain
% Vol -> column vector containing the values of the volumes 
% Diff -> matrix containing the values of the diffusion coefficients
% BC -> 2x2 matrix containing the border conditions (emitted values)
% options -> options for the simulation
% OUTPUT
% Gamma_close -> column vector with the values of the flux outgoing from
% every cell (yet divided for the volume of the cells)
% Gamma_interfaces -> matrix with two column, the first containing the
% values of the flux at the interfaces for holes and the second for electrons
% den_for_stab -> npx2 matrix useful to compute the time step dt in an explicit
% solver

% initializing variables
Gamma_interfaces = zeros(size(u));
den_for_stab = zeros(size(n));

Upos = u > 0;
uneg = ~Upos;
Umax = u.*Upos;
umin = u.*uneg;
Grad_n = (n(2:end,:) - n(1:end-1,:)) ./ deltas(2:end-1)';
if options.flux_scheme == "Upwind" 
    Gamma_interfaces(2:end,:) = Gamma_interfaces(2:end,:) + n.*Umax(2:end,:);
    Gamma_interfaces(1:end-1,:) = Gamma_interfaces(1:end-1,:) + n.*umin(1:end-1,:);
    Gamma_interfaces(2:end-1,:) = Gamma_interfaces(2:end-1,:) -Diff(2:end-1,:).*Grad_n;
    den_for_stab = Diff(1:end-1,:)./ deltas(1:end-1)' + Diff(2:end,:)./ deltas(2:end)' +...
                   Umax(2:end,:) - umin(1:end-1,:);
    den_for_stab = den_for_stab ./ Vol;

elseif options.flux_scheme == "Koren"
    n_modified = [zeros(1,2); n; zeros(1,2)];
    DeltaN = n_modified(2:end,:) - n_modified(1:end-1,:);
    DeltaN_to_koren = Upos(2:end-1,:).*DeltaN(1:end-2,:) + uneg(2:end-1,:).*DeltaN(3:end,:);
    koren_computed = KorenMlim(DeltaN(2:end-1,:), DeltaN_to_koren);
    Gamma_interfaces(2:end-1,:) = -Diff(2:end-1,:).*Grad_n +...
                                   Umax(2:end-1,:).*(n_modified(2:end-2,:) + koren_computed) +...
                                   umin(2:end-1,:).*(n_modified(3:end-1,:) - koren_computed);
    Gamma_interfaces(1,:) = n(1,:) .* umin(1,:);
    Gamma_interfaces(end,:) = n(end,:) .* Umax(end,:);
else
    error("Invalid value for options.flux_scheme")
end

% Assigning the border conditions
Gamma_interfaces(1,1) = BC(1,1); % West holes (usually 0)
Gamma_interfaces(1,2) = BC(1,2); % West electrons
Gamma_interfaces(end,1) = -BC(end,1); % Est holes 
Gamma_interfaces(end,2) = -BC(end,2); % Est electrons (usually 0)

Gamma_close = (Gamma_interfaces(2:end, :) - Gamma_interfaces(1:end-1, :)) ./ Vol;
Gamma_close = reshape(Gamma_close, [], 1);
end
