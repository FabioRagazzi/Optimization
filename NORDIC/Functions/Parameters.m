function [P] = Parameters(name)
% Parameters creates the structure containing the simulation parameters
% INPUT
% name -> string ("...") containing the identifier for the parameters
% OUTPUT
% P -> structure containing the simulation parameters
if ~ exist('name','var')
    name = "DEFAULT";
end

switch name
    case "BEST_FIT_SERI"
        % PARAMETERS THAT CAN NOT BE USED FOR A FIT
        % Geometry
        P.L = 3.5e-4;
        P.num_points = 100;
        P.LW = 0;
        P.LE = 0;
        P.nW = 0;
        P.nE = 0;
        % Material
        P.T = 333.15;
        P.eps_r = 2;

        % PARAMETERS THAT CAN BE USED FOR A FIT
        % Essential Parameters
        P.Phi_W = 0;
        P.Phi_E = 1.05e4;
        P.phih = 1.3090;
        P.phie = 1.3090;
        P.fix_inj = [0, 0; 0, 0];
        P.n_start = [10^(19.4116), 10^(19.4116), 0, 0];
        P.Ndeep = ones(P.num_points,2) .* [10^(24.0893), 10^(24.0893)];
        
        % Fixed parameters not depending on the electric field 
        P.mu_h = 10^(-12.9162);
        P.mu_e = 10^(-12.9162);
        P.Bh = 10^(-0.4318);
        P.Be = 10^(-0.4318);
        P.Dh = 10^(-1.4241);
        P.De = 10^(-1.4241);
        P.S0 = 10^(-2.8589) * 1.6022e-19;
        P.S1 = 10^(-2.8589) * 1.6022e-19;
        P.S2 = 10^(-2.8589) * 1.6022e-19;
        P.S3 = 10^(-2.8589) * 1.6022e-19;

        % Set all Nordic parameters to 1
        P = CompleteFixedParameters(P);



    case "NORDIC_STANDARD"
        % PARAMETERS THAT CAN NOT BE USED FOR A FIT
        % Geometry
        P.L = 3.5e-4;
        P.num_points = 100;
        P.LW = 0;
        P.LE = 0;
        P.nW = 0;
        P.nE = 0;
        % Material
        P.T = 333;
        P.eps_r = 2.3;
        
        % PARAMETERS THAT CAN BE USED FOR A FIT
        % Essential Parameters
        P.Phi_W = 0;
        P.Phi_E = P.L * 1e7;
        P.phih = 1.148;
        P.phie = 0.905;
        P.fix_inj = [0, 0; 0, 0];
        P.fix_inj = [0, 0; 0, 0];
        P.n_start = [1e21, 1e21, 1e5, 1e5];
        P.Ndeep = ones(P.num_points,2) .* [5.9293e20, 2.4966e20]; % (m^-3)
        
        % Set all classic parameters to 1
        P = CompleteNordicParameters(P);
        
        % Extra Schottky parameter
        P.lambda_e = 4.1e-5; % ()
        P.lambda_h = 1e-1; % ()
        % Extra parameters needed when the mobility is dependent from the electric
        % field
        P.a_int = [100 80] * 1e-9; % (m)
        P.w_hop = [0.74, 0.76]; % (eV)
        P.a_sh = [1.25 2.25] * 1e-9; % (m)
        % Extra parameters needed when the trapping coefficient is dependent on the
        % electric field
        P.w_tr_int = [0.79, 0.81]; % (eV)
        P.N_int = [1e23, 1e23]; % (m^-3)
        P.Pt = [1, 1]; % ()
        % Extra parameters needed when the detrapping coefficient is dependent on the
        % electric field
        P.w_tr_hop = [1, 1]; % (eV)
        P.w_tr = [1.03, 1.03]; % (eV)
        % Extra parameters needed when the recombination coefficients are dependent on the
        % electric field
        P.S_base = [2e-23, 2e-23, 2e-23, 2e-23];
        P.Pr = 1; % ()


    case "RECTANGLE"
        % PARAMETERS THAT CAN NOT BE USED FOR A FIT
        % Geometry
        P.L = 5e-4;
        P.num_points = 100;
        P.LW = 0;
        P.LE = 0;
        P.nW = 0;
        P.nE = 0;
        % Material
        P.T = 293.15;
        P.eps_r = 2;
        
        % PARAMETERS THAT CAN BE USED FOR A FIT
        % Essential Parameters
        P.Phi_W = 0;
        P.Phi_E = P.L * 1e7;
        P.phih = 0;
        P.phie = 0;
        P.fix_inj = [0, 0; 0, 0];
        n_start_h = ones(P.num_points,1) * 1e5;
        n_start_h(40:60,1) = 1e18;
        P.n_start = n_start_h .* [1, 1, 0, 0];
        P.Ndeep = ones(P.num_points,2) .* [1e25, 1e25]; 
        
        % Fixed parameters not depending on the electric field 
        P.mu_h = 1e-13;
        P.mu_e = 1e-13;
        P.Bh = 2e-2;
        P.Be = 2e-2;
        P.Dh = 1e-3;
        P.De = 1e-3;
        P.S0 = 5e-22;
        P.S1 = 5e-22;
        P.S2 = 5e-22;
        P.S3 = 5e-22;
        
        % Set all Nordic parameters to 1
        P = CompleteFixedParameters(P);



    otherwise
        % PARAMETERS THAT CAN NOT BE USED FOR A FIT
        % Geometry
        P.L = 3.5e-4;
        P.num_points = 100;
        P.LW = 2.5e-5;
        P.LE = 2.5e-5;
        P.nW = 7;
        P.nE = 7;
        % Material
        P.T = 333;
        P.eps_r = 2.3;
        
        % PARAMETERS THAT CAN BE USED FOR A FIT
        % Essential Parameters
        P.Phi_W = 0;
        P.Phi_E = P.L * 3e7;
        P.phih = 1.3;
        P.phie = 1.3;
        P.n_start = [1e19, 1e19, 1e2, 1e2];
        P.Ndeep = ones(P.num_points,2) .* [5.9293e20, 2.4966e20]; % (m^-3)
        
        % Fixed parameters not depending on the electric field 
        P.mu_h = 1e-13;
        P.mu_e = 1e-13;
        P.Bh = 2.4e-2;
        P.Be = 1.2e-2;
        P.Dh = 1e-3;
        P.De = 1e-3;
        P.S0 = 5e-22;
        P.S1 = 5e-22;
        P.S2 = 5e-22;
        P.S3 = 5e-22;
        
        % Extra Schottky parameter
        P.lambda_e = 1; % ()
        P.lambda_h = 1; % ()
        % Extra parameters needed when the mobility is dependent from the electric
        % field
        P.a_int = [100 80] * 1e-9; % (m)
        P.w_hop = [0.74, 0.76]; % (eV)
        P.a_sh = [1.25 2.25] * 1e-9; % (m)
        % Extra parameters needed when the trapping coefficient is dependent on the
        % electric field
        P.w_tr_int = [0.79, 0.81]; % (eV)
        P.N_int = [1e23, 1e23]; % (m^-3)
        P.Pt = [1, 1]; % ()
        % Extra parameters needed when the detrapping coefficient is dependent on the
        % electric field
        P.w_tr_hop = [1, 1]; % (eV)
        P.w_tr = [1.03, 1.03]; % (eV)
        % Extra parameters needed when the recombination coefficients are dependent on the
        % electric field
        P.S_base = [2e-23, 2e-23, 2e-23, 2e-23];
        P.Pr = 1; % ()
end
% Complete P
P = PhysicsConstants(P);
P = DerivedParameters(P);
P = CompleteP(P);
end
