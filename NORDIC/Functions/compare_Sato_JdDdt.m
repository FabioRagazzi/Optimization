function [] = compare_Sato_JdDdt(out, fit_objective)
% COMPARE_SATO_JDDDT Function to compare the current calculated with Sato
% and with J + dD/dt (optionally also compares to a fit objective)
loglog(out.tout, out.J, 'g-', 'LineWidth', 2, 'DisplayName','Sato')
hold on
loglog(out.tout, out.J_dDdt, 'k--', 'LineWidth', 2, 'DisplayName','J + dD/dt')
if exist('fit_objective','var')
  loglog(out.tout, fit_objective, 'r.', 'MarkerSize', 10, 'DisplayName','Objective')
end
grid on
xlabel('time (s)')
ylabel('current density (Am^-^2)')
legend
set(gca, 'FontSize', 15)
end

