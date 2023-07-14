function [P] = CompleteP(P)
% CompleteP updates P with the parameters depending on the ones that may
% have changed during a fit
% INPUT
% P -> input structure
% OUTPUT
% P -> output structure
P.aT2exp = P.a * (P.T^2) * [P.lambda_e, P.lambda_h] .* exp(-[P.phie, P.phih] * P.Boltz_num); 
P.ext_mult_sinh = 2 * P.v * P.a_int .* exp(-P.w_hop * P.Boltz_num);
P.arg_sinh = P.e * P.a_sh / (2 * P.kBT);
P.At = P.a_sh.^2;
P.mult_B = P.Pt .* P.Ndeep .* P.At;
P.B0 = P.v * P.Ndeep .* exp(-P.w_tr_int * P.Boltz_num) ./ P.N_int;
P.mult_D = 2 * P.v * exp(-P.w_tr_hop * P.Boltz_num);
P.add_D = P.v * exp(-P.w_tr * P.Boltz_num);
P.mult_S = P.Pr * P.e / P.eps;
% This part is needed only for fixed parameters (not depending on E)
P.Dh = P.v * exp(-P.wh * P.Boltz_num);
P.De = P.v * exp(-P.we * P.Boltz_num);
P.D_h = P.mu_h * P.kBT / P.e;
P.D_e = P.mu_e * P.kBT / P.e;
end

