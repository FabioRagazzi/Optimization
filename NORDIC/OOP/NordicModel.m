classdef NordicModel
    % NORDICMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        % physic constants
        h, e, kB, eps0, A, abs0

        % user imputs that will remain constant
        Tc, eps_r, phi, lambda, a_int, a_sh, N_deep, N_int
        w_hop, w_tr_hop, w_tr_int, w_tr
        Pt, At, Pr, S0, S1, S2, S3, V, L 

        % variables derived from user inputs that will remain constant
        v, beta, eps, kBT, Boltz_num, B0, arg_sinh, ext_mult_sinh, a, TK
    end
    
    properties (SetAccess = private)
        E, mu, u, B
    end

    methods
        function obj = NordicModel(Table_row)
            % NORDICMODEL Construct an instance of this class
            %   Detailed explanation goes here

            % Initializing physic constants
            obj.h = 6.62607015e-34;
            obj.e = 1.602176634e-19;
            obj.kB = 1.380649e-23;
            obj.eps0 = 8.854187817e-12;
            obj.A = 1.20173e6;
            obj.abs0 = 273.15;

            % Initializing all the user inputs
            obj.L = Table_row.L;
            obj.Tc = Table_row.T;
            obj.eps_r = Table_row.eps_r;
            obj.phi.e = Table_row.phi_e;
            obj.phi.h = Table_row.phi_h;
            obj.lambda.e = Table_row.lambda_e; 
            obj.lambda.h = Table_row.lambda_h;
            obj.a_int.e = Table_row.a_int_e;
            obj.a_int.h = Table_row.a_int_h;
            obj.a_sh.e = Table_row.a_sh_e;
            obj.a_sh.h = Table_row.a_sh_h;
            obj.N_deep.e = Table_row.N_deep_e; 
            obj.N_deep.h = Table_row.N_deep_h; 
            obj.N_int.e = Table_row.N_int_e;
            obj.N_int.h = Table_row.N_int_h;
            obj.w_hop.e = Table_row.w_hop_e;
            obj.w_hop.h = Table_row.w_hop_h;
            obj.w_tr_hop.e = Table_row.w_tr_hop_e; 
            obj.w_tr_hop.h = Table_row.w_tr_hop_h; 
            obj.w_tr_int.e = Table_row.w_tr_int_e; 
            obj.w_tr_int.h = Table_row.w_tr_int_h; 
            obj.w_tr.e = Table_row.w_tr_e;
            obj.w_tr.h = Table_row.w_tr_h;
            obj.Pt.e = Table_row.Pt_e; 
            obj.Pt.h = Table_row.Pt_h; 
            obj.At.e = Table_row.At_e; 
            obj.At.h = Table_row.At_h; 
            obj.Pr = Table_row.Pr; 
            obj.S0 = Table_row.S0; 
            obj.S1 = Table_row.S1;
            obj.S2 = Table_row.S2;
            obj.S3 = Table_row.S3;
            obj.V.e = Table_row.V_e;
            obj.V.h = Table_row.V_h;

            % Initializing derived parameters
            obj.TK = obj.Tc + obj.abs0;
            obj.kBT = obj.kB * obj.TK;
            obj.Boltz_num = obj.e / obj.kBT;
            obj.v = obj.kBT / obj.h;
            obj.eps = obj.eps0 * obj.eps_r;
            obj.beta = sqrt((obj.e^3)/(4*pi*obj.eps));
            obj.B0.e = obj.N_deep.e * obj.v * exp(-obj.w_tr_int.e * obj.Boltz_num) / obj.N_int.e; 
            obj.B0.h = obj.N_deep.h * obj.v * exp(-obj.w_tr_int.h * obj.Boltz_num) / obj.N_int.h; 
            obj.arg_sinh.e = obj.e * obj.a_sh.e / (2 * obj.kBT);
            obj.arg_sinh.h = obj.e * obj.a_sh.h / (2 * obj.kBT);
            obj.ext_mult_sinh.e = 2 * obj.v * obj.a_int.e * exp(-obj.w_hop.e * obj.Boltz_num);
            obj.ext_mult_sinh.h = 2 * obj.v * obj.a_int.h * exp(-obj.w_hop.h * obj.Boltz_num);
            obj.a = obj.A / obj.e;
        end
        
        function obj = compute_E(obj)
            obj.E = 1e8 * rand(1,10);
        end

        function obj = compute_mobility(obj)
            obj.mu = struct;
            obj.mu.e = obj.ext_mult_sinh.e * sinh(obj.arg_sinh.e * obj.E) ./ obj.E;
            obj.mu.h = obj.ext_mult_sinh.h * sinh(obj.arg_sinh.h * obj.E) ./ obj.E;
        end

        function obj = compute_velocity(obj)
            obj.u = struct;
            obj.u.e = -obj.mu.e .* obj.E;
            obj.u.h =  obj.mu.h .* obj.E;
        end

        function obj = compute_B(obj)
            obj.B = struct;
            obj.B.e = obj.Pt.e * obj.N_deep.e * obj.At.e * obj.u.e;
            obj.B.h = obj.Pt.h * obj.N_deep.h * obj.At.h * obj.u.h;
        end

%         function [] = set_Property1(obj,new_val)
%             % METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             obj.Property1 = new_val;
%         end
    end
end

