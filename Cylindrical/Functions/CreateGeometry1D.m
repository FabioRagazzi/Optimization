function [geo] = CreateGeometry1D(x0, dx, options)
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

geo.x = x + x0;
geo.dx = dx;
geo.L = x_int(end);
geo.x_int = x_int + x0;
geo.dx_int = dx_int;

if options.coordinates == "cartesian"
    geo.V = geo.dx_int;
    geo.S = ones(np+1, 1);
elseif options.coordinates == "cylindrical"
    geo.V = geo.dx_int .* geo.x;
    geo.S = geo.x_int;
end

geo.x0 = x0;
geo.np = np;
geo.W = geo.dx(1) / geo.dx(2);
geo.E = geo.dx(end) / geo.dx(end-1);

end
