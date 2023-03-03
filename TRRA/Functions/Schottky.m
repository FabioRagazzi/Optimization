function [gamma] = Schottky(E, aT2exp, kBT, beta)
% SCHOTTKY Computes the flux emitted from the electrode when a field E is applied
% E = Electric field at the electrode
gamma = aT2exp * ( exp( beta*sqrt( abs(E) )/kBT ) - 1 );
end
