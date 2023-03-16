%% PARAMETERS
clearvars, clc, close all
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\Full_Esplicito')
addpath("Functions\")

% Flags for the simulation
P.flag_chimica = true;

% Parameters of the simulation
P.L = 4e-4;
P.num_points = 100;
P.T = 60;
P.eps_r = 2;
P.Phi_W = 0;
P.Phi_E = 4e3;
P.mu_h = 5e-14;
P.mu_e = 5e-14;
P.nh0t = 6e20;
P.ne0t = 6e20;
P.phih = 0.7; 
P.phie = 0.7; 
P.Bh = 0.2;
P.Be = 0.2;
P.Dh = 0.1;
P.De = 0.1;
P.S0 = 4e-3;
P.S1 = 4e-3;
P.S2 = 4e-3;
P.S3 = 4e-3;
P.n_start = [1e18, 1e18, 0, 0];
P.time_instats = [0, logspace(0, 4, 99)];

% Physics constants
P.a = 7.5005e12;
P.e = 1.6022e-19;
P.kB = 1.381e-23;
P.eps0 = 8.854e-12;
P.abs0 = 273.15;

% Derived parameters
P.Delta = P.L / P.num_points;
P.eps = P.eps_r * P.eps0;
P.T = P.T + P.abs0;
P.kBT = P.kB * P.T;
P.beta = sqrt((P.e^3)/(4*pi*P.eps));
P.coeff =  8 * P.eps / (3 * P.Delta^2);
P.aT2exp = P.a * (P.T^2) * exp(-[P.phie, P.phih] * P.e / P.kBT); 
P.D_h = P.mu_h * P.kBT / P.e;
P.D_e = P.mu_e * P.kBT / P.e;
P.S0 = P.S0 * P.e;
P.S1 = P.S1 * P.e;
P.S2 = P.S2 * P.e;
P.S3 = P.S3 * P.e;
P.Kelet = Kelectrostatic(P.num_points, P.Delta, P.eps);

if ~ P.flag_chimica
    P.nh0t = 1;
    P.ne0t = 1;
    P.Bh = 0;
    P.Be = 0;
    P.Dh = 0;
    P.De = 0;
    P.S0 = 0;
    P.S1 = 0;
    P.S2 = 0;
    P.S3 = 0; 
end

cd(current_path)
clear current_path

%% SOLVE FULL EXPLICIT
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\Full_Esplicito')
addpath("Functions\")

% output variables definition
nh_out = zeros(P.num_points, length(P.time_instats));
ne_out = zeros(P.num_points, length(P.time_instats));
nht_out = zeros(P.num_points, length(P.time_instats));
net_out = zeros(P.num_points, length(P.time_instats));
rho_out = zeros(P.num_points, length(P.time_instats));
phi_out = zeros(P.num_points+2, length(P.time_instats));
E_out = zeros(P.num_points+1, length(P.time_instats));

% setting initial condition
CFL = 0.5;
exit_flag = false;
save_flag = true;
save_index = 1;
n = ones(P.num_points, 4) .* P.n_start;
n_new = zeros(size(n));
t_current = P.time_instats(1);
index_time_goal_next = 2;
t_goal_next = P.time_instats(2);

% starting the loop
tic
while true

    % at this point the number density of all the species at the current time
    % instant are known, we need to calculate the number density of all the
    % species at the next time instant:

    rho = sum(n.*[1, -1, 1, -1], 2) * P.e;
    phi = Electrostatic(rho, P.coeff, P.Phi_W, P.Phi_E, P.Kelet); 
    E = Electric_Field(phi, P.Delta, P.Phi_W, P.Phi_E);
    u = E .* [P.mu_h, -P.mu_e];
    
    % saving the values if the "save_flag" is "true"
    if save_flag
        nh_out(:,save_index) = n(:,1);
        ne_out(:,save_index) = n(:,2);
        nht_out(:,save_index) = n(:,3);
        net_out(:,save_index) = n(:,4);
        rho_out(:,save_index) = rho;
        phi_out(:,save_index) = [P.Phi_W; phi; P.Phi_E];
        E_out(:,save_index) = E;
        save_index = save_index + 1;
        save_flag = false;
    end
    
    % exit the loop if we reached the last time instant
    if exit_flag
        break
    end
    
    % source terms contributions (omega has a column for each kind of
    % species) and also denominator contributions for dt for stability
    [omega, den_for_stab] = Omega_and_stability(n, P.nh0t, P.ne0t, P.Bh, P.Be, P.Dh, P.De, P.S0, P.S1, P.S2, P.S3);

    % injection from electrodes (g_schottky has two values, one for the left
    % electrode and one for the right electrode)
    g_schottky = Schottky([E(1), E(end)], P.aT2exp, P.kBT, P.beta);

    % computing Kh for free holes (useful for dt for stability)
    col1 = P.D_h./P.Delta + max(0,u(2:end-1,1));
    col2 = P.D_h./P.Delta - min(0,u(2:end-1,1));
    Kh = assemble_matrix_sparse(col1, col2, P.num_points);
    
    % computing Ke for free electrons (useful for dt for stability)
    col1 = P.D_e./P.Delta + max(0,u(2:end-1,2));
    col2 = P.D_e./P.Delta - min(0,u(2:end-1,2));
    Ke = assemble_matrix_sparse(col1, col2, P.num_points);
    
    % computing the time step (dt) that will be used for all the species (minimum of all)
    den_for_stab(:,1:2) = den_for_stab(:,1:2) + [diag(Kh), diag(Ke)]./P.Delta;
%     if find(den_for_stab<0)
%         error("dt became less than 0")
%     end
    dt = CFL/max(max(den_for_stab(den_for_stab>0)));
    
    % modifying the dt in order to save at the right time instants
    if t_current + dt >= t_goal_next
        save_flag = true;
        dt = t_goal_next - t_current;
        index_time_goal_next = index_time_goal_next + 1;
        if index_time_goal_next > length(P.time_instats)
            exit_flag = true;
        else
            t_goal_next = P.time_instats(index_time_goal_next);
        end
    end
    t_current = t_current + dt;

    % free holes
    n_new(:,1) = n(:,1) - dt*(Kh*n(:,1))./P.Delta + dt*omega(:,1);
    n_new(end,1) = n_new(end,1) + dt*g_schottky(end)/P.Delta;
    
    % free electrons
    n_new(:,2) = n(:,2) - dt*(Ke*n(:,2))./P.Delta + dt*omega(:,2);
    n_new(1,2) = n_new(1,2) + dt*g_schottky(1)/P.Delta;
    
    % trapped holes
    n_new(:,3) = n(:,3) + dt*omega(:,3);
    
    % trapped electrons
    n_new(:,4) = n(:,4) + dt*omega(:,4);

    % at this point n_new contains all the number density at the next time
    % instant, it is used to replace n
    n = n_new;

    if find(n<0)
        error("Number density became less than 0")
    end

end
toc

cd(current_path)
clear current_path

%% GRAPH
[x, x_interfacce, x_interni] = create_x_domain(P.L, P.num_points);

J_cond = compute_J_cond(nh_out, ne_out, E_out, P.D_h, P.D_e, P.mu_h, P.mu_e, P.Delta, P.aT2exp, P.kBT, P.beta, P.e);
dDdt = compute_dDdt(E_out, P.time_instats, P.eps);
J_dDdt = J_cond + dDdt;

J_dDdt_mean = -integral_func(J_dDdt', P.Delta) / P.L;
loglog(P.time_instats, J_dDdt_mean)

% ID(1) = plot(x_interni, ne_out(:,1), 'k-', 'LineWidth', 2);
% hold on
% % ID(2) = plot(x_interni, ne(:,1), 'g--', 'LineWidth', 2);
% pause(1)
% for i = 2:length(P.time_instats)
%     delete(ID)
%     ID(1) = plot(x_interni, ne_out(:,i), 'k-', 'LineWidth', 2);
% %     ID(2) = plot(x_interni, ne(:,i), 'g--', 'LineWidth', 2);
%     pause(0.1)
% end


