function [D] = Detrapping(E_center, mult_D, arg_sinh, add_D, d, options)
% Detrapping computes the detrapping coefficients
% INPUT
% E_center -> matrix containing the values of the electric field at the
% center of the cells
% mult_D -> 1x2 row vector containing the values of mult_D
% arg_sinh -> 1x2 row vector containing the values of arg_sinh
% add_D -> 1x2 row vector containing the values of add_D
% d -> row vector with the fixed values of detrapping coefficients
% options -> options for the simulation
% OUTPUT
% D -> matrix with the detrapping coefficients
if ~ exist('options','var') || options.flagD == false
    D = d .* ones(size(E_center));
elseif options.flagD == true
    D = mult_D .* sinh(abs(E_center) .* arg_sinh) + add_D;
else
    error("Invalid value for options.flagD")
end
end

