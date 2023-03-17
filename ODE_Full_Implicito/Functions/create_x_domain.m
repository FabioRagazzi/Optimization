function [x, x_interfacce, x_interni] = create_x_domain(L, num_points)
% CREATE_X_DOMAIN 
% L -> length of the domain
% num_points -> number of cells of the domain
Delta = L / num_points;
x_interfacce = 0:Delta:L;
x_interni = linspace(Delta/2, L - Delta/2, num_points);
x = [0, x_interni, L];
end

