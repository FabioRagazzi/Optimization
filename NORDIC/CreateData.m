%% XLPE
clearvars, clc, close all
xlpe = load('..\data\XLPE-PP\XLPE_T90_30kV-mm_4.9413e-14_S-m.mat');
xlpe = xlpe.savemat;
I = xlpe.Current(5:end);
t = xlpe.Time(5:end);
A = xlpe.Area;
L = xlpe.Thickness;
dV = xlpe.Voltage;
E = dV/L; fprintf('Electric field: %f\n', E)
J = I / A;

t_XLPE_original = t;
J_XLPE_original = J;
save('..\data\XLPE-PP\Data_XLPE_Original', ...
    "t_XLPE_original","J_XLPE_original")
save('data\Data_XLPE_Original', ...
    "t_XLPE_original","J_XLPE_original")

J_smooth = smoothdata(J_XLPE_original,'gaussian',10);
t_interp = logspace(log10(t(1)),log10(t(end)),100);
J_interp = interp1(t,J_smooth,t_interp); 
J_interp(end) = J_smooth(end);

Jobjective = J_interp;
time_instants = t_interp;
save('..\data\XLPE-PP\Data_XLPE', ...
    "time_instants","Jobjective")
save('data\Data_XLPE', ...
    "time_instants","Jobjective")

%% PP
clearvars, clc, close all
pp = load("..\data\XLPE-PP\PP_T90_30kV-mm_3.1744e-13_S-m.mat");
pp = pp.savemat;
I = pp.Current(5:end);
t = pp.Time(5:end);
A = pp.Area;
L = pp.Thickness;
dV = pp.Voltage;
E = dV/L; fprintf('Electric field: %f\n', E)
J = I / A;

t_PP_original = t;
J_PP_original = J;
save('..\data\XLPE-PP\Data_PP_Original', ...
    "t_PP_original","J_PP_original")
save('data\Data_PP_Original', ...
    "t_PP_original","J_PP_original")

J_smooth = smoothdata(J_PP_original,'gaussian',10);
t_interp = logspace(log10(t(1)),log10(t(end)),100);
J_interp = interp1(t,J_smooth,t_interp); 
J_interp(end) = J_smooth(end);

Jobjective = J_interp;
time_instants = t_interp;
save('..\data\XLPE-PP\Data_PP', ...
    "time_instants","Jobjective")
save('data\Data_PP', ...
    "time_instants","Jobjective")
