function [Gamma_interfaces, Gamma_close] = Fluxes(n, u, D, x, x_int, dx, dx_int, Inj_h, Inj_e, options)
% Fluxes Summary of this function goes here
%   Detailed explanation goes here
arguments
    n
    u
    D
    x (:,1)
    x_int (:,1)
    dx (:,1)
    dx_int (:,1)
    Inj_h (1,1)
    Inj_e (1,1)
    options.flux_scheme char {mustBeMember(options.flux_scheme,{'upwind','koren'})} = 'upwind';
    options.geometry char {mustBeMember(options.geometry,{'cartesian','cylindrical'})} = 'cartesian';
    options.electrodes char {mustBeMember(options.electrodes,{'block','free'})} = 'block';
end

% Initializing Gamma_interfaces
Gamma_interfaces = zeros(size(u));

Upos = u > 0;
uneg = ~Upos;
Umax = u.*Upos;
umin = u.*uneg;
Grad_n = (n(2:end,:) - n(1:end-1,:)) ./ dx(2:end-1);
if options.flux_scheme == "upwind" 
    Gamma_interfaces(2:end-1,:) = -D(2:end-1,:).*Grad_n +... 
                                  n(1:end-1,:).*Umax(2:end-1,:) +... 
                                  n(2:end,:).*umin(2:end-1,:);
elseif options.flux_scheme == "koren"
    n_modified = [zeros(1,2); n; zeros(1,2)];
    DeltaN = n_modified(2:end,:) - n_modified(1:end-1,:);
    DeltaN_to_koren = Upos(2:end-1,:).*DeltaN(1:end-2,:) + uneg(2:end-1,:).*DeltaN(3:end,:);
    koren_computed = KorenMlim(DeltaN(2:end-1,:), DeltaN_to_koren);
    Gamma_interfaces(2:end-1,:) = -D(2:end-1,:).*Grad_n +...
                                   Umax(2:end-1,:).*(n_modified(2:end-2,:) + koren_computed) +...
                                   umin(2:end-1,:).*(n_modified(3:end-1,:) - koren_computed);
end

% Assigning the border conditions for charge injection
Gamma_interfaces(1,2) = Inj_e; % West electrons
Gamma_interfaces(end,1) = -Inj_h; % Est holes 

if options.electrodes == "block"
    Gamma_interfaces(1,1) = 0;
    Gamma_interfaces(end,2) = 0;
elseif options.electrodes == "free"
    Gamma_interfaces(1,1) = -n(1,1) * u(1,1);
    Gamma_interfaces(end,2) = n(end,2) * u(end,2);
end

if options.geometry == "cartesian"
    Gamma_close = (Gamma_interfaces(2:end, :) - Gamma_interfaces(1:end-1, :)) ./ dx_int;
elseif options.geometry == "cylindrical"
    Gamma_interfaces = Gamma_interfaces .* x_int;
    Gamma_close = (Gamma_interfaces(2:end, :) - Gamma_interfaces(1:end-1, :)) ./ (x .* dx_int);
end

Gamma_close = reshape(Gamma_close, [], 1);
end
