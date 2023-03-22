function [mu_h, mu_e] = Mobility(E, ext_mult_sinh, arg_sinh)
% MOBILITY Computes the electric field dependent mobility 
% E is a matrix with all the electric field values calculated at the
% interfaces. ext_mult_sinh and arg_sinh are vectors with two
% elements, the first referred to h and the second to e
mu_h = ext_mult_sinh(1) * sinh(arg_sinh(1) * E) ./ E;
mu_e = ext_mult_sinh(2) * sinh(arg_sinh(2) * E) ./ E;
end

