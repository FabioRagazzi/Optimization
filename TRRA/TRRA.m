%% FIT PARABOLA CON LSQNONLIN
clc, clear variables
current_path = pwd();
cd('C:\Users\Faz98\Documents\GitHub\Optimization\TRRA')
addpath('Functions\')
lb = [-1e3, -1e3, -1e3];
ub = [1e3, 1e3, 1e3];
x0 = [1e3, 1e3, 1e3];
t = linspace(0,10,20);
fun = @(p) (p(1)*t.^2 + p(2)*t + p(3)) - (537*t.^2-489*t-31);
options = optimoptions('lsqnonlin', 'Display','iter');
[x,~,~,~,output] = lsqnonlin(fun, x0, lb, ub, options); 
cd(current_path)