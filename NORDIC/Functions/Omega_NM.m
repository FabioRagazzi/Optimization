function [omega] = Omega_NM(n, num_points, N_deep, B, D, S)
% OMEGA Compute the source terms
%
% B is a matrix with two columns of length num_points, the first is referring to h and the
% second to e
%
% D is a matrix with two columns of length num_points, the first is referring to h and the
% second to e
%
% S is a matrix with four columns of length num_points, that are referring
% in order to:
% 0) trapped h - trapped e recombination
% 1) trapped h - mobile e recombination
% 2) mobile h - trapped e recombination
% 3) mobile h - mobile e recombination

% initializing omega
omega = zeros(size(n));

% naming all the quantities
n1 = n(:,1);
n2 = n(:,2);
n3 = n(:,3);
n4 = n(:,4);
Bh = B(:,1);
Be = B(:,2);
Dh = D(:,1);
De = D(:,2);
S0 = S(:,1);
S1 = S(:,2);
S2 = S(:,3);
S3 = S(:,4);

% assembling the matrix omega following the equations of the model
omega(:,1) = -Bh.*n1.*(1-n3/N_deep(1)) + Dh.*n3 - S2.*n1.*n4 - S3.*n1.*n2;
omega(:,2) = -Be.*n2.*(1-n4/N_deep(2)) + De.*n4 - S1.*n2.*n3 - S3.*n1.*n2;
omega(:,3) = +Bh.*n1.*(1-n3/N_deep(1)) - Dh.*n3 - S0.*n3.*n4 - S1.*n3.*n2;
omega(:,4) = +Be.*n2.*(1-n4/N_deep(2)) - De.*n4 - S0.*n3.*n4 - S2.*n1.*n4;

% reshaping omega in a single column vector in order to make the ODE work
omega = reshape(omega, [4*num_points, 1]);

end
