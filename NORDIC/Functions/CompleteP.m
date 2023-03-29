function [P] = CompleteP(P)
% COMPLETEP Completes P with the derived parameters

% Physics constants
P.h = 6.62607015e-34;
P.e = 1.602176634e-19;
P.kB = 1.380649e-23;
P.eps0 = 8.854187817e-12;
P.abs0 = 273.15;
P.A = 1.20173e6;

% Derived parameters
P.a = P.A / P.e;
P.Delta = P.L / P.num_points;
P.T = P.T + P.abs0;
P.kBT = P.kB * P.T;
P.eps = P.eps_r * P.eps0;
P.beta = sqrt((P.e^3)/(4*pi*P.eps));
P.coeff =  8 * P.eps / (3 * P.Delta^2);
P.aT2exp = P.a * (P.T^2) * [P.lambda_e, P.lambda_h] .* exp(-[P.phie, P.phih] * P.e / P.kBT); 
P.S_base = P.S_base * P.e;
P.Kelet = Kelectrostatic_sparse(P.num_points, P.Delta, P.eps);
P.v = P.kBT / P.h;
P.ext_mult_sinh = 2 * P.v * P.a_int .* exp(-P.w_hop * P.e / P.kBT);
P.arg_sinh = P.e * P.a_sh / (2 * P.kBT);
P.At = P.a_sh.^2;
P.mult_B = P.Pt .* P.N_deep .* P.At;
P.B0 = P.v * P.N_deep .* exp(-P.e * P.w_tr_int / P.kBT) ./ P.N_int;
P.mult_D = 2 * P.v * exp(-P.e * P.w_tr_hop / P.kBT);
P.add_D = P.v * exp(-P.e * P.w_tr / P.kBT);
P.mult_S = P.Pr * P.e / P.eps;

% This part is needed only for fixed parameters (not depending on E)
P.D_h = P.mu_h * P.kBT / P.e;
P.D_e = P.mu_e * P.kBT / P.e;
P.S0 = P.S0 * P.e;
P.S1 = P.S1 * P.e;
P.S2 = P.S2 * P.e;
P.S3 = P.S3 * P.e;

end

