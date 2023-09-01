function [P] = ParametersFunction(parameters, time_instants, options)
% ParametersFunction Summary of this function goes here
%   Detailed explanation goes here

switch parameters
    case "T_20_200p_refined"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(1e-3, 1e-3, 50, 50, 500, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 20, 20);
        P = BasselParameters(P);

    case "T_20_500p"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 500, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 20, 20);
        P = BasselParameters(P);

    case "T_70_500p"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 500, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 70, 70);
        P = BasselParameters(P);
       
    case "T_70_55_500p"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 500, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 68.0877, 55.7619);
        P = BasselParameters(P);

    case "T_20_100p"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 20, 20);
        P = BasselParameters(P);

    case "T_70_100p"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 70, 70);
        P = BasselParameters(P);
       
    case "T_70_55_100p"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 68.0877, 55.7619);
        P = BasselParameters(P);

    case "T20_new"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("T20", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);

    case "T70_new"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("T70", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);
       
    case "T70_55_new"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("T70_55", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);

    case "Trans_1d_lin"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("Trans_1d_lin", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);

    case "Trans_5d_lin"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("Trans_5d_lin", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);

    case "Trans_1d_exp"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("Trans_1d_exp", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);

    case "Trans_5d_exp"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("Trans_5d_exp", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);

    case "Trans_5d_TB852"
        P.geo = CreateGeometry1D(24.5676e-3, CreateDeltas(0, 0, 0, 0, 100, 17.9e-3), options);
        P.Tstruct = GetTstructList("Trans_5d_TB852", time_instants(1), time_instants(end), P.geo.x_int, P.geo.x0, P.geo.x_int(end));
        P = BasselParameters(P);        
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

% case "DOEDENS"
%         P.geo = CreateGeometry1D(0.1, CreateDeltas(0, 0, 0, 0, 100, 3.5e-4), options);
%         P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 70, 55);
%         P.eps_r = 2;
%         P.Phi_W = 0;
%         P.Phi_E = P.geo.L * 3e7;
%         P.phih = 1.148;
%         P.phie = 0.905;
%         P.n_start = [1e20, 1e20, 1e1, 1e1];
%         P.Ndeep = ones(P.geo.np, 2) .* [5.9293e20, 2.4966e20]; 
%         P.lambda_e = 4.1e-5;
%         P.lambda_h = 1e-1; 
%         P.a_int = [100 80] * 1e-9; 
%         P.w_hop = [0.74, 0.76]; 
%         P.a_sh = [1.25 2.25] * 1e-9; 
%         P.w_tr_int = [0.79, 0.81]; 
%         P.N_int = [1e23, 1e23]; 
%         P.Pt = [1, 1];
%         P.w_tr_hop = [1, 1];
%         P.w_tr = [1.03, 1.03];
%         P.S_base = [1.6022e-23, 1.6022e-23, 1.6022e-23, 1.6022e-23];
%         P.Pr = 1;
% 
%     case "TEST_CYLINDRICAL"
%         P.geo = CreateGeometry1D(0.1, CreateDeltas(0, 0, 0, 0, 100, 3.5e-4), options);
%         P.Tstruct = GetTstruct(time_instants, P.geo.x_int, P.geo.x0, P.geo.x_int(end), 70, 55);
%         P.eps_r = 2;
%         P.Phi_W = 0;
%         P.Phi_E = P.geo.L * 3e7;
%         P.phih = 1e100;
%         P.phie = 1e100;
%         P.n_start = [1e0, 1e0, 10, 10];
%         P.Ndeep = ones(P.geo.np, 2) .* [5.9293e20, 2.4966e20]; 
%         P.lambda_e = 4.1e-5;
%         P.lambda_h = 1e-1; 
%         P.a_int = [100 80] * 1e-9; 
%         P.w_hop = [0.74, 0.76]; 
%         P.a_sh = [1.25 2.25] * 1e-9; 
%         P.w_tr_int = [0.79, 0.81]; 
%         P.N_int = [1e23, 1e23]; 
%         P.Pt = [1, 1];
%         P.w_tr_hop = [1, 1];
%         P.w_tr = [1.03, 1.03];
%         P.S_base = [1.6022e-23, 1.6022e-23, 1.6022e-23, 1.6022e-23];
%         P.Pr = 1;
