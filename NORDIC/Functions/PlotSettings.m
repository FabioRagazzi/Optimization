function [] = PlotSettings(switch_var, fig, ax, line)
% PlotSettings Summary of this function goes here
% INPUT
%
% OUTPUT
%

STYLES = ["-", "--", ":", ".-"];

switch switch_var
%     case "CURRENT"
%         line.LineWidth = 2;
%         line.LineStyle = "-";
%         line.DisplayName = "J + dD/dt";
%         line.Color = [1, 0, 0];
%         ax.YScale = "log";
%         ax.XScale = "log";
%         ax.FontSize = 15;
%         xlabel("time (s)")
%         ylabel("current density (Am^-^2)")
%         title("Polarization Current")
%         legend
%         grid on
    case "CURRENT"
        for i = 1:length(line)
            line(i).LineWidth = 2;
            line(i).LineStyle = STYLES(mod(i,4));
            line(i).DisplayName = "J + dD/dt (" + num2str(i) + ")";
        end
        ax.YScale = "log";
        ax.XScale = "log";
        ax.FontSize = 15;
        xlabel("time (s)")
        ylabel("current density (Am^-^2)")
        title("Polarization Current")
        legend
        grid on
    otherwise
line.LineWidth = 2;
        line.LineStyle = "-";
        line.DisplayName = text("J + dD/dt");
        line.Color = [1, 0, 0];
        ax.YScale = "log";
        ax.XScale = "log";
        xlabel("time (s)")
        ylabel("current density (Am^-^2)")
        title("Polarization Current")
end
end

