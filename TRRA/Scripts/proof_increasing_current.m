%% COMPUTATIONAL
clearvars, clc%, close all
addpath('..\Functions\')

L = 5;
dV = 1e3;
v_e = 0.5;
v_h = 1;
rho_e = 1e-8;
rho_h = 2e-8;

dt = 0.001;
eps0 = 8.854e-12;
eps_r = 2;
eps = eps0 * eps_r;

num_points = 200;
num_instants = 1001;

rho_out_h = zeros(num_instants, num_points);
rho_out_e = zeros(num_instants, num_points);

dx = L / num_points;
x_interni = (dx/2):dx:(L-dx/2);
x_interfacce = 0:dx:L;
time_instants = linspace(0, dt*(num_instants-1), num_instants);
current_x_h = 0;
current_x_e = 0;

for k = 2:num_instants
    current_x_h = current_x_h + v_h * dt;
    current_x_e = current_x_e + v_e * dt;
    rho_out_e(k,1:floor(current_x_e/dx)) = -rho_e;
    rho_out_h(k,end-floor(current_x_h/dx)+1:end) = rho_h;
end
rho_out = rho_out_h + rho_out_e;

coeff =  8 * eps / (3 * dx^2);
Kelet = Kelectrostatic(num_points, dx, eps);
phi = Electrostatic(rho_out', coeff, 0, dV, Kelet);
E = Electric_Field(phi, dx, 0, dV);

dDdt = compute_dDdt(E, time_instants, eps);

J_cond_e = zeros(num_points+1, num_instants);
J_cond_h = zeros(num_points+1, num_instants);
J_cond_h(2:end-1,:) = -rho_out_h(:,2:end)' * v_h;
J_cond_e(2:end-1,:) = -rho_out_e(:,1:end-1)' * v_e;

J_cond_e(1,:) = -rho_e * v_e;
J_cond_h(end,:) = -rho_h * v_h;
J_cond = J_cond_e + J_cond_e;

J_dDdt = J_cond + dDdt;

% figure
% subplot(1,3,1)
% ID(1) = plot(x_interni, rho_out(1,:));
% subplot(1,3,2)
% ID(2) = plot(x_interni, phi(:,1));
% subplot(1,3,3)
% ID(2) = plot(x_interfacce, E(:,1));
% pause(1)
% for i = 2:num_instants
%     subplot(1,3,1)
%     ID(1) = plot(x_interni, rho_out(i,:));
%     subplot(1,3,2)
%     ID(2) = plot(x_interni, phi(:,i));
%     subplot(1,3,3)
%     ID(2) = plot(x_interfacce, E(:,i));
%     pause(0.1)
% end

%% ANALITICAL
clearvars, clc%, close all
addpath('..\Functions\')

L = 5;
dV = 1e3;
ve = 0.5;
vh = 1;
rho_e = 1e-8;
rho_h = 2e-8;

dt = 1e-3;
end_time = 1; 

eps0 = 8.854e-12;
eps_r = 2;
eps = eps0 *eps_r;

Es = dV / L;

num_points_per_section = 1000;

Le = @(t) ve * t;
Lh = @(t) vh * t;

c1 = 0;
c3 = dV;

b2 = @(t) (rho_h*Lh(t).^2 + rho_e*Le(t).^2)/(2*L*eps) + Es;
b3 = @(t) (-rho_h*Lh(t).^2 - rho_e*Le(t).^2 + 2*rho_h*L*Lh(t))/(2*L*eps) - Es;
b1 = @(t) (rho_h*Lh(t).^2 + rho_e*Le(t).^2 - 2*rho_e*L*Le(t))/(2*L*eps) + Es;
c2 = @(t) Le(t) .* ( (rho_h*Lh(t).^2 + rho_e*Le(t).^2 - rho_e*L*Le(t))/(2*L*eps) + Es);

time_instants = 0:dt:end_time;

E_out = zeros(3*num_points_per_section-2, length(time_instants));
phi_out = zeros(3*num_points_per_section-2, length(time_instants));
rho_out = zeros(3*num_points_per_section-2, length(time_instants));
x_out = zeros(3*num_points_per_section-2, length(time_instants));
dDdt_out = zeros(3*num_points_per_section-2, length(time_instants));
Jcond_out = zeros(3*num_points_per_section-2, length(time_instants));
J_dDdt_out = zeros(3*num_points_per_section-2, length(time_instants));

k = 0;
for t = time_instants
    k = k + 1;
    b2_t = b2(t);
    b3_t = b3(t);
    b1_t = b1(t);
    c2_t = c2(t);
    x1 = linspace(0, Le(t), num_points_per_section);
    x1_real = x1;
    x2 = linspace(0, L-Lh(t)-Le(t), num_points_per_section);
    x2_real = linspace(Le(t), L-Lh(t), num_points_per_section);
    x3 = linspace(0, Lh(t), num_points_per_section);
    x3_real = linspace(L-Lh(t), L, num_points_per_section);
    phi_1 = 0.5 * rho_e * x1.^2 / eps + b1_t * x1 + c1;
    phi_2 = b2_t * x2 + c2_t;
    phi_3 = -0.5 * rho_h * x3.^2 / eps + b3_t * x3 + c3;
    E_1 = -rho_e * x1 / eps - b1_t;
    E_2 = -b2_t * ones(1, num_points_per_section);
    E_3 = -rho_h * x3 / eps + b3_t;

    dDdt_1 = -(rho_e * ve * Le(t) + rho_h * vh * Lh(t)) / L + rho_e * ve;
    dDdt_2 = -(rho_e * ve * Le(t) + rho_h * vh * Lh(t)) / L; 
    dDdt_3 = -(rho_e * ve * Le(t) + rho_h * vh * Lh(t)) / L + rho_h * vh;

    Jcond_1 = -rho_e * ve;
    Jcond_2 = 0;
    Jcond_3 = -rho_h * vh;

    x_out(:,k) = [x1_real(1:end-1) x2_real(1:end-1) x3_real]'; 
    E_out(:,k) = [E_1(1:end-1) E_2(1:end-1) flip(E_3)]';
    phi_out(:,k) = [phi_1(1:end-1) phi_2(1:end-1) flip(phi_3)]';
    rho_out(:,k) = [-rho_e * ones(1,num_points_per_section), zeros(1,num_points_per_section-2), rho_h * ones(1,num_points_per_section)]';
    dDdt_out(:,k) = [dDdt_1 * ones(1,num_points_per_section-1), dDdt_2 * ones(1,num_points_per_section-1), dDdt_3 * ones(1,num_points_per_section)]';
    Jcond_out(:,k) = [Jcond_1 * ones(1,num_points_per_section-1), zeros(1,num_points_per_section-1), Jcond_3 * ones(1,num_points_per_section)]';
    J_dDdt_out(:,k) = -(rho_e * ve * Le(t) + rho_h * vh * Lh(t)) * ones(3*num_points_per_section-2,1) / L;
end

J_dDdt = Jcond_out + dDdt_out;

%% GRAPH
% ID(1) = plot([x1_real, x2_real, x3_real],[phi_1, phi_2, flip(phi_3)]);
% ID(2) = plot([x1_real, x2_real, x3_real],[phi_1, phi_2, flip(phi_3)]);
% for i = 2:lenght(time_instants)
%     delete(ID)
%     yyaxis right
%     ID(1) = plot(x_out(:,i), phi_out(:,i));
%     yyaxis left
%     ID(2) = plot(x_out(:,i), rho_out(:,i));
%     pause(0.1)
% end


