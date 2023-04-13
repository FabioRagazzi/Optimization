function [omega] = Omega(n, Ndeep, B, D, S)
% Omega computes the source terms
% INPUT
% n -> npx4 matrix with the values of the number density for all the
% species
% Ndeep -> npx2 matrix with the values of the number density of the deep
% traps along the domain
% B -> npx2 matrix with the trapping coefficients, the first column 
% is referring to holes and the second to electrons
% D -> npx2 matrix with the detrapping coefficients, the first column 
% is referring to holes and the second to electrons
% S -> npx4 matrix with the recombination coefficients, the columns are
% referring in order to the recombination between:
% 0) trapped h - trapped e     
% 1) trapped h - mobile e      
% 2) mobile h - trapped e 
% 3) mobile h - mobile e 
% OUTPUT
% omega -> column vector containing the source terms for all the species
% along the domain

% Initializing omega
omega = zeros(size(n));

% Naming all the quantities
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
Nh = Ndeep(:,1);
Ne = Ndeep(:,2);

% Assembling the matrix omega following the equations of the model
Th = Bh.*n1.*(1-n3./Nh);
Te = Be.*n2.*(1-n4./Ne);
Fh = Dh.*n3;
Fe = De.*n4;
Rtt = S0.*n3.*n4;
Rtm = S1.*n2.*n3;
Rmt = S2.*n1.*n4;
Rmm = S3.*n1.*n2;
omega(:,1) = -Th + Fh - Rmt - Rmm;
omega(:,2) = -Te + Fe - Rtm - Rmm;
omega(:,3) = +Th - Fh - Rtt - Rtm;
omega(:,4) = +Te - Fe - Rtt - Rmt;

% Reshaping omega in a single column vector in order to make the ODE work
omega = reshape(omega,[],1);
end
