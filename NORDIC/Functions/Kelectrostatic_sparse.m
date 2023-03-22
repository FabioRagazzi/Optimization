function [Kelet] = Kelectrostatic_sparse(num_points, Delta, eps)
% KELECTROSTATIC Creates the electrostatic matrix
% num_points = number of cells in the domain
% Delta = spacing between the domain points (constant vaue)
% eps_r = relative permettivity of the material
I = [1:num_points, 1:num_points-1, 2:num_points];
J = [1:num_points, 2:num_points, 1:num_points-1];
v = [ 2*ones(1,num_points), -ones(1,num_points-1), -ones(1,num_points-1)];
Kelet = sparse(I, J, v);
Kelet(1,1) = 4;
Kelet(1,2) = -4/3;
Kelet(end,end) = 4;
Kelet(end,end-1) = -4/3;
Kelet = Kelet * (eps / Delta^2);
end

