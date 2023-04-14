function [P] = CompleteFixedParameters(P)
% CompleteFixedParameters creates the Nordic parameters (all set to 1)
% INPUT
% P -> input structure
% OUTPUT
% P -> output structure
P.lambda_e = 1; 
P.lambda_h = 1; 
P.a_int = [1, 1]; 
P.w_hop = [1, 1]; 
P.a_sh = [1, 1]; 
P.w_tr_int = [1, 1];
P.N_int = [1, 1]; 
P.Pt = [1, 1]; 
P.w_tr_hop = [1, 1];
P.w_tr = [1, 1]; 
P.S_base = [1, 1, 1, 1];
P.Pr = 1; 
end

