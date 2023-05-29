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

% solving with ODE
start_time_ODE = tic;
options.ODE_options.Events = @(t,n_state)EventFcn(t, n_state, start_time_ODE, options.max_time);
[out.tout, out.nout, time_event, ~, index_event] = ode23tb(@(t,n_stato)OdefuncDriftDiffusion(t, n_stato, P, options), time_instants, n_stato_0, options.ODE_options);
out.wct = toc(start_time_ODE);

% displaying warning if execution stopped due to event location
if ~isempty(index_event)
    if index_event == 4*P.num_points + 1
        warning("Maximum execution time allowed (" + num2str(options.max_time) + "s) was reached")
    else
        warning("Number density became less than 0 at t = " + num2str(time_event(1)))
    end
end

% post processing
start_time_Post_Processing = tic;
if length(out.tout) == length(time_instants)
    [out.nh, out.ne, out.nht, out.net, out.rho, out.phi, out.E, out.J_Sato, out.J_dDdt] = PostProcessing(out.nout, out.tout, P, options);
end
out.ppt = toc(start_time_Post_Processing);

end
