function [] = CompareSatoJdDdt(out, fit_objective, time_objective)
% CompareSatoJdDdt is used to compare polarization current results (Sato and J + dDdt)
% INPUT
% out -> structure containing the output of a simulation
% fit_objective -> (optional) extra current values to plot
% time_objective -> (optional) extra time values to plot
% OUTPUT
% [] -> none
loglog(out.tout, out.J_Sato, 'g-', 'LineWidth', 2, 'DisplayName','Sato')
hold on
loglog(out.tout, out.J_dDdt, 'k--', 'LineWidth', 2, 'DisplayName','J + dD/dt')
hold off
if exist('fit_objective','var') && exist('time_objective','var')
    hold on
    loglog(time_objective, fit_objective, 'r.', 'MarkerSize', 10, 'DisplayName','Objective')
    hold off
end
grid on
xlabel('time (s)')
ylabel('current density (Am^-^2)')
legend
set(gca, 'FontSize', 15)
end
