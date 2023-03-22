function [Kelet] = Kelectrostatic(num_points, Delta, eps)
% KELECTROSTATIC Creates the electrostatic matrix
% num_points = number of cells in the domain
% Delta = spacing between the domain points (constant vaue)
% eps_r = relative permettivity of the material
Kelet = zeros(num_points);
Kelet(sub2ind([num_points, num_points], 1:num_points, 1:num_points)) = 2;
Kelet(sub2ind([num_points, num_points], 1:num_points-1, 2:num_points)) = -1;
Kelet(sub2ind([num_points, num_points], 2:num_points, 1:num_points-1)) = -1;
Kelet(1,1) = 4;
Kelet(1,2) = -4/3;
Kelet(end,end) = 4;
Kelet(end,end-1) = -4/3;
Kelet = Kelet * (eps / Delta^2);
end

