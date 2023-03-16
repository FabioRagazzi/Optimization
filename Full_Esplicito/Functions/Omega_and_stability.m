function [omega, den_for_stab] = Omega_and_stability(n, nh0t, ne0t, Bh, Be, Dh, De, S0, S1, S2, S3)
% OMEGA Compute the source terms
omega = zeros(size(n));
den_for_stab = zeros(size(n));
nh = n(:,1);
ne = n(:,2);
nht = n(:,3);
net = n(:,4);
omega(:,1) = -Bh*nh.*(1-nht/nh0t) + Dh*nht - S2*nh.*net - S3*nh.*ne;
omega(:,2) = -Be*ne.*(1-net/ne0t) + De*net - S1*ne.*nht - S3*nh.*ne;
omega(:,3) = +Bh*nh.*(1-nht/nh0t) - Dh*nht - S0*nht.*net - S1*nht.*ne;
omega(:,4) = +Be*ne.*(1-net/ne0t) - De*net - S0*nht.*net - S2*nh.*net;
den_for_stab(:,1) = Bh*(1-nht/nh0t) + S2*net + S3*ne;
den_for_stab(:,2) = Be*(1-net/ne0t) + S1*nht + S3*nh;
den_for_stab(:,3) = +Bh*nh/nh0t + Dh + S0*net + S1*ne;
den_for_stab(:,4) = +Be*ne/ne0t + De + S0*nht + S2*nh;
end
