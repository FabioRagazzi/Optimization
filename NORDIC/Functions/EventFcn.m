function [values, isterminal, direction] = EventFcn(t, n_state)
% EventFcn is the event function for the ODE solver
% INPUT
% t -> time instant
% n_state -> number density state vector
% OUTPUT
% values -> when there is a zero crossing for values(i) the i-th event occurs
% isterminal -> set to 1 to terminate the integration when the event occurs
% direction -> set to 0 to locate zeros from both directions
values = n_state;
if find(n_state<0)
    warning("Number density became less than 0 at t = " + num2str(t))
end
isterminal = ones(size(values));
direction = zeros(size(values));
end

