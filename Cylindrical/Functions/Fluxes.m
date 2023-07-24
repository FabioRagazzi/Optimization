function [Gamma_interfaces, Gamma_close] = Fluxes(n, u, D, geo, Inj_h, Inj_e)
% Fluxes Summary of this function goes here
%   Detailed explanation goes here

% Initializing Gamma_interfaces
Gamma_interfaces = zeros(size(u));

Upos = u > 0;
uneg = ~Upos;
Umax = u.*Upos;
umin = u.*uneg;
Grad_n = (n(2:end,:) - n(1:end-1,:)) ./ geo.dx(2:end-1);
Gamma_interfaces(2:end,:) = Gamma_interfaces(2:end,:) + n.*Umax(2:end,:);
Gamma_interfaces(1:end-1,:) = Gamma_interfaces(1:end-1,:) + n.*umin(1:end-1,:);
Gamma_interfaces(2:end-1,:) = Gamma_interfaces(2:end-1,:) - D(2:end-1,:).*Grad_n;% + n(1:end-1,:).*Umax(2:end-1,:) + n(2:end,:).*umin(2:end-1,:);

% Assigning the border conditions for charge injection
Gamma_interfaces(1,1) = Inj_h; % West holes
Gamma_interfaces(end,2) = -Inj_e; % Est electrons

Gamma_interfaces = Gamma_interfaces .* geo.S;
Gamma_close = (Gamma_interfaces(2:end, :) - Gamma_interfaces(1:end-1, :)) ./ geo.V;

Gamma_close = reshape(Gamma_close, [], 1);

end
