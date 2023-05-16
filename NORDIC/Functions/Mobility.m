function [mu_h, mu_e] = Mobility(E, ext_mult_sinh, arg_sinh, mu, options)
% Mobility computes the electric field dependent mobility 
% INPUT
% E -> matrix with all the electric field values calculated at the interfaces
% ext_mult_sinh -> 1x2 vector, first element referred to holes and second
% to electrons
% arg_sinh -> 1x2 vector, first element referred to holes and second
% to electrons
% mu -> 1x2 vector with the fixed(not depending on E) values of mobility
% OUTPUT
% mu_h -> matrix with the mobility values for holes (positive), same shape as input E
% mu_e -> matrix with the mobility values for electrons (positive), same shape as input E
if options.flagMu == false
    mu_h = mu(1) * ones(size(E));
    mu_e = mu(2) * ones(size(E));
elseif options.flagMu == true
    mu_h = ext_mult_sinh(1) * sinh(arg_sinh(1) * E) ./ E;
    mu_e = ext_mult_sinh(2) * sinh(arg_sinh(2) * E) ./ E;
else
    error("Invalid value for options.flagMu")
end
end

