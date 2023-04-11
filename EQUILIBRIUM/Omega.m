function [omega] = Omega(n, num_points, nh0t, ne0t, Bh, Be, Dh, De, S0, S1, S2, S3, U)
% OMEGA Compute the source terms
omega = 0 * n;
n1 = n(:,1);
n2 = n(:,2);
n3 = n(:,3);
n4 = n(:,4);
omega(:,1) = -Bh*n1.*(1-n3/nh0t) + Dh*n3 - S2*n1.*n4 - S3*n1.*n2 + U;
omega(:,2) = -Be*n2.*(1-n4/ne0t) + De*n4 - S1*n2.*n3 - S3*n1.*n2 + U;
omega(:,3) = +Bh*n1.*(1-n3/nh0t) - Dh*n3 - S0*n3.*n4 - S1*n3.*n2;
omega(:,4) = +Be*n2.*(1-n4/ne0t) - De*n4 - S0*n3.*n4 - S2*n1.*n4;
omega = reshape(omega, [4*num_points, 1]);
end
