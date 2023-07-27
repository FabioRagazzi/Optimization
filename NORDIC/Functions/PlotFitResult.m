function [fig] = PlotFitResult(out, fit_objective, time_objective)
% PlotFitResult Summary of this function goes here
%   Detailed explanation goes here
fig = figure();
ax = axes(fig);
loglog(ax, out.tout, out.J_Sato, 'r.', 'MarkerSize', 15, 'DisplayName','Optimization result')
hold on
loglog(ax, time_objective, fit_objective, 'k-', 'LineWidth', 2, 'DisplayName','Objective')
grid on
legend('Interpreter','latex')
xticks(10.^(0:1:10))
yticks(10.^(-10:1:10))
xlabel('$t (\mathrm{s})$', 'Interpreter','latex')
ylabel('$J (\mathrm{\frac{A}{m^2}})$', 'Interpreter','latex')
set(gca,'TickLabelInterpreter','latex', 'Xscale','log', 'Yscale','log', 'FontSize',15)

end
