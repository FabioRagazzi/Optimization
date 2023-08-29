function [P] = BasselParameters(P)
% BasselParameters Summary of this function goes here
%   Detailed explanation goes here
P.eps_r = 2.3;
P.Phi_W = 320e3;
P.Phi_E = 0;
P.phih = 1.27;
P.phie = 1.3;
P.n_start = [1, 1, 1, 1] * 1e-300;
P.Ndeep = ones(P.geo.np, 2) .* [6.2415e+20, 6.2415e+20]; 
P.lambda_e = 1;
P.lambda_h = 1; 
P.a_int = [3 3] * 1e-9;
P.w_hop = [0.65, 0.71]; 
P.a_sh = [3 3] * 1e-9; 
P.w_tr = [0.99, 0.96];
P.S_base = [0, 1.6022e-23, 1.6022e-23, 1.6022e-23];
P.Pr = 1;

% Unused parameters
P.w_tr_int = [1, 1]; P.N_int = [1, 1]; P.Pt = [1, 1]; P.w_tr_hop = [1, 1];

end
