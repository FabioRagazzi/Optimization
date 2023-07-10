function [EletStat] = CreateEletStat(geometry, eps, options)
% CreateEletStat Summary of this function goes here
%   Detailed explanation goes here
if options.geometry == "cartesian"
    S = ones(size(geometry.x_int));
    Vol = geometry.dx_int;
elseif options.geometry == "cylindrical"
    S = geometry.x_int;
    Vol = geometry.dx_int .* geometry.x;
end
S_over_dx = S ./ geometry.dx;
W = geometry.dx(1) / geometry.dx(2);
E = geometry.dx(end) / geometry.dx(end-1);
[EletStat.Kelet] = Assemble3Diag(S_over_dx(2:end-1), 'type',options.type);
EletStat.Kelet(1,1) = EletStat.Kelet(1,1) + S_over_dx(1) * (1 + W);
EletStat.Kelet(1,2) = EletStat.Kelet(1,2) - S_over_dx(1) * W^2 / (1 + W);
EletStat.Kelet(end,end-1) = EletStat.Kelet(end,end-1) - S_over_dx(end) * E^2 / (1 + E); 
EletStat.Kelet(end,end) = EletStat.Kelet(end,end) + S_over_dx(end) * (1 + E); 
EletStat.multRho = Vol ./ eps;
EletStat.coeffW = S_over_dx(1) * (1 + 2*W) / (1 + W);
EletStat.coeffE = S_over_dx(end) * (1 + 2*E) / (1 + E);
end
