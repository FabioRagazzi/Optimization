function [phi] = Electrostatic(rho, coeff, Phi_W, Phi_E, Kelet)
% ELECTROSTATIC
rho(1,:) = rho(1,:) + coeff * Phi_W;
rho(end,:) = rho(end,:) + coeff * Phi_E;
phi = Kelet\rho;
end
