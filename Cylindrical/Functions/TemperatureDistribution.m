function [Tr] = TemperatureDistribution(r, ri, ro, Tri, Tro)
% TemperatureDistribution Summary of this function goes here
%   Detailed explanation goes here

Tr = Tri - (log(r/ri)*(Tri-Tro))/(log(ro/ri));

end
