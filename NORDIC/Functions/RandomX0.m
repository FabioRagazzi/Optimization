function [x0] = RandomX0(lb, ub)
% RandomX0 returns a random starting point for TRRA
% INPUT
% lb -> array containing the lower bounds
% ub -> array containing the upper bounds
% OUTPUT
% x0 -> array containing a random starting point
if length(lb) == length(ub)
    x0 = lb + rand(1, length(lb)) .* (ub - lb);
else
    error("The dimension of the bounds are not equal in 'RandomX0'")
end
end

