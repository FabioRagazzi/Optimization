function [fitness_function] = objective_function_J_NM(kind, x, tags, names, exp_lin_flags, equals, Parameters, F,...
                                                       time_instants, E_flags, ODE_options, Jobjective, flag_n)
% OBJECTIVE_FUNCTION_J_NM Fitness function for a fit with an optimization
% algorithm
%
% kind -> string to specify the optimization algorithm
%
% x -> is the vector containing the new values of the parameters
%
% tags -> array used to group properly the elements of tags
%
% names -> array of strings containing the names of the structure fileds to
% be updated
%
% exp_lin_flags -> array to distinguish linear and exponent parameters
%
% Parameters -> the reference structure
%
% F -> struct containing the flags specifing if "updating" some particular
% parameters(T, S, Sbase) is needed
%
% time_instants -> array containing the time instants of interest
%
% E_flags -> logical array containing the flags for the dependence from the
% electric field
%
% ODE_options -> options for the ODE solver
%
% Jobjective -> the polarization current to fit
%
% flag_n -> flag to get an error when number density becomes < 0 during
% simulation

if ~ exist('falg_n','var')
    flag_n = false;
end
[out] = nordicODE_updating(x, tags, names, exp_lin_flags, equals, Parameters, F,...
                           time_instants, E_flags, ODE_options, flag_n);

error_vector = Jobjective;
if length(out.tout) == length(time_instants)
    error_vector = (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective);
end

% Computing fitness function based on the optimization algorithm
if kind == "PS"
    fitness_function = norm(error_vector);
elseif kind == "TRRA"
    fitness_function = error_vector;
end

end
