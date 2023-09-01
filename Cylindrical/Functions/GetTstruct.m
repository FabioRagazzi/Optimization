function [Tstruct] = GetTstruct(time_instants, r, ri, ro, Tri_in, Tro_in)
% GetTstruct Summary of this function goes here
%   Detailed explanation goes here

% Here work with temperatures in °C, they will be converted to K after
nt = length(time_instants);
Tri = ones(1,nt) * Tri_in;
Tro = ones(1,nt) * Tro_in;
Tstruct.matrix = TemperatureDistribution(r, ri, ro, Tri, Tro);
% i = find(time_instants/3600 >= 6, 1);
% Tstruct.matrix(:,i:end) = 20; 
Tstruct.time = time_instants';
Tstruct.temporal_interpolation = "linear";

end
