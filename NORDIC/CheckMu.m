clearvars, clc, close all
addpath('Functions\')
m = "SGI";
t = "Doedens";
a = "PS";
s = "No";
[result1, out1] = GeneralDispResults(m, a, t, s);
m = "SGI";
t = "LeRoy";
a = "PS";
s = "No";
[result2, out2] = GeneralDispResults(m, a, t, s);

%%
close all
fig = figure();
ax = axes(fig);
surf(ax, 100*(out1.mu_h-out2.mu_h)./out2.mu_h)

%%
Compare(out1, out2, 5)

%%
Movie(out1, out2, "e")

%%
function [] = Compare(out1, out2, i)
    tiledlayout(1,2)
    nexttile
    plot(out1.mu_h(:,i), 'DisplayName','Doedens')
    hold on
    plot(out2.mu_h(:,i), 'DisplayName','LeRoy')
    title("mu_h")
    legend
    nexttile
    plot(out1.mu_e(:,i), 'DisplayName','Doedens')
    hold on
    plot(out2.mu_e(:,i), 'DisplayName','LeRoy')
    title("mu_e")
    legend
end

function [] = Movie(out1, out2, flag)
    c1 = [1 0 0];
    c2 = [0 0 1];
    eval("id1 = plot(out1.mu_" + flag +"(:,1), 'Color',c1, 'DisplayName','Doedens');")
    hold on
    eval("id2 = plot(out2.mu_" + flag +"(:,1), 'Color',c2, 'DisplayName','LeRoy');")
    legend
    pause(1)
    for k = 2:size(out1.mu_h,2)
        delete(id1)
        delete(id2)
        eval("id1 = plot(out1.mu_" + flag +"(:,k), 'Color',c1, 'DisplayName','Doedens');")
        eval("id2 = plot(out2.mu_" + flag +"(:,k), 'Color',c2, 'DisplayName','LeRoy');")
        pause(0.1)
    end
end
