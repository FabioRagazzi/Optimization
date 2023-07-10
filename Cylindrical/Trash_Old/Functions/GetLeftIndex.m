function [i_left] = GetLeftIndex(array, val, dim)
% GetLeftIndex Summary of this function goes here
%   Detailed explanation goes here
if val <= array(1)
    i_left = 1;
else
    for i = 1:dim
        if array(i) > val
            break
        end
    end
    i_left = i - 1;
end
end
