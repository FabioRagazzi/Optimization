function [out] = nordicODE_updating(x, tags, names, exp_lin_flags, equals, Parameters, time_instants, E_flags, ODE_options)
%
% NORDICODE_UPDATING Performs a Nordic ODE simulations updating only
% certain parameters
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
% equals -> cell array of cell arrays containing the name(str) and index(int) of a
% parameter to duplicate
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

[cell_array, array_flags] = vector_to_cell_array(x, tags);

[Parameters] = updateP(Parameters, names, cell_array, exp_lin_flags, array_flags, equals);

% Set to false the flag that do not correspond to a simulation parameter
flagT = false;
flagS = false;
flagSbase = true;
[Parameters] = CompleteP(Parameters, flagT, flagS, flagSbase);

[out] = NordicODE(Parameters, time_instants, E_flags, ODE_options);

end

