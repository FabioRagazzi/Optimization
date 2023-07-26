function [P] = DefaultOptParameter(P, n_trap_start)
%DEFAULTOPTPARAMETER Summary of this function goes here
%   Detailed explanation goes here

    P.num_points = 100;
    P.LW = 0; P.LE = 0; P.nW = 0; P.nE = 0;
    
    P.phih = 1;
    P.phie = 1;
    P.fix_inj = [0, 0; 0, 0];
    P.n_start = [1, 1, n_trap_start, n_trap_start];
    P.Ndeep = ones(P.num_points,2) .* [1, 1];

    % Fixed parameters not depending on the electric field 
    P.mu_h = 1;
    P.mu_e = 1;
    P.Bh = 1;
    P.Be = 1;
    P.wh = 1;
    P.we = 1;
    P.S0 = 1;
    P.S1 = 1;
    P.S2 = 1;
    P.S3 = 1;
    % Set all Nordic parameters to 1
    P = CompleteFixedParameters(P);

end
