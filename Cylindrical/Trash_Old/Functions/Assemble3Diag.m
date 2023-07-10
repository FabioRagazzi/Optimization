function [M] = Assemble3Diag(v, options)
% Assemble3Diag Assembles a 3 diagonal matrix given a vector
% INPUT
% v -> input vector
% options -> input structure with fields:
%   type -> the type of matrix {'sparse','normal'}, default is 'normal'
% OUTPUT
% M -> output matrix
arguments
    v (1,:) {mustBeNumeric}
    options.type char {mustBeMember(options.type,{'sparse','normal'})} = 'normal'
end
np = length(v) + 1;
%   left    central   right
I = [2:np,   1:np,  1:np-1];
J = [1:np-1, 1:np,  2:np];
S = [-v, [v,0] + [0,v], -v];
if options.type == "sparse"
    M = sparse(I, J, S);
elseif options.type == "normal"
    M = zeros(np);
    M(sub2ind([np, np], I, J)) = S;
end
end
