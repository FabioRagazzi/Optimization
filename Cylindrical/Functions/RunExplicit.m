function [out] = RunExplicit(parameters, time_instants, options)
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

out.tout = time_instants';
out.nout = zeros(length(time_instants), P.geo.np*4);

n_stato = n_stato_0;
out.nout(1,:) = n_stato';
for k = 2:length(time_instants)

    n = reshape(n_stato, [], 4);
    rho = sum(n.*[1, -1, 1, -1],2) * P.e;
    phi = SolveEletStat(P.EletStat, rho, P.Phi_W, P.Phi_E);
    E = ComputeE(P.geo, phi, P.Phi_W, P.Phi_E);
    [T_int, T] = GetTemperature(time_instants(k-1), P.Tstruct, P.geo);
    P = TemperatureParameters(P, T_int, T);
    
    arg_sinh_E = P.arg_sinh .* E;
    mu = P.ext_mult_sinh .* sinh(arg_sinh_E) ./ E;
    mu([1,end],:) = 0; % charge blocking electrodes
    u = E .* mu .* [1 -1];
    K = P.kBT_int .* mu / P.e;
    % u_center = (u(1:end-1,:) + u(2:end,:)) / 2;
    B = ones(P.geo.np, 2) .* [0.2, 0.1]; % B = P.B0 + P.mult_B .* abs(u_center);
    % arg_sinh_E_center = (arg_sinh_E(1:end-1,:) + arg_sinh_E(2:end,:)) / 2;
    D = P.add_D; % D = P.mult_D .* sinh(abs(arg_sinh_E_center)) + P.add_D;
    mu_center = (mu(1:end-1,:) + mu(2:end,:)) / 2;
    S = P.S_base + mu_center * [0, 0, 1, 1; 0, 1, 0, 1] * P.mult_S;
    Inj = P.aT2exp .* ( exp( P.beta*sqrt( abs(E([end,1])) )./P.kBT_int([end,1]) ) - 1 );
    [~, Gamma] = Fluxes(n(:,1:2), u, K, P.geo, Inj(2), Inj(1));
    dndt = Omega(n, P.Ndeep, B, D, S, options);
    dndt(1:2*P.geo.np) = dndt(1:2*P.geo.np) - Gamma;

    n_stato = n_stato + dndt * (time_instants(k) - time_instants(k-1));
    out.nout(k,:) = n_stato';
end
    
% Post processing
start_time_Post_Processing = tic;
if length(out.tout) == length(time_instants)
    [out.nh, out.ne, out.nht, out.net, out.rho, out.phi, out.E, out.J_Sato] = PostProcessing(out.nout, out.tout, P);
end
out.ppt = toc(start_time_Post_Processing);
out.P = P;

end
