%% COMPUTE
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

%% DOMAIN
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

%% KOREN GRAPH
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
