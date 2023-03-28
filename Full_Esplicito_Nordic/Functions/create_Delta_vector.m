function [Delta_vector] = create_Delta_vector(num_points, delta_const)
% CREATE_DELTA_VECTOR Creates a delta column vector 
Delta_vector = ones(num_points+1, 1);
Delta_vector = delta_const * Delta_vector;
Delta_vector([1, end]) = Delta_vector([1, end]) / 2;
end

