%% RANDOM GUESS
clear, clc, close all
n = rand;
nt = rand;
B = rand;
D = rand;
S0 = rand;
S1 = rand;
S2 = rand;
S3 = rand;
Nt = rand;
U = rand;

[eq1, eq2, eq3, eq4] = omega_source(n, nt, B, D, S0, S1, S2, S3, Nt, U);
fprintf('eq1: %f\n', eq1)
fprintf('eq2: %f\n', eq2)
fprintf('eq3: %f\n', eq3)
fprintf('eq4: %f\n', eq4)

%% Demonstration result
clear, clc, close all
S12 = rand;
S0 = rand;
U = rand;
n = rand;
B = rand;
Nt = rand;

% Dependent parameters
S3 = (S12)^2 / S0;
a = S12 / S0; 
nt = sqrt(U/S0) - a*n;
D = (-(B/Nt + S12)*n*nt + B*n - S0*nt^2) / nt;

[eq1, eq2, eq3, eq4] = omega_source(n, nt, B, D, S0, S12, S12, S3, Nt, U);

if (eq1 == 0) && (eq2 == 0) && (eq3 == 0) && (eq4 == 0)
    fprintf("MOLTO BENE\n")
end

format long
fprintf('eq1: \n')
disp(eq1)
fprintf('eq2: \n')
disp(eq2)
fprintf('eq3: \n')
disp(eq3)
fprintf('eq4: \n')
disp(eq4)
format short
