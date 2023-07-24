function [values, isterminal, direction] = EventFcn(t, n_state, start_time, max_time)
% EventFcn is the event function for the ODE solver
% INPUT
% t -> time instant
% n_state -> number density state vector
% OUTPUT
% values -> when there is a zero crossing for values(i) the i-th event occurs
% isterminal -> set to 1 to terminate the integration when the event occurs
% direction -> set to 0 to locate zeros from both directions

% uncomment this to disable the event function
% values = 1;

% comment this to disable event function
dim = size(n_state,1) + 1;
values = zeros(dim,1);
values(1:dim-1) = n_state; 
values(dim) = toc(start_time)<max_time;

% set all the events to terminal and with zero crossing from both sides
isterminal = ones(dim,1);
direction = zeros(dim,1);
end

