function [E] = ComputeE(geo, phi, PhiW, PhiE)
% ComputeE Summary of this function goes here
%   Detailed explanation goes here

E = zeros(geo.np+1, size(phi,2));
E(2:end-1,:) = -(phi(2:end,:) - phi(1:end-1,:)) ./ geo.dx(2:end-1);
E(1,:) = (-(geo.W + 1) * phi(1,:) + (geo.W^2 / (geo.W + 1)) * phi(2,:) + ((1 + 2*geo.W)/(1 + geo.W)) * PhiW) / geo.dx(1);
E(end, :) = ((geo.E + 1) * phi(end,:) - (geo.E^2 / (geo.E + 1)) * phi(end-1,:) - ((1 + 2*geo.E)/(1 + geo.E)) * PhiE) / geo.dx(end);

end
