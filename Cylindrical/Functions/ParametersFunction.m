function [P] = ParametersFunction(parameters, options)
% ParametersFunction Summary of this function goes here
%   Detailed explanation goes here

switch parameters
    case "DOEDENS"
        P.geo = CreateGeometry1D(0.1, CreateDeltas(0, 0, 0, 0, 100, 3.5e-4), options);
        P.Tstruct = GetTstruct();
        P.eps_r = 2;
        P.Phi_W = 0;
        P.Phi_E = P.geo.L * 3e7;
        P.phih = 1.148;
        P.phie = 0.905;
        P.n_start = [1e20, 1e20, 1e1, 1e1];
        P.Ndeep = ones(P.geo.np, 2) .* [5.9293e20, 2.4966e20]; 
        P.lambda_e = 4.1e-5;
        P.lambda_h = 1e-1; 
        P.a_int = [100 80] * 1e-9; 
        P.w_hop = [0.74, 0.76]; 
        P.a_sh = [1.25 2.25] * 1e-9; 
        P.w_tr_int = [0.79, 0.81]; 
        P.N_int = [1e23, 1e23]; 
        P.Pt = [1, 1];
        P.w_tr_hop = [1, 1];
        P.w_tr = [1.03, 1.03];
        P.S_base = [1.6022e-23, 1.6022e-23, 1.6022e-23, 1.6022e-23];
        P.Pr = 1;
    case "TEST_CYLINDRICAL"
        P.geo = CreateGeometry1D(0.1, CreateDeltas(0, 0, 0, 0, 100, 3.5e-4), options);
        P.Tstruct = GetTstruct();
        P.eps_r = 2;
        P.Phi_W = 0;
        P.Phi_E = P.geo.L * 3e7;
        P.phih = 1e100;
        P.phie = 1e100;
        P.n_start = [1e0, 1e0, 10, 10];
        P.Ndeep = ones(P.geo.np, 2) .* [5.9293e20, 2.4966e20]; 
        P.lambda_e = 4.1e-5;
        P.lambda_h = 1e-1; 
        P.a_int = [100 80] * 1e-9; 
        P.w_hop = [0.74, 0.76]; 
        P.a_sh = [1.25 2.25] * 1e-9; 
        P.w_tr_int = [0.79, 0.81]; 
        P.N_int = [1e23, 1e23]; 
        P.Pt = [1, 1];
        P.w_tr_hop = [1, 1];
        P.w_tr = [1.03, 1.03];
        P.S_base = [1.6022e-23, 1.6022e-23, 1.6022e-23, 1.6022e-23];
        P.Pr = 1;
    case "C"
        P.L = 3.5e-4;
        P.num_points = 100;
        P.LW = 0;
        P.LE = 0;
        P.nW = 0;
        P.nE = 0;
        P.T = 333.15;
        P.eps_r = 2;
        P.Phi_W = 0;
        P.Phi_E = P.L * 3e7;
        P.phih = 1.148;
        P.phie = 0.905;
        P.n_start = [1e20, 1e20, 1e1, 1e1];
        P.Ndeep = ones(P.num_points,2) .* [5.9293e20, 2.4966e20]; 
        P.lambda_e = 4.1e-5;
        P.lambda_h = 1e-1; 
        P.a_int = [100 80] * 1e-9; 
        P.w_hop = [0.74, 0.76]; 
        P.a_sh = [1.25 2.25] * 1e-9; 
        P.w_tr_int = [0.79, 0.81]; 
        P.N_int = [1e23, 1e23]; 
        P.Pt = [1, 1];
        P.w_tr_hop = [1, 1];
        P.w_tr = [1.03, 1.03];
        P.S_base = [1.6022e-23, 1.6022e-23, 1.6022e-23, 1.6022e-23];
        P.Pr = 1;
end

P = DerivedParameters(P, options);

end
