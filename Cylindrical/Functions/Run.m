function [out] = Run(parameters, time_instants, options)
% Run Summary of this function goes here
%   Detailed explanation goes here
arguments
    parameters char {mustBeMember(parameters,{ ...
        'T_20_200p_refined', ...
        'T_20_500p', ...
        'T_70_500p', ...
        'T_70_55_500p', ...
        'T_20_100p', ...
        'T_70_100p', ...
        'T_70_55_100p', ...
        'T20_new', ...
        'T70_new', ...
        'T70_55_new', ...
        'Trans_1d_lin', ...
        'Trans_5d_lin', ...
        'Trans_1d_exp', ...
        'Trans_5d_exp', ...
        'Trans_5d_TB852'
        })}
    time_instants
end
arguments
    options.coordinates char {mustBeMember(options.coordinates,{'cartesian','cylindrical'})} = 'cartesian'
    options.type char {mustBeMember(options.type,{'sparse','normal'})} = 'normal'
    options.source char {mustBeMember(options.source,{'on','off'})} = 'off'
end

P = ParametersFunction(parameters, time_instants, options);

% Setting initial condition for the number density
n_stato_0 = ones(P.geo.np, 4) .* P.n_start;
n_stato_0 = reshape(n_stato_0, [P.geo.np*4, 1]);

% Solving with ode23tb
start_time_ODE = tic;
[out.tout, out.nout] = ode23tb(@(t,n_stato)OdeFuncDD(t, n_stato, P, options), time_instants, n_stato_0);
% [out.tout, out.nout] = ode23tb(@(t,n_stato)OdeFuncDD(t, n_stato, P, options), time_instants, n_stato_0);
out.wct = toc(start_time_ODE);

% Post processing
start_time_Post_Processing = tic;
if length(out.tout) == length(time_instants)
    [out.nh, out.ne, out.nht, out.net, out.rho, out.phi, out.E, out.J_Sato] = PostProcessing(out.nout, out.tout, P);
end
out.ppt = toc(start_time_Post_Processing);
out.P = P;

end
