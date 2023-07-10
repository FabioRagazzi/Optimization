function [Tstruct] = GetTstruct()
% GetTstruct Summary of this function goes here
%   Detailed explanation goes here

Tstruct.matrix = ones(101,60) * 333.15;
Tstruct.time = [0, logspace(0,5,59)]';

end
