function [] = compare_Sato_JdDdt(out)
% COMPARE_SATO_JDDDT Function to compare the current calculated with Sato
% and with J + dD/dt
loglog(out.tout, out.J, 'g-', 'LineWidth', 2, 'DisplayName','Sato')
hold on
loglog(out.tout, out.J_dDdt, 'k--', 'LineWidth', 2, 'DisplayName','J + dD/dt')
grid on
xlabel('time (s)')
ylabel('current density (Am^-^2)')
legend
set(gca, 'FontSize', 15)
end

