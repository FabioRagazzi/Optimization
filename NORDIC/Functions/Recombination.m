function [S] = Recombination(mu_center, mult_S, S_base, s, options)
% Recombination computes the recombination coefficients
% INPUT
% mu_center -> matrix containing the values of the mobility at the
% center of the cells
% mult_S -> scalar containing the value of mult_S
% S_base -> 1x4 row vector containing the values of S_base
% s -> row vector with the fixed values of recombination coefficients
% options -> options for the simulation
% OUTPUT
% S -> matrix with the recombination coefficients
if ~ exist('options','var') || options.flagS == false
    S = s .* ones(size(mu_center(:,1)));
elseif options.flagS == true
    S = S_base + mu_center * [0, 0, 1, 1; 0, 1, 0, 1] * mult_S;
else
    error("Invalid value for options.flagS")
end
end

