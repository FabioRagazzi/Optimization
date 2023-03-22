function [omega] = Omega_NM(n, num_points, N_deep, B, D, S0, S1, S2, S3)
% OMEGA Compute the source terms
%
% B is a matrix with two columns of length num_points, the first is referring to h and the
% second to e
%
% D is a matrix with two columns of length num_points, the first is referring to h and the
% second to e
omega = 0 * n;
n1 = n(:,1);
n2 = n(:,2);
n3 = n(:,3);
n4 = n(:,4);
omega(:,1) = -B(:,1).*n1.*(1-n3/N_deep(1)) + D(:,1).*n3 - S2*n1.*n4 - S3*n1.*n2;
omega(:,2) = -B(:,2).*n2.*(1-n4/N_deep(2)) + D(:,2).*n4 - S1*n2.*n3 - S3*n1.*n2;
omega(:,3) = +B(:,1).*n1.*(1-n3/N_deep(1)) - D(:,1).*n3 - S0*n3.*n4 - S1*n3.*n2;
omega(:,4) = +B(:,2).*n2.*(1-n4/N_deep(2)) - D(:,2).*n4 - S0*n3.*n4 - S2*n1.*n4;
omega = reshape(omega, [4*num_points, 1]);
end
