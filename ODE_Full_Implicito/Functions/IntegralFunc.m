function [I] = IntegralFunc(f, deltas)
% IntegralFunc Integrates f over a domain with points spaced by deltas 
% f -> row vector or matrix of row vectors containing the values of the function
% deltas -> row vector containing the spacing between the points where f is evaluated
I = sum((f(:,1:end-1) + f(:,2:end)) .* deltas,   2) / 2;
end

