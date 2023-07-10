function [EletStat] = EletStatCylindrical(R0, deltas, eps, options)
% EletStatCylindrical Creates the elements needed for solving an electrostatic problem in 1D cylindrical coordinates
% INPUT
% R0 -> the inner radius value
% deltas -> spacing between the domain points
% eps -> dielectric permettivity of the material. It can be a scalar if it is considered 
% constant along the entire domain or a vector if it depends on the position 
% options -> input structure with fields:
%   type -> the type of matrix {'sparse','normal'}, default is 'normal'
% OUTPUT
% EletStat -> output structure containing the fields:
%   Kelet -> electrostatic matrix
%   multRho -> column vector to multiply to charge density
%   coeffW -> multiplicative coefficient for West boundary condition 
%   coeffE -> multiplicative coefficient for East boundary condition 
arguments
    R0 (1,1) {mustBeNumeric}
    deltas (1,:) {mustBeNumeric}
    eps (:,1) {mustBeNumeric}
    options.type char {mustBeMember(options.type,{'sparse','normal'})} = 'normal'
end
[~, x_int, x_face] = CreateX(deltas);
r_int = x_int + R0;
r_face = x_face + R0;
[Vol] = CreateVol(deltas);
r_over_delta = r_face ./ deltas;
W = deltas(1) / deltas(2);
E = deltas(end) / deltas(end-1);
[EletStat.Kelet] = Assemble3Diag(r_over_delta(2:end-1), 'type',options.type);
EletStat.Kelet(1,1) = EletStat.Kelet(1,1) + r_over_delta(1) * (1 + W);
EletStat.Kelet(1,2) = EletStat.Kelet(1,2) - r_over_delta(1) * W^2 / (1 + W);
EletStat.Kelet(end,end-1) = EletStat.Kelet(end,end-1) - r_over_delta(end) * E^2 / (1 + E); 
EletStat.Kelet(end,end) = EletStat.Kelet(end,end) + r_over_delta(end) * (1 + E); 
EletStat.multRho = Vol .* r_int' ./ eps;
EletStat.coeffW = r_over_delta(1) * (1 + 2*W) / (1 + W);
EletStat.coeffE = r_over_delta(end) * (1 + 2*E) / (1 + E);
end
