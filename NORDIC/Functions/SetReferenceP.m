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
if ~ exist('switch_var','var')
    switch_var = "DEFAULT";
end

switch switch_var
    case "CLASSIC"
        names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "Ndeep(:,1)", "mu_h"]; 
        tags = [1, 2, 3, 4, 5, 6, 7];
        exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1]);
        equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
                  {"S1",4}, {"S2",4}, {"S3",4}....
                  {"n_start(2)",5}, {"Ndeep(:,2)",6}, {"mu_e",7}};
        lb = [1.0,  -5,  -5,  -24,  18,  19, -15];
        ub = [1.5,   3,   3,  -18,  24,  26, -12];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "N_deep(1)"]; 
% tags = [1, 2, 3, 4, 5, 6];
% exp_lin_flags = logical([0, 1, 1, 1, 1, 1]);
% equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
%           {"S1",4}, {"S2",4}, {"S3",4}, ....
%           {"n_start(2)",5}, {"N_deep(2)",6}};
% lb = [1.1,  -4,  -4,  -4,  19,  20];
% ub = [1.5,   2,   2,   2,  23,  25];

% names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "N_deep(1)", "a_int(1)", "w_hop(1)", "a_sh(1)"]; 
% tags = [1, 2, 3, 4, 5, 6, 7, 8, 9];
% exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1, 0, 1]);
% equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
%           {"S1",4}, {"S2",4}, {"S3",4}, ....
%           {"n_start(2)",5}, {"N_deep(2)",6}, ... 
%           {"a_int(2)",7}, {"w_hop(2)",8}, {"a_sh(2)",9}};
% lb = [1.1,  -4,  -4,  -4,  19,  20,  -9,  0.5,  -11];
% ub = [1.5,   2,   2,   2,  23,  25,  -5,  0.9,   -7];

% % MOBILITY DEPENDENT ON E
% names = ["a_int", "w_hop", "a_sh"]; 
% tags = [1, 1, 2, 2, 3, 3];
% exp_lin_flags = logical([1, 0, 1]);
% equals = {};
% lb = [-10,  -10,   0.5,   0.5,  -12,  -12];
% ub = [-7 ,   -7,   0.7,   0.7,   -9,   -9];

% % FULL NORDIC 
% names = ["a_int(1)", "w_hop(1)", "a_sh(1)",...
%          "w_tr_int(1)", "N_int(1)", "N_deep(1)",...
%          "w_tr_hop(1)", "w_tr(1)", "S_base(1)",...
%          "n_start(1)", "phih"]; 
% tags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11];
% exp_lin_flags = logical([1, 0, 1,...
%                          0, 1, 1,...
%                          0, 0, 1,...
%                          1, 0]);
% equals = {{"a_int(2)",1}, {"w_hop(2)",2}, {"a_sh(2)",3}, ...
%           {"w_tr_int(2)",4}, {"N_int(2)",5}, {"N_deep(2)",6}, ....
%           {"w_tr_hop(2)",7}, {"w_tr(2)",8}, {"S_base(2)",9}, {"S_base(3)",9}, {"S_base(4)",9},...
%           {"n_start(2)",10}, {"phie",11}};
% lb = [-9,  0.5,  -11,  0.5,  20,  18,  0.8,  0.8,  -6,  19,  1.1];
% ub = [-5,  0.9,  - 7,  0.9,  26,  22,  1.2,  1.2,  -1,  23,  1.5];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    otherwise
        names = ["phih", "Bh", "Dh", "S0", "n_start(1)", "Ndeep(:,1)", "mu_h"]; 
        tags = [1, 2, 3, 4, 5, 6, 7];
        exp_lin_flags = logical([0, 1, 1, 1, 1, 1, 1]);
        equals = {{"phie",1}, {"Be",2}, {"De",3}, ...
                  {"S1",4}, {"S2",4}, {"S3",4}....
                  {"n_start(2)",5}, {"Ndeep(:,2)",6}, {"mu_e",7}};
        lb = [1.0,  -5,  -5,  -24,  18,  19, -15];
        ub = [1.5,   3,   3,  -18,  24,  26, -12];
end
end

