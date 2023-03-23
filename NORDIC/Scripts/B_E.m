%%
clearvars, clc, close all
 
% Parameters other than E
a_sh = 2e-9; % average spacing between shallow traps (m)
a_int = 90e-9; % average spacing between inter level states (m)
w_hop = 0.7; % average energy barrier for hopping from inter level states to shallow traps (eV)
T = 60; % temperature (°C)
N_deep = 1e20; % number density of deep traps (m^-3)
N_int = 1e23; % number density of inter level states (m^-3)
Pt = 1; % trapping probability ()
At = a_sh^2; % capture cross section (m^2)
w_tr_int = 0.8; % depth of the inter level state in relation to the valence band (eV)

% physic constants
h = 6.62607015e-34;
e = 1.602176634e-19;
kB = 1.380649e-23;
abs0 = 273.15;

v = kB * (T + abs0) / h;
Boltz_num = e / (kB * (T + abs0));
 
E_exp_range = [5 8];
E_lin_range = [1e7 1e8];

graph_type = "LIN";
if graph_type == "EXP"
    E = logspace(E_exp_range(1), E_exp_range(end), 100);
elseif graph_type == "LIN"
    E = linspace(E_lin_range(1), E_lin_range(end), 100);
end

% mob = 2*kB*a_int*(T+abs0)*exp(-Boltz_num*w_hop).*sinh(Boltz_num*a_sh*E/2)./(E * h);
mob = 1e-14; % mobility, considered independent from electric field (m^2/(Vs))

B0 = (N_deep/N_int)*v*exp(-Boltz_num*w_tr_int);
B = Pt * At * N_deep .* mob .* E; 

%% E dependence
figure
if graph_type == "EXP"
    semilogx(E, B, 'LineWidth',2, 'DisplayName','B = B(E)')
elseif graph_type == "LIN"
    plot(E, B, 'LineWidth',2, 'DisplayName','B = B(E)')
end
grid on
xlabel('E (V/m)')
ylabel('B (s^-^1)')
title("Trapping coefficient dependence on E when T = " + num2str(T) + " °C")
legend
set(gca, 'FontSize', 15)
