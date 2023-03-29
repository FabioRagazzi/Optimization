function [out] = NordicODE(Parameters, time_instants, E_flags, ODE_options)

% Setting initial condition for the number density
n_stato_0 = ones(Parameters.num_points, 4) .* Parameters.n_start;
n_stato_0 = reshape(n_stato_0, [Parameters.num_points*4, 1]);

% Setting the flags for the electric field dependency
flag_mu = E_flags(1); % set to true to have a mobility dependent on the electric field
flag_B = E_flags(2); % set to true to have a trapping coefficient dependent on the electric field
flag_D = E_flags(3); % set to true to have a detrapping coefficient dependent on the electric field
flag_S = E_flags(4); % set to true to have the recombination coefficients dependent on the electric field

% Solving with ODE
tic
[out.tout, out.nout] = ode23tb(@(t,n_stato)odefunc_Drift_Diffusion_NM(t, n_stato, Parameters, flag_mu, flag_B, flag_D, flag_S), time_instants, n_stato_0, ODE_options);
out.wct = toc;

% Post Processing
tic
[out.x, out.x_interfacce, out.x_interni] = create_x_domain(Parameters.L, Parameters.num_points);
[out.nh, out.ne, out.nht, out.net, out.rho, out.phi, out.E, out.J, out.J_dDdt] = post_processing(out.nout, out.tout, Parameters, flag_mu);
out.ppt = toc;

end

