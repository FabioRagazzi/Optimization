function [error_vector] = objective_function_J_TRRA_NM(x, tags, names, exp_lin_flags, equals, Parameters, ...
                                                       time_instants, E_flags, ODE_options, Jobjective)
% OBJECTIVE_FUNCTION_J_TRRA Fitness function for a fit with TRRA  
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
% time_instants -> array containing the time instants of interest
%
% E_flags -> logical array containing the flags for the dependence from the
% electric field
%
% ODE_options -> options for the ODE solver
%
% Jobjective -> the polarization current to fit
%
[out] = nordicODE_updating(x, tags, names, exp_lin_flags, equals, Parameters, ...
                           time_instants, E_flags, ODE_options);

error_vector = Jobjective;
if length(out.tout) == length(time_instants)
    error_vector = (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective);
end

end
