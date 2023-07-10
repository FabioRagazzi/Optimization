function [I] = IntegralFunc(f, dx)
% IntegralFunc integrates f over a domain with points spaced by deltas 
% INPUT
% f -> row vector(1xn) or matrix of row vectors containing the values of the function
% dx -> row vector(1xn-1) containing the spacing between the points where f is evaluated
% OUTPUT
% I -> column vector containing the value of the integral
I = sum((f(:,1:end-1) + f(:,2:end)) .* dx,   2) / 2;
end

