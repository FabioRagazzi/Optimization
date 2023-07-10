function [M] = Assemble3Diag(v, options)
% Assemble3Diag Summary of this function goes here
%   Detailed explanation goes here

np = size(v,1) + 1;
v_central = zeros(np, 1);
v_central(1:end-1) = v;
v_central(2:end) = v_central(2:end) + v;

%   left    central   right
I = [2:np,   1:np,  1:np-1];
J = [1:np-1, 1:np,  2:np];
S = [-v; v_central; -v];

if options.type == "sparse"
    M = sparse(I, J, S);
elseif options.type == "normal"
    M = zeros(np);
    M(sub2ind([np, np], I, J)) = S;
end

end
