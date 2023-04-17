function [cell_array, array_flags] = VectotToCellArray(vector, tags)
% VectotToCellArray converts the input vector to a cell array according
% to the tags and also provides array_flags
% INPUT
% tags -> array with the same dimension as vector with integer numbers (>0)
% used to pair vector elements 
% vector -> is an array containing scalar values
% OUTPUT
% cell_array -> contains the numbers that are going to be stored (scalar or array)
% array_flags -> is a logical array containing a 1 if the parameter is an
% array and 0 otherwise
if length(vector) == length(tags)
    dim = max(tags);
    cell_array = cell(1, dim);
    array_flags = false(1, dim);
    for i = 1:dim
        cell_array{i} = vector(tags==i);
        array_flags(i) = sum(tags==i) > 1;
    end
else
    error('The input vectors sizes are not the same')
end
end

