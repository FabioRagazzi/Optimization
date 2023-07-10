function [EletStat] = CreateEletStat(geo, eps, options)
% CreateEletStat Summary of this function goes here
%   Detailed explanation goes here

S_over_dx = geo.S ./ geo.dx;

[EletStat.Kelet] = Assemble3Diag(S_over_dx(2:end-1), options);
EletStat.Kelet(1,1) = EletStat.Kelet(1,1) + S_over_dx(1) * (1 + geo.W);
EletStat.Kelet(1,2) = EletStat.Kelet(1,2) - S_over_dx(1) * geo.W^2 / (1 + geo.W);
EletStat.Kelet(end,end-1) = EletStat.Kelet(end,end-1) - S_over_dx(end) * geo.E^2 / (1 + geo.E); 
EletStat.Kelet(end,end) = EletStat.Kelet(end,end) + S_over_dx(end) * (1 + geo.E); 

EletStat.multRho = geo.V ./ eps;
EletStat.coeffW = S_over_dx(1) * (1 + 2*geo.W) / (1 + geo.W);
EletStat.coeffE = S_over_dx(end) * (1 + 2*geo.E) / (1 + geo.E);

end
