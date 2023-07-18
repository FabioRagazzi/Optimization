function [P] = CompleteNordicParameters(P)
% CompleteNordicParameters creates the classic parameters (all set to 1)
% INPUT
% P -> input structure
% OUTPUT
% P -> output structure
P.mu_h = 1;
P.mu_e = 1;
P.Bh = 1;
P.Be = 1;
P.Dh = 1;
P.De = 1;
P.S0 = 1;
P.S1 = 1;
P.S2 = 1;
P.S3 = 1;
P.wh = 1;
P.we = 1;

end
