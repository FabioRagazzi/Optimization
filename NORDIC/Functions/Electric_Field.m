function [E] = Electric_Field(phi, Delta, Phi_W, Phi_E)
% ELECTRIC_FIELD Calculates electric field with II order precision
% phi = column vector or matrix formed by column vectors
% Delta = spacing between the poits in the domain (constant value)
% Phi_W, Phi_E = fixed electric potentials at the domain extremes
dim = size(phi);
E = zeros(dim(1)+1, dim(2));
E(2:end-1,:) = (-phi(2:end,:) + phi(1:end-1,:)) / Delta;
E(1,:) = (8*Phi_W + phi(2,:) - 9*phi(1,:)) / (3*Delta);
E(end,:) = (-8*Phi_E - phi(end-1,:) + 9*phi(end,:)) / (3*Delta);
end
