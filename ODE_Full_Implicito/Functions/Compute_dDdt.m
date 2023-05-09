function [dDdt] = Compute_dDdt(E, t, eps)
% Compute_dDdt Summary of this function goes here
% E is a matrix where every column contains the values of the electric field at a given time instant  
dEdt = E;
dim_t = size(E,2);
r = zeros(1,dim_t);
delta_t = t(2:end) - t(1:end-1);
r(2:end-1) = delta_t(2:end)./delta_t(1:end-1);
r(1) = delta_t(2)/delta_t(1);
r(end) = delta_t(end-1)/delta_t(end);
dEdt(:,2:end-1) = (E(:,3:end) + (r(2:end-1).^2 - 1).*E(:,2:end-1) - (r(2:end-1).^2).*E(:,1:end-2))./ ...
                (r(2:end-1).*(r(2:end-1) + 1).*delta_t(1:end-1));
dEdt(:,1) = (((r(1)+1)^2)*E(:,2) - r(1)*(r(1)+2)*E(:,1) - E(:,3))/(r(1)*(r(1)+1)*delta_t(1));
dEdt(:,end) = (-((r(end)+1)^2)*E(:,end-1) + r(end)*(r(end)+2)*E(:,end) + E(:,end-2))/(r(end)*(r(end)+1)*delta_t(end));
dDdt = eps * dEdt;
end

