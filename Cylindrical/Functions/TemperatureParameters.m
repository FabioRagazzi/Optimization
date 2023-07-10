function [P] = TemperatureParameters(P, T_int, T)
% TemperatureParameters Summary of this function goes here
%   Detailed explanation goes here

P.kBT_int = P.kB * T_int;
P.kBT = P.kB * T;
P.v_int = P.kBT_int / P.h;
P.v = P.kBT / P.h;
P.Boltz_num_int = P.e ./ P.kBT_int;
P.Boltz_num = P.e ./ P.kBT;

P.aT2exp = P.a * T_int([1,end]).^2 .* [P.lambda_e; P.lambda_h] .* exp(-[P.phie; P.phih] .* P.Boltz_num_int([1,end])); 

P.ext_mult_sinh = 2 * P.v_int * P.a_int .* exp(-P.w_hop .* P.Boltz_num_int);
P.arg_sinh = P.e * P.a_sh ./ (2 * P.kBT_int);

P.B0 = P.v .* P.Ndeep .* exp(-P.w_tr_int .* P.Boltz_num) ./ P.N_int;
P.mult_D = 2 * P.v .* exp(-P.w_tr_hop .* P.Boltz_num);
P.add_D = P.v .* exp(-P.w_tr .* P.Boltz_num);

end
