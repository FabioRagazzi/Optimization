function [out] = RunODEUpdating(x, tags, names, exp_lin_flags, equals, P, time_instants, options)
% NordicODEUpdating performs a ODE simulation updating only certain
% parameters
% INPUT
% x -> vector containing the new values of the parameters
% tags -> array used to group properly the elements of x
% names -> array of strings containing the names of the structure fileds to
% be updated
% exp_lin_flags -> array to distinguish linear and exponent parameters
% equals -> cell array of cell arrays containing the name(str) and index(int) of a
% parameter to duplicate
% P -> the reference structure
% time_instants -> array containing the time instants of interest
% options -> structure containing the various results of the simulation
% OUTPUT
% out -> structure containing the various results of the simulation

[cell_array, array_flags] = VectotToCellArray(x, tags);
[P] = UpdateP(P, names, cell_array, exp_lin_flags, array_flags, equals);
[P] = CompleteP(P);
[out] = RunODE(P, time_instants, options);
end

