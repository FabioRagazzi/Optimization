function [I] = integral_func(f, Delta)
%INTEGRAL Integrates f assuming the points are equally spaced (Delta)
% f = row vector or matrix of row vectors containing the values of the function
% Delta = spacing between the points where f is evaluated
I = sum( f(:,1:end-1)+f(:,2:end), 2 ) * Delta * 0.5;
end

