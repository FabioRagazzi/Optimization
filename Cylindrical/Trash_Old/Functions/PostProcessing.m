function [nh, ne, nht, net, rho, phi, E, J_Sato, J_dDdt] = PostProcessing(nout, tout, P, options)
%POSTPROCESSING Summary of this function goes here
%   Detailed explanation goes here
nt = length(tout);
nh = zeros(P.np, nt);
ne = zeros(P.np, nt);
nht = zeros(P.np, nt);
net = zeros(P.np, nt);
rho = zeros(P.np, nt);
phi = zeros(P.np, nt);
J_Sato = zeros(1, nt);
J_dDdt = zeros(1, nt);
E = zeros(P.np+1, nt);
end
