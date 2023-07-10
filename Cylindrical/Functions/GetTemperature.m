function [T_int, T] = GetTemperature(t, Tstruct, geo)
% GetTemperature Summary of this function goes here
%   Detailed explanation goes here
% t (1 x 1)
% Tstruct.matrix (np+1 x nt)
% Tstruct.time(nt x 1)
% T (np+1 x 1)

i_left = GetLeftIndex(Tstruct.time, t, length(Tstruct.time));
i_right = i_left+1;
T_left = Tstruct.matrix(:, i_left);
T_right = Tstruct.matrix(:, i_right);
x = (t - Tstruct.time(i_left)) / (Tstruct.time(i_right) - Tstruct.time(i_left));
T_int = T_left * (1-x) + T_right * x;

T = interp1(geo.x_int, T_int, geo.x);

end
