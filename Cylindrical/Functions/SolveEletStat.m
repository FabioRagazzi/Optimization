function [phi] = SolveEletStat(EletStat, rho, PhiW, PhiE)
% SolveEletStat Summary of this function goes here
%   Detailed explanation goes here

rho = rho .* EletStat.multRho;
rho(1,:) = rho(1,:) + EletStat.coeffW * PhiW;
rho(end,:) = rho(end,:) + EletStat.coeffE * PhiE;
phi = EletStat.Kelet\rho;

end
