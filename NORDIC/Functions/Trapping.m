function [B] = Trapping(u_center, B0, mult_B, b, options)
% Trapping computes the trapping coefficients 
% INPUT
% u_center -> matrix containing the velocity at the center of the cells for
% holes (first column) and electrons (second column)
% B0 -> npx2 matrix containing the values of B0
% mult_B -> npx2 matrix containing the values of mult_B
% b -> row vector with the fixed values of trapping coefficients
% options -> options for the simulation
% OUTPUT
% B -> matrix with the trapping coefficients
if ~ exist('options', 'var') || options.flagB == false
    B = b .* ones(size(u_center(:,1)));
elseif options.flagB == true
    B = B0 + mult_B .* u_center;
else
    error("Invalid value for options.flagB")
end
end
