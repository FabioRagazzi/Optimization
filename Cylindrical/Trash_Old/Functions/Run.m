function [out] = Run(parameters, time_instants, options)
% Run Summary of this function goes here
%   Detailed explanation goes here
arguments
    parameters char {mustBeMember(parameters,{'A','B','C'})} 
    time_instants
    options.geometry char {mustBeMember(options.geometry,{'cartesian','cylindrical'})} = 'cartesian';
    options.electrodes char {mustBeMember(options.electrodes,{'block','free'})} = 'block';
    options.source char {mustBeMember(options.source,{'on','off'})} = 'on';
end
% Creating parameters
P = ParametersFunction(parameters);

% Setting initial condition for the number density
n_stato_0 = ones(P.np, 4) .* P.n_start;
n_stato_0 = reshape(n_stato_0, [P.np*4, 1]);

% Solving with ode23tb
start_time_ODE = tic;
[out.tout, out.nout] = ode23tb(@(t,n_stato)OdeFuncDD(t, n_stato, P, options), time_instants, n_stato_0);
out.wct = toc(start_time_ODE);

% Post processing
start_time_Post_Processing = tic;
if length(out.tout) == length(time_instants)
    [out.nh, out.ne, out.nht, out.net, out.rho, out.phi, out.E, out.J_Sato, out.J_dDdt] = PostProcessing(out.nout, out.tout, P, options);
end
out.ppt = toc(start_time_Post_Processing);

end
