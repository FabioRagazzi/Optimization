function [Tstruct] = GetTstruct(time_instants, r, ri, ro, Tri, Tro)
% GetTstruct Summary of this function goes here
%   Detailed explanation goes here

% Here work with temperatures in °C, they will be converted to K after
Tstruct.matrix = ones(size(r,1), size(time_instants,2)) .* TemperatureDistribution(r, ri, ro, Tri, Tro);
i = find(time_instants/3600 >= 6, 1);
Tstruct.matrix(:,i:end) = 20; 
Tstruct.time = time_instants';

end
