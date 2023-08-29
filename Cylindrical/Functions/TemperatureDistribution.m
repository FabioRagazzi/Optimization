function [Tr] = TemperatureDistribution(r, ri, ro, Tri, Tro)
% TemperatureDistribution Summary of this function goes here
%   Detailed explanation goes here
% r = (npx1)
% ri = (1x1)
% ro = (1x1)
% Tri = (1 x nt)
% Tro = (1 x nt)
% Tr = (np x nt)

Tr = Tri - (log(r/ri).*(Tri-Tro))./(log(ro/ri));

end

% ri = 5;
% ro = 20;
% r = linspace(ri,ro)';
% Tri = ones(1,45) * 70;
% Tro = ones(1,45) * 55;
% Tr = TemperatureDistribution(r, ri, ro, Tri, Tro);
