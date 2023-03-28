%% SOLVE FULL EXPLICIT
clear, clc
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\Full_Esplicito_Nordic')
addpath("Functions\")
fprintf("-> SOLVE FULL EXPLICIT NORDIC\n")

% loading the parameters for the simulation
load('Parameters\inbox.mat')

% defining the time instants for the simulation
time_instants = [0, logspace(0, 5, 99)];

% specifying the flags and CFL
flag_mu = false;
flag_B = false;
flag_D = false;
flag_S = false;
CFL = 0.5;

% output variables definition
nh_out = zeros(P.num_points, length(time_instants));
ne_out = zeros(P.num_points, length(time_instants));
nht_out = zeros(P.num_points, length(time_instants));
net_out = zeros(P.num_points, length(time_instants));
rho_out = zeros(P.num_points, length(time_instants));
phi_out = zeros(P.num_points+2, length(time_instants));
E_out = zeros(P.num_points+1, length(time_instants));
mu_out = zeros(P.num_points+1, length(time_instants), 2);
B_out = zeros(P.num_points, length(time_instants), 2);
D_out = zeros(P.num_points, length(time_instants), 2);
S_out = zeros(P.num_points, length(time_instants), 4);
Diff_out = zeros(P.num_points-1, length(time_instants), 2);

% setting initial condition
exit_flag = false;
save_flag = true;
save_index = 1;
n = ones(P.num_points, 4) .* P.n_start;
n_new = zeros(size(n));
t_current = time_instants(1);
index_time_goal_next = 2;
t_goal_next = time_instants(2);

% starting the loop
tic
while true

    % at this point the number density of all the species at the current time
    % instant are known, we can therefore calculate the charge density, 
    % electric potential and electric field relative to the current time
    % instant:
    rho = sum(n.*[1, -1, 1, -1], 2) * P.e;
    phi = Electrostatic(rho, P.coeff, P.Phi_W, P.Phi_E, P.Kelet); 
    E = Electric_Field(phi, P.Delta, P.Phi_W, P.Phi_E);

    % Compute mobility based on the relative flag
    if flag_mu
        [mu_h, mu_e] = Mobility(E, P.ext_mult_sinh, P.arg_sinh);
        mu = [mu_h, mu_e];
    else
        mu = [P.mu_h, P.mu_e] .* ones(size(E));
    end

    % Compute drift velocity 
    u = E .* mu .* [1 -1];

    % Compute trapping coefficient based on the relative flag
    u_center = (u(1:end-1,:) + u(2:end,:)) / 2;
    if flag_B
        B = P.B0 + P.mult_B .* u_center;
    else
        B = [P.Bh, P.Be] .* ones(size(E,1)-1, size(E,2));
    end
    
    % Compute detrapping coefficient based on the relative flag
    E_center = (E(1:end-1,:) + E(2:end,:)) / 2;
    if flag_D
        D = P.mult_D .* sinh(E_center .* P.arg_sinh) + P.add_D;
    else
        D = [P.Dh, P.De] .* ones(size(E,1)-1, size(E,2));
    end
    
    % Compute recombination coefficients based on the relative flag
    mu_center = (mu(1:end-1,:) + mu(2:end,:)) / 2;
    if flag_S
        S = mu_center * [0, 0, 1, 1; 0, 1, 0, 1] * P.mult_S;
        S = S + P.S_base;
    else
        S = [P.S0, P.S1, P.S2, P.S3] .* ones(size(E,1)-1, size(E,2));
    end
    
    % Compite diffusion coefficients with Einstein relation
    Diff = mu * P.kBT / P.e;
    
    % saving the values if the "save_flag" is "true"
    if save_flag
        nh_out(:,save_index) = n(:,1);
        ne_out(:,save_index) = n(:,2);
        nht_out(:,save_index) = n(:,3);
        net_out(:,save_index) = n(:,4);
        rho_out(:,save_index) = rho;
        phi_out(:,save_index) = [P.Phi_W; phi; P.Phi_E];
        E_out(:,save_index) = E;
        mu_out(:,save_index,:) = mu;
        B_out(:,save_index,:) = B;
        D_out(:,save_index,:) = D;
        S_out(:,save_index,:) = S;
        Diff_out(:,save_index,:) = Diff(2:end-1,:);
        save_index = save_index + 1;
        save_flag = false;
    end
    
    % exit the loop if we reached the last time instant
    if exit_flag
        break
    end

    % if we didn't exit the loop and this point has been reached we start
    % the computation of the number density at the next time instant:

    % source terms contributions (omega has a column for each kind of
    % species) and also denominator contributions for dt for stability
    [omega, den_for_stab] = Omega_and_stability(n, P.N_deep, B, D, S);

    % injection from electrodes (g_schottky has two values, one for the left
    % electrode and one for the right electrode)
    g_schottky = Schottky([E(1), E(end)], P.aT2exp, P.kBT, P.beta);

    % computing Kh for free holes (useful for dt for stability)
    col1 = Diff(2:end-1,1)./P.Delta + max(0,u(2:end-1,1));
    col2 = Diff(2:end-1,1)./P.Delta - min(0,u(2:end-1,1));
    Kh = assemble_matrix_sparse(col1, col2, P.num_points);
    
    % computing Ke for free electrons (useful for dt for stability)
    col1 = Diff(2:end-1,2)./P.Delta + max(0,u(2:end-1,2));
    col2 = Diff(2:end-1,2)./P.Delta - min(0,u(2:end-1,2));
    Ke = assemble_matrix_sparse(col1, col2, P.num_points);
    
    % computing the time step (dt) that will be used for all the species (minimum of all)
    den_for_stab(:,1:2) = den_for_stab(:,1:2) + [diag(Kh), diag(Ke)]./P.Delta;
    if find(den_for_stab<0)
        error("dt became less than 0")
    end
    dt = CFL/max(max(den_for_stab(den_for_stab>0)));
    
    % modifying the dt in order to save at the right time instants
    if t_current + dt >= t_goal_next
        save_flag = true;
        dt = t_goal_next - t_current;
        index_time_goal_next = index_time_goal_next + 1;
        if index_time_goal_next > length(time_instants)
            exit_flag = true;
        else
            t_goal_next = time_instants(index_time_goal_next);
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

rmpath("Functions\")
cd(current_path)
clear current_path

%% GRAPH
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\Full_Esplicito_Nordic\')
addpath("Functions\")

[x, x_interfacce, x_interni] = create_x_domain(P.L, P.num_points);

J_cond = compute_J_cond(nh_out, ne_out, E_out, Diff_out(:,:,1), Diff_out(:,:,2), mu_out(:,:,1), mu_out(:,:,2), P.Delta, P.aT2exp, P.kBT, P.beta, P.e);
dDdt = compute_dDdt(E_out, time_instants, P.eps);
J_dDdt = J_cond + dDdt;

J_dDdt_mean = -integral_func(J_dDdt', P.Delta) / P.L;

% Plot polarization current
interpreter = 'tex';
loglog(time_instants, J_dDdt_mean, 'g-', 'LineWidth',2)
% hold on
% loglog(time_instants, J, 'k--', 'LineWidth',2)
grid on
title('Polarization Current', 'Interpreter',interpreter)
xlabel('Time (s)','Interpreter',interpreter)
ylabel('Current Density (A/m^2)', 'Interpreter',interpreter)
set(gca,'FontSize',15)

% ID(1) = plot(x_interni, ne_out(:,1), 'k-', 'LineWidth', 2);
% hold on
% % ID(2) = plot(x_interni, ne(:,1), 'g--', 'LineWidth', 2);
% pause(1)
% for i = 2:length(time_instants)
%     delete(ID)
%     ID(1) = plot(x_interni, ne_out(:,i), 'k-', 'LineWidth', 2);
% %     ID(2) = plot(x_interni, ne(:,i), 'g--', 'LineWidth', 2);
%     pause(0.1)
% end

rmpath("Functions\")
cd(current_path)
clear current_path
fprintf("-> GRAPH\n")
