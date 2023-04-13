function [out] = RunODE(P, time_instants, options)
% RunODE is the main function
% INPUT
% P -> structure containing all the parameters
% time_instants -> vector containing the time instants where the solution
% will be outputted
% options -> structure containing the options for the simulation
% OUTPUT
% out -> structure containing the various results of the simulation

% Setting initial condition for the number density
n_stato_0 = ones(P.num_points, 4) .* P.n_start;
n_stato_0 = reshape(n_stato_0, [P.num_points*4, 1]);

% Solving with ODE
if ~ exist('options','var')
    options.flag_n = false;
end
[out.tout, out.nout] = ode23tb(@(t,n_stato)OdefuncDriftDiffusion(t, n_stato, P, options), time_instants, n_stato_0, options.ODE_options);

% Post Processing (only if simulation successfully completed)
if length(time_instants) == length(out.tout)
    tic
    [out.x, out.x_interfacce, out.x_interni] = create_x_domain(P.L, P.num_points);
    [out.nh, out.ne, out.nht, out.net, out.rho, out.phi, out.E, out.J, out.J_dDdt] = post_processing(out.nout, out.tout, P, flag_mu);
    out.ppt = toc;
end

end

