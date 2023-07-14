function [P] = DerivedParameters(P)
% DerivedParameters updates P with the parameters that depend on the input
% of the simulation but need to be calculated only one time
% INPUT
% P -> parameter structure
% OUTPUT
% P -> parameter structure with derived paramters
P.a = P.A / P.e;
P.deltas = CreateDeltas(P.LW, P.LE, P.nW, P.nE, P.num_points, P.L);
[P.x, P.x_int, P.x_face] = CreateX(P.deltas);
P.delta_x_face = P.x_face(2:end) - P.x_face(1:end-1);
P.Vol = CreateVol(P.deltas);
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.beta = sqrt((P.e^3)/(4*pi*P.eps));
P.EletStat = EletStat1D(P.deltas, P.eps, "sparse");
P.v = P.kBT / P.h;
P.Boltz_num = P.e / P.kBT;
% ALL THE PARAMETERS THAT APPEAR IN THIS FUNCTION CAN NOT BE USED FOR A FIT!!
end
