%%
clearvars, clc, close all
 
% Parameters other than E, T
a_sh = 2e-9; % average spacing between shallow traps (m)
a_int = 90e-9; % average spacing between inter level states (m)
w_hop = 0.7; % average energy barrier for hopping from inter level states to shallow traps (eV)

% physic constants
h = 6.62607015e-34;
e = 1.602176634e-19;
kB = 1.380649e-23;
abs0 = 273.15;
            
mu = @(E,T) 2*kB*a_int*T.*exp(-e*w_hop./(kB*T)).*sinh(e*a_sh*(E./T)/(2*kB))./(E * h);

T_range = [20, 70]; % (°C)
E_exp_range = [5 8]; % ()

T_range = T_range + abs0;

T = linspace(T_range(1), T_range(end), 100);
E = logspace(E_exp_range(1), E_exp_range(end), 100);
[Tm, Em] = meshgrid(T,E);

%% 3D plot
mob_3D = mu(Em,Tm);
figure
surf(E, T - abs0, mob_3D)
xlabel('E (V/m)')
ylabel('T (°C)')
zlabel('\mu (m^2V^-^1s^-^1)')
set(gca,'XScale','log')
title('Mobility dependence on E and T')
set(gca, 'FontSize', 15)

%% E dependence
T_star = 60; % (°C)
mob_E = mu(E, T_star+abs0);
E_threshold = kB * (T_star + abs0) / (e * a_sh);
figure
semilogx(E, mob_E, 'LineWidth',2, 'DisplayName','\mu = \mu(E)')
hold on
current_y_lim = get(gca,'Ylim');
plot([E_threshold, E_threshold], current_y_lim, 'r--', 'DisplayName','Threshold');
grid on
xlabel('E (V/m)')
ylabel('\mu (m^2V^-^1s^-^1)')
title("Mobility dependence on E when T = " + num2str(T_star) + " °C")
legend
set(gca, 'FontSize', 15)

%% T dependence
E_star = 2e7; % (V/m)
mob_T = mu(E_star, T);
figure
plot(T - abs0, mob_T, 'LineWidth',2)
grid on
xlabel('T (°C)')
ylabel('\mu (m^2V^-^1s^-^1)')
title("Mobility dependence on T when E = " + num2str(E_star) + " V/m")
set(gca, 'FontSize', 15)

