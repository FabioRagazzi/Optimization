%% UPWIND CARTESIAN
my_start()
np = 30;
L = 20;
U = 3;
D = 2;
n0 = 1;
nL = 4;
dx = L / np;
x = dx/2 + linspace(0, L-dx, np);
[M] = Assemble3Diag(ones(1,np-1)*D/dx, "type","sparse");
M(sub2ind([np,np], 1:np, 1:np)) = M(sub2ind([np,np], 1:np, 1:np)) + U;
M(sub2ind([np,np], 2:np, 1:np-1)) = M(sub2ind([np,np], 2:np, 1:np-1)) - U;
% n is fixed at the interface, not at the cell, so:
M(1,1) = 3/2;
M(1,2) = -1/2;
M(end,end) = 3/2;
M(end,end-1) = -1/2;

rhs = zeros(np,1);
rhs(1) = n0;
rhs(end) = nL;

K1 = (nL - n0*exp(U*L/D)) / (1 - exp(U*L/D)); 
K2 = (n0 - nL) / (1 - exp(U*L/D)); 
x_fitto = linspace(0, L, 1000);
n_analytical = @(x) K1 + K2 * exp(U*x/D);

n = M \ rhs;
plot(x,n,'b.','MarkerSize',20)
hold on
plot(x_fitto,n_analytical(x_fitto),'k-')

%% LINEAR INTERPOLATION CARTESIAN
my_start()
np = 30;
L = 20;
U = 3;
D = 2;
n0 = 1;
nL = 4;
dx = L / np;
x = dx/2 + linspace(0, L-dx, np);
[M] = Assemble3Diag(ones(1,np-1)*D/dx, "type","sparse");
M(sub2ind([np,np], 2:np, 1:np-1)) = M(sub2ind([np,np], 2:np, 1:np-1)) - U/2;
M(sub2ind([np,np], 1:np-1, 2:np)) = M(sub2ind([np,np], 1:np-1, 2:np)) + U/2;
% n is fixed at the interface, not at the cell, so:
M(1,1) = 3/2;
M(1,2) = -1/2;
M(end,end) = 3/2;
M(end,end-1) = -1/2;

rhs = zeros(np,1);
rhs(1) = n0;
rhs(end) = nL;

K1 = (nL - n0*exp(U*L/D)) / (1 - exp(U*L/D)); 
K2 = (n0 - nL) / (1 - exp(U*L/D)); 
x_fitto = linspace(0, L, 1000);
n_analytical = @(x) K1 + K2 * exp(U*x/D);

n = M \ rhs;
plot(x,n,'b.','MarkerSize',20)
hold on
plot(x_fitto,n_analytical(x_fitto),'k-')

%%
function [] = my_start()
    addpath("..\Functions\")
    clearvars, clc, close all
end
