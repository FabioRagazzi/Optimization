function [P] = DerivedParameters(P, options)
% DerivedParameters Summary of this function goes here
%   Detailed explanation goes here

P.h = 6.62607015e-34;
P.e = 1.602176634e-19;
P.kB = 1.380649e-23;
P.eps0 = 8.854187817e-12;
P.abs0 = 273.15;
P.A = 1.20173e6;

P.a = P.A / P.e;
% P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.EletStat = CreateEletStat(P.geo, P.eps, options);
P.beta = sqrt((P.e^3)/(4*pi*P.eps));
% P.v = P.kBT / P.h;
% P.Boltz_num = P.e / P.kBT;

% P.aT2exp = P.a * (P.T^2) * [P.lambda_e, P.lambda_h] .* exp(-[P.phie, P.phih] * P.Boltz_num); 
% P.ext_mult_sinh = 2 * P.v * P.a_int .* exp(-P.w_hop * P.Boltz_num);
% P.arg_sinh = P.e * P.a_sh / (2 * P.kBT);
P.At = P.a_sh.^2;
P.mult_B = P.Pt .* P.Ndeep .* P.At;
% P.B0 = P.v * P.Ndeep .* exp(-P.w_tr_int * P.Boltz_num) ./ P.N_int;
% P.mult_D = 2 * P.v * exp(-P.w_tr_hop * P.Boltz_num);
% P.add_D = P.v * exp(-P.w_tr * P.Boltz_num);
P.mult_S = P.Pr * P.e / P.eps;

end
