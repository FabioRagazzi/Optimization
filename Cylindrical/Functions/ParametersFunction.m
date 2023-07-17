function [P] = ParametersFunction(parameters, time_instants, options)
% ParametersFunction Summary of this function goes here
%   Detailed explanation goes here

switch parameters
    case "DOEDENS"
        P.geo = CreateGeometry1D(0.1, CreateDeltas(0, 0, 0, 0, 100, 3.5e-4), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 70, 55);
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
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 70, 55);
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

    case "CONFRONTO_BASSEL"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 25, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 68.0877, 55.7619);
        P.eps_r = 2.3;
        P.Phi_W = 320e3;
        P.Phi_E = 0;
        P.phih = 1.27;
        P.phie = 1.3;
        P.n_start = [1, 1, 1, 1] * 0;
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
        P.w_tr_int = [1, 1]; 
        P.N_int = [1, 1]; 
        P.Pt = [1, 1];
        P.w_tr_hop = [1, 1];
end

P = DerivedParameters(P, options);

end

% w_ue=0.71; %trap depths for electrons for mobility
% w_uh=0.65; %trap depths for holes for mobility
% %%%%%%%%%%%%%%%%%%%%%%%%%% de-trapping coefficients
% w_tre=0.96; %trap depths for electrons
% w_trh=0.99; %trap depths for holes
% a_sh_e=3e-9;%2.25e-9; %[nm] Shallow trap spacing for electrons
% a_sh_h=3e-9;%1.25e-9; %[nm] Shallow trap spacing for holes
% a_int_e=3e-9;%80e-9; %[nm] inter-level state spacing for electrons
% a_int_h=3e-9;%100e-9; %[nm] inter-level state spacing for holes
% S0_base=0;
% S1_base=1e-4;
% S2_base=1e-4;
% S3_base=1e-4;
% S_0=S0_base;
% S_1(j,:)=S1_base + miu_e(j,:)./eps;
% S_2(j,:)=S2_base + miu_h(j,:)./eps;
% S_3(j,:)=S3_base + (miu_e(j,:)+miu_h(j,:))./eps;
% w_ei=1.3; %injection barrier hights for electrons
% w_hi=1.27; %injection barrier hights for holes
% %%%%%%%%%%%%%%%%%%%%%%%%%% trapping coefficients
% B_e=0.1;
% B_h=0.2;
