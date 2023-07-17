function [names, tags, exp_lin_flags, equals, lb, ub] = SetReferenceP(switch_var)
% SetReferenceP sets the parameter structure of reference
% INPUT
% switch_var -> string ("...") containing the identifier for the fitting settings
% OUTPUT
% names -> name of the parameters to fit
% tags -> integer identifier for the parameters
% exp_lin_flags -> flags to distinguish exponential from linear parameters
% equals -> cell array to set parameters that needs to be equal
% lb -> lower bounds
% ub -> upper bounds
arguments
    switch_var char {mustBeMember(switch_var,{ ...
        'FULL_CLASSIC_NARROW_1%', ...
        'FULL_CLASSIC_NARROW_10%', ...
        'FULL_CLASSIC', ...
        'TRUE_CLASSIC', ...
        'CLASSIC', ...
        'CLASSIC_NARROW_RANGE', ...
        'MOB_E', ...
        'ONLY_MOB_E', ...
        'ONLY_MOB_E_FULL', ...
        'ONLY_B_E', ...
        'ONLY_D_E', ...
        'ONLY_S_E', ...
        'FULL_NORDIC', ...
        'FULL_NORDIC_NARROW', ...
        'FULL_NORDIC_REALLY_NARROW'})}
end

switch switch_var
    case "FULL_CLASSIC_NARROW_1%"
        names = ["phih", "phie", "Bh", "Be", "Dh", "De", "S0", "S1", "S2", "S3",...
                "n_start(1)", "n_start(2)", "Ndeep(:,1)", "Ndeep(:,2)", "mu_h", "mu_e"]; 
        tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
        exp_lin_flags = logical([0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
        equals = {};
        good_parameters = [1.3090, -0.4318, -1.4241, -21.6542, -21.6542, 19.4116, 24.0893, -12.9162];
        lb = zeros(1, size(good_parameters,2)*2);
        ub = zeros(1, size(good_parameters,2)*2);
        delta_good_parameters = 0.01 * abs(good_parameters);
        lb(1:2:end) = good_parameters - delta_good_parameters;
        lb(2:2:end) = good_parameters - delta_good_parameters;
        ub(1:2:end) = good_parameters + delta_good_parameters;
        ub(2:2:end) = good_parameters + delta_good_parameters;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "FULL_CLASSIC_NARROW_10%"
        names = ["phih", "phie", "Bh", "Be", "Dh", "De", "S0", "S1", "S2", "S3",...
                "n_start(1)", "n_start(2)", "Ndeep(:,1)", "Ndeep(:,2)", "mu_h", "mu_e"]; 
        tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
        exp_lin_flags = logical([0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
        equals = {};
        good_parameters = [1.3090, -0.4318, -1.4241, -21.6542, -21.6542, 19.4116, 24.0893, -12.9162];
        lb = zeros(1, size(good_parameters,2)*2);
        ub = zeros(1, size(good_parameters,2)*2);
        delta_good_parameters = 0.1 * abs(good_parameters);
        lb(1:2:end) = good_parameters - delta_good_parameters;
        lb(2:2:end) = good_parameters - delta_good_parameters;
        ub(1:2:end) = good_parameters + delta_good_parameters;
        ub(2:2:end) = good_parameters + delta_good_parameters;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "FULL_CLASSIC"
        names = ["phih", "phie", "Bh", "Be", "Dh", "De", "S0", "S1", "S2", "S3",...
                "n_start(1)", "n_start(2)", "Ndeep(:,1)", "Ndeep(:,2)", "mu_h", "mu_e"]; 
        tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
        exp_lin_flags = logical([0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
        equals = {};
        good_parameters = [1.3090, -0.4318, -1.4241, -21.6542, -21.6542, 19.4116, 24.0893, -12.9162];
        lb = zeros(1, size(good_parameters,2)*2);
        ub = zeros(1, size(good_parameters,2)*2);
        delta_good_parameters = ones(1, size(good_parameters,2)) * 2;
        delta_good_parameters(1) = 0.1 * abs(good_parameters(1));
        lb(1:2:end) = good_parameters - delta_good_parameters;
        lb(2:2:end) = good_parameters - delta_good_parameters;
        ub(1:2:end) = good_parameters + delta_good_parameters;
        ub(2:2:end) = good_parameters + delta_good_parameters;

%         xv = [1.2808    1.4399   -0.5254   -0.2785   -2.4599   -2.7720  -23.3086  -23.6261  -21.4426  -20.1760   18.8446   19.4178   22.2478   22.1477  -12.0583  -13.2801];

%         lb = [1.0,  1.0, -5, -5, -5, -5, -24, -24, -24, -24, 18, 18, 19, 19, -15, -15];
%         ub = [1.5,  1.5,  0,  0,  0,  0, -18, -18, -18, -18, 24, 24, 21, 21, -12, -12];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "TRUE_CLASSIC"
        names = ["phih", "Bh", "wh", "S0", "n_start(1)", "Ndeep(:,1)", "mu_h"]; 
        tags = [1, 2, 3, 4, 5, 6, 7];
        exp_lin_flags = logical([0, 1, 0, 1, 1, 1, 1]);
        equals = {{"phie",1}, {"Be",2}, {"we",3}, ...
                  {"S1",4}, {"S2",4}, {"S3",4}....
                  {"n_start(2)",5}, {"Ndeep(:,2)",6}, {"mu_e",7}};
        lb = [0.9,  -6,  0.5,  -25,  16,  19, -16];
        ub = [1.5,   0,  1.5,  -17,  24,  21, -11];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "CLASSIC"
        names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "Ndeep(:,1)", "mu_h"]; 
        tags = [1, 2, 3, 4, 5, 6, 7];
        exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1]);
        equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
                  {"S1",4}, {"S2",4}, {"S3",4}....
                  {"n_start(2)",5}, {"Ndeep(:,2)",6}, {"mu_e",7}};
        lb = [1.0,  -5,  -5,  -24,  18,  19, -15];
        ub = [1.5,   0,   0,  -18,  24,  21, -12];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "CLASSIC_NARROW_RANGE"
        names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "Ndeep(:,1)", "mu_h"]; 
        tags = [1, 2, 3, 4, 5, 6, 7];
        exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1]);
        equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
                  {"S1",4}, {"S2",4}, {"S3",4}....
                  {"n_start(2)",5}, {"Ndeep(:,2)",6}, {"mu_e",7}};
        lb = [1.2,     -3,    -3,    -23,  19,  24, -15];
        ub = [1.5,      0,     0,  -21.6,  20,  25, -12.9];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "MOB_E"
        names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "Ndeep(:,1)", "a_int(1)", "w_hop(1)", "a_sh(1)"]; 
        tags = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1, 0, 1]);
        equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
                  {"S1",4}, {"S2",4}, {"S3",4}, ....
                  {"n_start(2)",5}, {"Ndeep(:,2)",6}, ... 
                  {"a_int(2)",7}, {"w_hop(2)",8}, {"a_sh(2)",9}};
        lb = [1.1,  -4,  -4,  -24,  17,  19,  -8,  0.7,  -10];
        ub = [1.5,   0,   0,  -18,  20,  21,  -6,  0.8,   -8];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "ONLY_MOB_E"
        names = ["a_int(1)", "w_hop(1)", "a_sh(1)"]; 
        tags = [1, 2, 3];
        exp_lin_flags = logical([1, 0, 1]);
        equals = {{"a_int(2)",1}, {"w_hop(2)",2}, {"a_sh(2)",3}};
        lb = [-8,  0.7,  -10];
        ub = [-6,  0.8,   -8];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "ONLY_MOB_E_FULL"
        names = ["a_int", "w_hop", "a_sh"]; 
        tags = [1, 1, 2, 2, 3, 3];
        exp_lin_flags = logical([1, 0, 1]);
        equals = {};
        lb = [-10,  -10,   0.5,   0.5,  -12,  -12];
        ub = [-7 ,   -7,   0.7,   0.7,   -9,   -9];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "ONLY_B_E"
        names = ["w_tr_int(1)", "N_int(1)"]; 
        tags = [1, 2];
        exp_lin_flags = logical([0, 1]);
        equals = {{"w_tr_int(2)",1}, {"N_int(2)",2}};
        lb = [0.7,  21];
        ub = [0.9,  24];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "ONLY_D_E"
        names = ["w_tr_hop(1)", "w_tr(1)"]; 
        tags = [1, 2];
        exp_lin_flags = logical([0, 0]);
        equals = {{"w_tr_hop(2)",1}, {"w_tr(2)",2}};
        lb = [0.85,  0.85];
        ub = [1.15,  1.15];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    
    case "ONLY_S_E"
        names = ["S_base(1)", "S_base(2)", "S_base(3)", "S_base(4)", "Pr"]; 
        tags = [1, 2, 3, 4, 5];
        exp_lin_flags = logical([1, 1, 1, 1, 0]);
        equals = {};
        lb = [-24, -24, -24, -24, 0.1];
        ub = [-18, -18, -18, -18,   1];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "FULL_NORDIC"
        names = ["a_int(1)", "w_hop(1)", "a_sh(1)",...
                 "w_tr_int(1)", "N_int(1)", "Ndeep(:,1)",...
                 "w_tr_hop(1)", "w_tr(1)", "S_base(1)",...
                 "n_start(1)", "phih", "Pr"]; 
        tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
        exp_lin_flags = logical([1, 0, 1,...
                                 0, 1, 1,...
                                 0, 0, 1,...
                                 1, 0, 0]);
        equals = {{"a_int(2)",1}, {"w_hop(2)",2}, {"a_sh(2)",3}, ...
                  {"w_tr_int(2)",4}, {"N_int(2)",5}, {"Ndeep(:,2)",6}, ....
                  {"w_tr_hop(2)",7}, {"w_tr(2)",8}, {"S_base(2)",9}, {"S_base(3)",9}, {"S_base(4)",9},...
                  {"n_start(2)",10}, {"phie",11}};
        lb = [-9,  0.5,  -11,  0.5,  20,  18,  0.8,  0.8,  -6,  19,  1.1,  0.5];
        ub = [-5,  0.9,  - 7,  0.9,  26,  22,  1.2,  1.2,  -1,  23,  1.5,  1];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "FULL_NORDIC_NARROW"
        names = ["a_int(1)", "w_hop(1)", "a_sh(1)",...
                 "w_tr_int(1)", "N_int(1)", "Ndeep(:,1)",...
                 "w_tr_hop(1)", "w_tr(1)", "S_base(1)",...
                 "n_start(1)", "phih", "Pr"]; 
        tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
        exp_lin_flags = logical([1, 0, 1,...
                                 0, 1, 1,...
                                 0, 0, 1,...
                                 1, 0, 0]);
        equals = {{"a_int(2)",1}, {"w_hop(2)",2}, {"a_sh(2)",3}, ...
                  {"w_tr_int(2)",4}, {"N_int(2)",5}, {"Ndeep(:,2)",6}, ....
                  {"w_tr_hop(2)",7}, {"w_tr(2)",8}, {"S_base(2)",9}, {"S_base(3)",9}, {"S_base(4)",9},...
                  {"n_start(2)",10}, {"phie",11}};
        lb = [-7.75,  0.644,  -9.75,  0.88,  22,  23.9,  0.91,  0.954,  -23.5,  19.3,  1.29,  0.903];
        ub = [-7.73,  0.646,  -9.73,  0.90,  24,  24.1,  0.93,  0.956,  -23.3,  19.5,  1.31,  0.905];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    case "FULL_NORDIC_REALLY_NARROW"
        names = ["a_int(1)", "w_hop(1)", "a_sh(1)",...
                 "w_tr_int(1)", "N_int(1)", "Ndeep(:,1)",...
                 "w_tr_hop(1)", "w_tr(1)", "S_base(1)",...
                 "n_start(1)", "phih", "Pr"]; 
        tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
        exp_lin_flags = logical([1, 0, 1,...
                                 0, 1, 1,...
                                 0, 0, 1,...
                                 1, 0, 0]);
        equals = {{"a_int(2)",1}, {"w_hop(2)",2}, {"a_sh(2)",3}, ...
                  {"w_tr_int(2)",4}, {"N_int(2)",5}, {"Ndeep(:,2)",6}, ....
                  {"w_tr_hop(2)",7}, {"w_tr(2)",8}, {"S_base(2)",9}, {"S_base(3)",9}, {"S_base(4)",9},...
                  {"n_start(2)",10}, {"phie",11}};
        lb = [-7.74731,  0.64589,  -9.74781,  0.8909,  23.79,  24.08929,  0.92039,  0.95589,  -23.41851,  19.41159,  1.30899,  0.90459];
        ub = [-7.74729,  0.64591,  -9.74779,  0.8911,  23.81,  24.08931,  0.92041,  0.95591,  -23.41849,  19.41161,  1.30901,  0.90461];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

end

end
