function [eq1, eq2, eq3, eq4] = omega_source(n, nt, B, D, S0, S1, S2, S3, Nt, U)
%OMEGA_SOURCE Summary of this function goes here
%   Detailed explanation goes here
eq1 = -B * n * (1 - nt / Nt) + D * nt - S2 * n * nt - S3 * n^2 + U;
eq2 = -B * n * (1 - nt / Nt) + D * nt - S1 * n * nt - S3 * n^2 + U;
eq3 = +B * n * (1 - nt / Nt) - D * nt - S0 * nt^2 - S1 * n * nt;
eq4 = +B * n * (1 - nt / Nt) - D * nt - S0 * nt^2 - S2 * n * nt;
end

