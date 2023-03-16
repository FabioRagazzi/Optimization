function [] = contributo_diffusivo(nh, ne, Delta, K_diff_h, K_diff_e)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
diffusion_h = -K_diff_h * (nh(2:end) - nh(1:end-1)) / Delta;
diffusion_e = -K_diff_e * (ne(2:end) - ne(1:end-1)) / Delta;
figure
subplot(1,2,1)
plot(diffusion_h)
subplot(1,2,2)
plot(diffusion_e)
end

