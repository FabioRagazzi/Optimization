function [fitness] = ObjectiveFunctionJ(opt_kind, x, tags, names, exp_lin_flags, equals, P, time_instants, Jobjective, options)
% ObjectiveFunctionJ is the fitness function for a fit with an optimization
% algorithm
% INPUT
% opt_kind -> string to specify the optimization algorithm
% x -> is the vector containing the new values of the parameters
% tags -> array used to group properly the elements of tags
% names -> array of strings containing the names of the structure fileds to
% be updated
% exp_lin_flags -> array to distinguish linear and exponent parameters
% equals -> cell array of cell arrays containing the name(str) and index(int) of a
% parameter to duplicate
% P -> the reference structure
% time_instants -> array containing the time instants of interest
% Jobjective -> the polarization current to fit
% options -> structure containing the options for the simulation
% OUTPUT
% fitness -> value returned to the optimization algorithm

[out] = RunODEUpdating(x, tags, names, exp_lin_flags, equals, P, time_instants, options);

error_vector = ones(size(Jobjective)) * 1e300;
if length(out.tout) == length(time_instants)
    error_vector = (log10(Jobjective) - log10(out.J_dDdt))./log10(Jobjective);
end

% Computing fitness function based on the optimization algorithm
if opt_kind == "PS"
    fitness = norm(error_vector);
elseif opt_kind == "TRRA"
    fitness = error_vector;
end

end
