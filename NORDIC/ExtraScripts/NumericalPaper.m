%% FULL EXPLICIT VS ODE (FIGURE)
clearvars, clc, close all
addpath('Functions\')

fig1 = figure();
ax1 = axes(fig1);

% cd('C:\Users\Faz98\Documents\GitHub\Optimization\Full_Esplicito_Nordic')
% EXPLICIT_Nordic;
% cd('C:\Users\Faz98\Documents\GitHub\Optimization\NORDIC');
% load("data\explicit_cfl_1.mat")
load("data\explicit_cfl_01.mat")
loglog(ax1, time_instants, J_dDdt_mean, 'LineWidth',2, 'LineStyle',':', 'DisplayName','Explicit')

PARAMETER_ID_NAME = "NORDIC_STANDARD"; ParametersScript;
time_instants = [0, logspace(0, 5, 99)];
[options] = DefaultOptions();
options.flagMu = 1;
options.flagB = 1;
options.flagD = 1;
options.flagS = 1;

ftime = @() RunODE(P, time_instants, options);
[out] = RunODE(P, time_instants, options);

[err_max, index_max] = max(abs((J_dDdt_mean - out.J_dDdt)./(out.J_dDdt)));
fprintf("Massimo errore percentuale: %d % \n\n", err_max)
fprintf("\nTempo corrispondente all'errore percentuale massimo: %d % \n\n", out.tout(index_max))

padx = 20;
pady = 2e-6;
x_max = out.tout(index_max); 
y_max = out.J_dDdt(index_max);

% explicit_nordic_plot.LineStyle = "-";
% explicit_nordic_plot.Marker = "none";
% explicit_nordic_plot.LineWidth = 2;
% explicit_nordic_plot.Color = [0, 0.4470, 0.7410];
hold on
plot(ax1, out.tout, out.J_dDdt, 'LineWidth',2, 'DisplayName','ODE MATLAB')
grid on
title('Polarization current', 'Interpreter','latex')
xlabel('time (s)', 'Interpreter','latex')
ylabel('current density ($\frac{A}{m^2}$)', 'Interpreter','latex')
legend('Interpreter','latex')
xticks(10.^[0 1 2 3 4 5])
set(gca, 'FontSize', 15)

rectangle('Position', [x_max-padx/2, y_max-pady/2, padx, pady])

ax2_x = 0.45;
ax2_y = 0.45;
ax2_dx = 0.2; 
ax2_dy = 0.25;
ax2 = axes(fig1, 'Position',[ax2_x, ax2_y, ax2_dx, ax2_dy]);
loglog(ax2, time_instants, J_dDdt_mean, 'LineWidth',2, 'LineStyle',':', 'DisplayName','Explicit')
hold on
plot(ax2, out.tout, out.J_dDdt, 'LineWidth',2, 'DisplayName','ODE MATLAB')
xlim([x_max-padx/2, x_max+padx/2])
ylim([y_max-pady/2, y_max+pady/2])
box on
grid on
set(gca,'FontSize',15)

[x_norm, y_norm] = CoordToNormal(ax1, x_max+padx/2, y_max+pady/2);
annotation('arrow', [ax2_x,x_norm], [ax2_y,y_norm])

% timeit(ftime)
%%
exportgraphics(fig1, 'data\PaperNumericalFigures\EXP_vs_ODE.eps')

%% KOREN VS UPWIND POLARIZATION CURRENT AND NUMBER DENSITY (FIGURE)
clearvars, clc, close all
addpath('Functions\')

PARAMETER_ID_NAME = "FULL_NORDIC_FIT_WITH_PS"; ParametersScript;
time_instants = [0, logspace(0, 5, 99)];
[options] = DefaultOptions();
options.flagMu = 1;
options.flagB = 1;
options.flagD = 1;
options.flagS = 1;
options.max_time = 20;
f1 = @()RunODE(P, time_instants, options);
[out1] = RunODE(P, time_instants, options);

options.flux_scheme = "Koren";
f2 = @()RunODE(P, time_instants, options);
[out2] = RunODE(P, time_instants, options);

%% SATO
fig1 = figure();
ax1 = axes(fig1);
loglog(ax1, out1.tout, out1.J_dDdt, '.', 'LineWidth',2, 'DisplayName','$J + \frac{\partial D}{\partial t}$', 'MarkerSize',15)
hold on
loglog(ax1, out1.tout, out1.J_Sato, '-',  'LineWidth',2, 'DisplayName','Sato')
grid on
xticks(10.^[0 1 2 3 4 5])
xlabel('time (s)', 'Interpreter','latex')
ylabel('current density ($\frac{A}{m^2}$)', 'Interpreter','latex')
title('Polarization current', 'Interpreter','latex')
legend('Interpreter','latex')
set(gca,'FontSize',15)

rx1 = 200;
rx2 = 300;
ry1 = 1.25e-6;
ry2 = 1.5e-6;

axx = 0.65;
axy = 0.45;
axdx = 0.15;
axdy = 0.2;

rectangle('Position', [rx1, ry1, rx2-rx1, ry2-ry1])

ax2 = axes('Position',[axx, axy, axdx, axdy]);
loglog(ax2, out1.tout, out1.J_dDdt, '.', 'LineWidth',2, 'DisplayName','$J + \frac{\partial D}{\partial t}$', 'MarkerSize',15)
hold on
loglog(ax2, out1.tout, out1.J_Sato, '-',  'LineWidth',2, 'DisplayName','Sato')
xlim([rx1,rx2])
ylim([ry1,ry2])
box on
% xticks([rx1,rx2])
% yticks([ry1,ry2])
grid on
set(gca,'FontSize',15)

[x_norm, y_norm] = CoordToNormal(ax1, rx2, ry2);
annotation('arrow', [axx,x_norm], [axy,y_norm])

%%
exportgraphics(fig1, 'data\PaperNumericalFigures\Sato.eps')

%% N
[error_e, ind] = max(sum((out1.ne - out2.ne) ./ out2.ne, 1));
disp(ind)
% ind = 60;
disp(out1.tout(ind))
fig1 = figure();
plot(P.x_int - P.x_int(1), out1.ne(:,ind), '--', 'LineWidth',2, 'DisplayName','Upwind I', 'MarkerSize',25)
hold on
plot(P.x_int - P.x_int(1), out2.ne(:,ind), '-', 'LineWidth',3, 'DisplayName','Koren', 'MarkerSize',8)
grid on
legend('Interpreter','latex')
set(gca,'FontSize',15)
xlim([0, 2e-5])
% xticks([0 1 2 3]*1e-5)
xlabel('x (m)','Interpreter','latex')
ylabel('number density ($\frac{1}{m^3}$)','Interpreter','latex')
title('Electrons','Interpreter','latex')

% [~, ind] = max(sum((out1.nh - out2.nh) ./ out2.nh, 1));
% disp(ind)
% nexttile
% plot(P.x_int, out1.nh(:,ind), '-', 'LineWidth',2, 'DisplayName','Upwind I', 'MarkerSize',20)
% hold on
% plot(P.x_int, out2.nh(:,ind), '-', 'LineWidth',3, 'DisplayName','Koren')
% grid on
% % legend('Location','west')
% set(gca,'FontSize',15)
% xlim([0.9*P.L, P.L])
% xticks([3.2 3.3 3.4 3.5]*1e-4)
% xlabel('x (m)','Interpreter','latex')
% set(gca,'YColor', 'none')
% % ylabel('number density ($\frac{1}{m^3}$)','Interpreter','latex')
% title('Holes','Interpreter','latex')

%%
exportgraphics(fig1, 'data\PaperNumericalFigures\Koren_vs_Upwind_number_density.eps')

%% J
padx = 2.8e4;
pady = 1e-7;
axes2_x0 = 0.5;
axes2_y0 = 0.5;
axes2_W = 0.2;
axes2_H = 0.2;

[~, index_max] = max((out1.J_dDdt-out2.J_dDdt)./out2.J_dDdt);
disp(index_max)
x_max = out1.tout(index_max); 
y_max = out1.J_dDdt(index_max);

fig1 = figure();

ax1 = axes(fig1);
loglog(ax1, out1.tout, out1.J_dDdt, '.', 'LineWidth',2, 'DisplayName','Upwind I', 'MarkerSize',20)
hold on
loglog(ax1, out2.tout, out2.J_dDdt, '-', 'LineWidth',3, 'DisplayName','Koren')
title('Polarization current', 'Interpreter','latex')
xlabel('time (s)', 'Interpreter','latex')
ylabel('current density ($\frac{A}{m^2}$)', 'Interpreter','latex')
grid on
xticks(10.^[0 1 2 3 4 5])
set(gca,'FontSize',15)
legend('Interpreter','latex')

%% 
rectangle(ax1,'Position',[x_max-padx/2, y_max-pady/2, padx, pady])

ax2 = axes(fig1,'Position',[axes2_x0, axes2_y0, axes2_W, axes2_W]);
loglog(ax2, out1.tout, out1.J_dDdt, '.', 'LineWidth',2, 'DisplayName','Upwind I', 'MarkerSize',20)
hold on
loglog(ax2, out2.tout, out2.J_dDdt, '-', 'LineWidth',3, 'DisplayName','Koren')
xlim(ax2, [x_max-padx/2, x_max+padx/2])
ylim(ax2, [y_max-pady/2, y_max+pady/2])
grid on
box on
set(gca,'FontSize',15)

[xnorm, ynorm] = CoordToNormal(ax1, x_max-padx/2, y_max+pady/2);
arrow = annotation('arrow',[axes2_x0 + axes2_W, xnorm],[axes2_y0, ynorm]);

%% 
exportgraphics(fig1, 'data\PaperNumericalFigures\Koren_vs_Upwind.eps')

%% UPWIND VS KOREN
clearvars, clc, close all

num_points = 500;
x = zeros(1, num_points);
dx = 1e-3;
x(1) = dx/2;
for i = 2:num_points
    x(i) = x(i-1) + dx;
end
L = dx * num_points;

v = +100;
Vol = dx;
num_save = 3;
shift_val = 1/num_save;
dt = dx * shift_val / abs(v) ;

% Initializing n
n = zeros(num_points, 1);
n(0.2*num_points:0.3*num_points,:) = linspace(0,1e9,0.1*num_points+1);
n(0.3*num_points:0.4*num_points,:) = flip(linspace(0,1e9,0.1*num_points+1));
n(0.6*num_points:0.8*num_points,:) = 1e9;
n_real = n;

ID(1) = plot(x,n);
hold on
ID(2) = plot(x,n_real,'k--');

cont = 0;
for k = 1:num_points * num_save
    cont = cont + 1;
    delete(ID);

    % UPWIND
    if v > 0
        Gamma = [n(end); n] * v; 
    else
        Gamma = [n; n(1)] * v; 
    end

%     % KOREN 1
%     n_add = [n(end-1:end); n; n(1:2)];
%     dn = n_add(2:end) - n_add(1:end-1);
%     if v > 0
%         r = (dn(2:end-1) + 1e-323)./(dn(1:end-2) + 1e-323);
%         gamma_low = n_add(2:end-2) * v; 
%         gamma_high = v * (3*n_add(2:end-2) - n_add(1:end-3)) * 0.5;
%     else
%         r = (dn(2:end-1) + 1e-323)./(dn(3:end) + 1e-323);
%         gamma_low = n_add(3:end-1) * v; 
%         gamma_high = v * (3*n_add(3:end-1) - n_add(4:end)) * 0.5;
%     end
%     PHI = KorenFluxLimiter(r);
%     Gamma = gamma_low - PHI.*(gamma_low - gamma_high);

%     % KOREN 2
%     n_add = [n(end-1:end); n; n(1:2)];
%     dn = n_add(2:end) - n_add(1:end-1);
%     if v > 0
%         Gamma = (n_add(2:end-2) + koren_mlim(dn(2:end-1), dn(1:end-2))) * v;
%     else
%         Gamma = (n_add(3:end-1) - koren_mlim(dn(2:end-1), dn(3:end))) * v;
%     end

%     % KOREN 3
%     Upos = v>0;
%     uneg = ~Upos;
%     Umax = v .* Upos;
%     umin = v .* uneg;
%     n_add = [n(end-1:end); n; n(1:2)];
%     dn = n_add(2:end) - n_add(1:end-1);
%     dn_to_koren = Upos.*dn(1:end-2) + uneg.*dn(3:end);
%     koren_computed = koren_mlim(dn(2:end-1), dn_to_koren);
%     Gamma = Umax.*(n_add(2:end-2) + koren_computed) +...
%             umin.*(n_add(3:end-1) - koren_computed);

    Gamma_close = Gamma(2:end) - Gamma(1:end-1);  
    n = n - dt * Gamma_close ./ Vol;
    if mod(cont,num_save) == 0
        n_real = shift_circular(n_real, sign(v), num_points);
    end
    ID(1) = plot(x,n,'b');
    ID(2) = plot(x,n_real,'k--');
    pause(0.01)
end

%% DOMAIN (FIGURE)
L = 0;
U = 5;
xp = [1, 2, 3, 4];
offset_x = -0.15;
offset_y = 0.42;
offset_x2 = -0.18;
offset_y2 = 1.3;

fig1 = figure();
ax1 = axes(fig1);
hold on
for i = 1:length(xp)
    plot(xp(i), 0, 'k.', 'MarkerSize',25)
    eval("text(xp(i)+offset_x, offset_y, '$n_{i " + my_num2str(i-2) +"}$', 'Interpreter','latex', 'FontSize',15);")
end
for i = 1:length(xp)
    plot([xp(i), xp(i)]-0.5, [-1,1], 'k--', 'LineWidth',0.5)
end
plot([xp(i), xp(i)]+0.5, [-1,1], 'k--', 'LineWidth',0.5)
plot([L,U],[0,0],'k','LineWidth',0.2)
xlim([L, U])
ylim([-1, 1]*4)

text((L + U)/2 + offset_x2, offset_y2, '$i + \frac{1}{2}$', 'Interpreter','latex', 'FontSize',12);

set(gca, 'Visible', 'off')

exportgraphics(ax1, 'data\PaperNumericalFigures\domain.eps')

%% KOREN GRAPH (FIGURE)
low_lim = -0.5;
up_lim = 3;
lim1 = [-0.5, 0];
lim2 = [-0, 0.25];
lim3 = [0.25, 2.5];
lim4 = [2.5, 3];
num = 200;

col_array = ["#7E2F8E", "#0072BD", "#D95319", "#7E2F8E"];
style_array = ["-", "-", "-", "-"];

r1 = linspace(lim1(1), lim1(2), num);
r2 = linspace(lim2(1), lim2(2), num);
r3 = linspace(lim3(1), lim3(2), num);
r4 = linspace(lim4(1), lim4(2), num);


% r = linspace(low_lim, up_lim, 200);
phi = @(r) max(0, min(2*r, min(2, (1+2*r)/3)));
% f1 = @(x) 2/3*x + 1/3;
% f2 = @(x) 2*x;

% plot(r, f1(r), 'r:')
% hold on
% plot(r, f2(r), 'b:')
fig1 = figure();
ax1 = axes(fig1);
hold on
for i = 1:4
    eval("plot(ax1, r" + num2str(i) + ", phi(r" + num2str(i) + "), 'LineWidth',3," + ...
        "'LineStyle', style_array(" + num2str(i) + "), 'Color',col_array(" + num2str(i) + "))")
end
xlim([low_lim, up_lim])
title('Koren Flux Limiter')
xlabel('$r$','interpreter','latex')
xticks(low_lim:0.25:up_lim)
ylabel('$\Phi_{KN}$','interpreter','latex')
grid on
set(gca,'FontSize', 15)

annotation(fig1,'textarrow',[0.334 0.281],[0.309 0.262], 'Interpreter','latex',...
    'String',{'$\Phi_{KN} = 2r$'},'Color',col_array(2), 'TextLineWidth',10, 'FontSize',15);

annotation(fig1,'textarrow',[0.411 0.491],[0.666 0.626], 'Interpreter','latex',...
    'String',{'$\Phi_{KN} = \frac{2}{3} r + \frac{1}{3}$'}, 'Color',col_array(3), 'TextLineWidth',10, 'FontSize',15);

exportgraphics(fig1, 'data\PaperNumericalFigures\koren.eps')

%% FUNCTIONS

function str = my_num2str(n)
    if n == 0
        str = "";
    elseif n > 0
        str = "+" + num2str(n);
    elseif n < 0
        str = num2str(n);
    end
end

function [PHI] = KorenFluxLimiter(r)
    m1 = min( (1 + 2 * r) / 3,  2);
    PHI = max(0, min(2*r,m1));
end

function [x_shifted] = shift_circular(x, shift_val, dim_x)
if shift_val > 0
    piece1 = x(1:dim_x-shift_val);
    piece2 = x(dim_x-shift_val+1:end);
else
    piece1 = x(1:-shift_val);
    piece2 = x(-shift_val+1:end);
end
x_shifted = [piece2; piece1];
end

function [bphi] = koren_mlim(a,b)
aa = a.*a;
ab = a.*b;
sixth = 1/6;
bphi = b;

indici = find((aa-2.5*ab)<=0);
bphi(indici) = sixth * (b(indici) + 2*a(indici));

indici = find((aa-0.25*ab)<=0);
bphi(indici) = a(indici);

bphi(ab<=0) = 0;
end
