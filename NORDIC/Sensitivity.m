%% PHI
MY_START()
mult_values = [0.98, 0.99, 1, 1.01, 1.02];
SensitivityAnalysis(mult_values, ["phih", "phie"]);

%% MU
MY_START()
mult_values = [0.25, 0.5, 1, 2, 4];
SensitivityAnalysis(mult_values, ["mu_h", "mu_e"]);

%% N0
MY_START()
mult_values = [0.25, 0.5, 1, 2, 4];
SensitivityAnalysis(mult_values, ["n_start(1)", "n_start(2)"]);

%% B
MY_START()
mult_values = [0.25, 0.5, 1, 2, 4];
SensitivityAnalysis(mult_values, ["Bh", "Be"]);

%% D
MY_START()
mult_values = [0.98, 0.99, 1, 1.01, 1.02];
SensitivityAnalysis(mult_values, ["wh", "we"]);

%% S
MY_START()
mult_values = [0.001, 0.01, 1, 100, 200];
SensitivityAnalysis(mult_values, ["S0", "S1", "S2", "S3"]);

%%
function [fig] = SensitivityAnalysis(mult_values, strings)
    
    Ref = ReferenceParameters();
    P = Parameters("TRUE_LE_ROY");

    time_instants = [0, logspace(0,5,59)];
    [options] = DefaultOptions(); options.max_time = 10;
    linestyles = ["-", "--", "none", ":", "-."];
    markerstyles = ["none", "none", ".", "none", "none"];
    
    for i = 1:length(mult_values)
        for s = 1:length(strings)
            eval("P." + strings(s) + " = Ref." + strings(s) + " * mult_values(" + num2str(i) + ");")
        end
        P = CompleteP(P);
        eval("out" + num2str(i) + " = RunODE(P, time_instants, options);")
    end
    
    for i = 1:length(mult_values)
        eval("graph" + num2str(i) + ".LineWidth = 2;")
        eval("graph" + num2str(i) + ".DisplayName = num2str(mult_values(i));")
        eval("graph" + num2str(i) + ".LineStyle = linestyles("+ num2str(i) +");")
        eval("graph" + num2str(i) + ".Marker = markerstyles("+ num2str(i) +");")
        eval("graph" + num2str(i) + ".MarkerSize = 15;")
    end
    
    fig = figure;
    hold on
    for i = 1:length(mult_values)
        eval("loglog(out" + num2str(i) + ".tout, out" + num2str(i) + ".J_dDdt, graph" + num2str(i) + ")")
    end
    legend('Location','northeast', 'Interpreter','latex')
    grid on
    xlabel('$t (\mathrm{s})$', 'Interpreter','latex')
    ylabel('$J (\mathrm{\frac{A}{m^2}})$', 'Interpreter','latex')
    set(gca,'Xscale','log', 'Yscale','log', 'FontSize',15)
end

function [Ref] = ReferenceParameters()
    Ref.phih = 1.16;
    Ref.phie = 1.27;
    Ref.n_start = [1e18, 1e18];
    Ref.Ndeep = ones(100,2) .* [6.2e20, 6.2e20];
    Ref.mu_h = 2e-13;
    Ref.mu_e = 1e-14;
    Ref.Bh = 2e-1;
    Ref.Be = 1e-1;
    Ref.wh = 0.99;
    Ref.we = 0.96;
    Ref.S0 = 6.4e-22;
    Ref.S1 = 6.4e-22;
    Ref.S2 = 6.4e-22;
    Ref.S3 = 0;
end

function [] = MY_START()
    clearvars, clc, close all
    addpath('Functions\')
end
