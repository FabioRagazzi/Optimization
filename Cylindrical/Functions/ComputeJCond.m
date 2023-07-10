function [J_cond] = ComputeJCond(nh, ne, E, Diff_h, Diff_e, u_h, u_e, Inj_e, Inj_h, dx, e)
% ComputeJCond Summary of this function goes here
%   Detailed explanation goes here

J_cond_h = zeros(size(E));
J_cond_e = zeros(size(E));

J_diffusion_h = -Diff_h(2:end-1, :) .* (nh(2:end,:) - nh(1:end-1,:)) ./ dx(2:end-1);
J_diffusion_e = -Diff_e(2:end-1, :) .* (ne(2:end,:) - ne(1:end-1,:)) ./ dx(2:end-1);
Umax_h = max(0, u_h);
umin_h = min(0, u_h);
Umax_e = max(0, u_e);
umin_e = min(0, u_e);
J_drift_h = nh(1:end-1,:).*Umax_h(2:end-1,:) + nh(2:end,:).*umin_h(2:end-1,:);
J_drift_e = ne(1:end-1,:).*Umax_e(2:end-1,:) + ne(2:end,:).*umin_e(2:end-1,:);
J_cond_h(2:end-1,:) = J_diffusion_h + J_drift_h;
J_cond_e(2:end-1,:) = J_diffusion_e + J_drift_e;

J_cond_e(1,:) = Inj_e;
J_cond_h(end,:) = -Inj_h;

J_cond = e * (J_cond_h - J_cond_e);

end
