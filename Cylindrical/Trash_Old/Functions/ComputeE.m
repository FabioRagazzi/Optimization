function [E] = ComputeE(phi, PhiW, PhiE, dx)
% ComputeE Function to calculate the electric field
E = -(phi(2:end,:) - phi(1:end-1,:)) ./ dx(2:end-1);
rW = dx(2) / dx(1);
rE = dx(end-1) / dx(end);
EW = (-phi(1,:) * (rW+1)^2 + (rW+2) * rW * PhiW + phi(2,:)) / (rW * (rW + 1) * dx(1));
EE = (phi(end,:) * (rE+1)^2 - (rE+2) * rE * PhiE - phi(end-1,:)) / (rE * (rE + 1) * dx(end));
E = [EW; E; EE];
end
