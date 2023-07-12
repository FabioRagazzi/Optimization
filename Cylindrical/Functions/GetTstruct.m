function [Tstruct] = GetTstruct(time_instants, r, ri, ro, Tri, Tro)
% GetTstruct Summary of this function goes here
%   Detailed explanation goes here

Tstruct.matrix = ones(size(r,1), size(time_instants,2)) .* TemperatureDistribution(r, ri, ro, Tri, Tro);
Tstruct.time = time_instants';

end
