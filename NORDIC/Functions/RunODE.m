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

% If options is not provided set default value
if ~ exist('options','var')
    options.flagMu = 0;
    options.flagB = 0;
    options.flagD = 0;
    options.flagS = 0;
    options.flux_scheme = "Upwind";
    options.injection = "Fixed";
    options.source = "Off";
    options.ODE_options = odeset('Stats','off');
end

% Solving with ODE
start_time_ODE = tic;
if isa(options.ODE_options.Events, 'function_handle')
    [out.tout, out.nout, ~, ~, ~] = ode23tb(@(t,n_stato)OdefuncDriftDiffusion(t, n_stato, P, options), time_instants, n_stato_0, options.ODE_options);
else
    [out.tout, out.nout] = ode23tb(@(t,n_stato)OdefuncDriftDiffusion(t, n_stato, P, options), time_instants, n_stato_0, options.ODE_options);
end
out.wct = toc(start_time_ODE);

% Post Processing
start_time_Post_Processing = tic;
if length(out.tout) == length(time_instants)
    [out.nh, out.ne, out.nht, out.net, out.rho, out.phi, out.E, out.J_Sato, out.J_dDdt] = PostProcessing(out.nout, out.tout, P, options);
end
out.ppt = toc(start_time_Post_Processing);
end
