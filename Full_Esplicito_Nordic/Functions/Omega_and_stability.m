function [omega, den_for_stab] = Omega_and_stability(n, N_deep, B, D, S)
% OMEGA_AND_STABILITY Compute the source terms and the denominator nheded
% for dt for stability
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

% initializing omega and den_for_stab
omega = zeros(size(n));
den_for_stab = zeros(size(n));

% naming all the quantities
nh = n(:,1);
ne = n(:,2);
nht = n(:,3);
net = n(:,4);
Bh = B(:,1);
Be = B(:,2);
Dh = D(:,1);
De = D(:,2);
S0 = S(:,1);
S1 = S(:,2);
S2 = S(:,3);
S3 = S(:,4);

% assembling the matrix omega following the equations of the model
omega(:,1) = -Bh.*nh.*(1-nht/N_deep(1)) + Dh.*nht - S2.*nh.*net - S3.*nh.*ne;
omega(:,2) = -Be.*ne.*(1-net/N_deep(2)) + De.*net - S1.*ne.*nht - S3.*nh.*ne;
omega(:,3) = +Bh.*nh.*(1-nht/N_deep(1)) - Dh.*nht - S0.*nht.*net - S1.*nht.*ne;
omega(:,4) = +Be.*ne.*(1-net/N_deep(2)) - De.*net - S0.*nht.*net - S2.*nh.*net;

% computing the denominators that will be used to find the dt that ensure
% stability
den_for_stab(:,1) = Bh.*(1-nht/N_deep(1)) + S2.*net + S3.*ne;
den_for_stab(:,2) = Be.*(1-net/N_deep(2)) + S1.*nht + S3.*nh;
den_for_stab(:,3) = +Bh.*nh/N_deep(1) + Dh + S0.*net + S1.*ne;
den_for_stab(:,4) = +Be.*ne/N_deep(2) + De + S0.*nht + S2.*nh;

end
