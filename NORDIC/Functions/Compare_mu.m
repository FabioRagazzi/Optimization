function [mu_0] = Compare_mu(P)
% COMPARE_MU Function used to compare electric field dependent and
% independent mobilities
mu_0 = exp(-P.w_hop * P.e / P.kBT) .* P.a_int .* P.a_sh * P.e / P.h;
fprintf("The mobilities at low electric field (in the case they are field dependent) are: \n")
fprintf("μh = %.5e   μe = %.5e\n", mu_0(1), mu_0(2))
fprintf("The mobilities manually fixed (in the case they are field independent) are: \n")
fprintf("μh = %.5e   μe = %.5e\n", P.mu_h, P.mu_e)
end

