function [geometry] = CreateGeometry1D(x0, dx)
% CreateGeometry1D Summary of this function goes here
%   Detailed explanation goes here

np = length(dx) - 1;
x = zeros(np, 1);
dx_int = zeros(np, 1);
x_int = zeros(np+1, 1);

x(1) = dx(1);
for i = 2:np
    x(i) = x(i-1) + dx(i);
end

x_int(2:end-1) = (x(1:end-1) + x(2:end)) / 2;
x_int(1) = 0;
x_int(end) = x(end) + dx(end);

dx_int(2:end-1) = (dx(2:end-2) + dx(3:end-1)) / 2;
dx_int(1) = dx(1) + dx(2) / 2;
dx_int(end) = dx(end) + dx(end-1) / 2;

geometry.x = x + x0;
geometry.dx = dx;
geometry.x_int = x_int + x0;
geometry.dx_int = dx_int;

end
