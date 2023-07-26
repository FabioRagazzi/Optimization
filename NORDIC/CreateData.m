%% BLEND
clearvars, clc, close all
blend = load('..\keep_data\BLEND\G1B166C-T60_30_kV-mm.mat');
blend = blend.savemat;
I = blend.curr(6:end);
t = blend.time(7:end);
A = blend.A;
E = blend.E; fprintf('Electric field: %e\n', E)
J = I / A;

t_BLEND_original = t';
J_BLEND_original = J';
% save('..\data\BLEND\Data_BLEND_Original', ...
%     "t_BLEND_original","J_BLEND_original")
save('data\Data_BLEND_Original', ...
    "t_BLEND_original","J_BLEND_original")

J_smooth = smoothdata(J_BLEND_original,'gaussian',3);
t_interp = logspace(log10(t(1)),log10(t(end)),100);
J_interp = interp1(t,J_smooth,t_interp); 
J_interp(end) = J_smooth(end);

Jobjective = J_interp';
time_instants = t_interp';
% save('..\data\BLEND\Data_BLEND', ...
%     "time_instants","Jobjective")
save('data\Data_BLEND', ...
    "time_instants","Jobjective")

%% SGI
clearvars, clc, close all
sgi = load('..\keep_data\BLEND\166_testSGI_full_T30_20V-mm_5.9715e-16_S-m.mat');
sgi = sgi.savemat;
I = sgi.Current(5:end);
t = sgi.Time(5:end);
A = sgi.Area;
L = sgi.Thickness;
dV = sgi.Voltage;
E = dV/L; fprintf('Electric field: %f\n', E)
J = I / A;

t_SGI_original = t';
J_SGI_original = J';
% save('..\data\BLEND\Data_SGI_Original', ...
%     "t_SGI_original","J_SGI_original")
save('data\Data_SGI_Original', ...
    "t_SGI_original","J_SGI_original")

J_smooth = smoothdata(J_SGI_original,'movmean',1);
t_interp = logspace(log10(t(1)),log10(t(end)),100);
J_interp = interp1(t,J_smooth,t_interp); 
J_interp(1) = J_smooth(1);
J_interp(end) = J_smooth(end);

Jobjective = J_interp';
time_instants = t_interp';
% save('..\data\BLEND\Data_SGI', ...
%     "time_instants","Jobjective")
save('data\Data_SGI', ...
    "time_instants","Jobjective")

%% XLPE
clearvars, clc, close all
xlpe = load('..\keep_data\XLPE-PP\XLPE_T90_30kV-mm_4.9413e-14_S-m.mat');
xlpe = xlpe.savemat;
I = xlpe.Current(5:end);
t = xlpe.Time(5:end);
A = xlpe.Area;
L = xlpe.Thickness;
dV = xlpe.Voltage;
E = dV/L; fprintf('Electric field: %f\n', E)
J = I / A;

t_XLPE_original = t';
J_XLPE_original = J';
% save('..\data\XLPE-PP\Data_XLPE_Original', ...
%     "t_XLPE_original","J_XLPE_original")
save('data\Data_XLPE_Original', ...
    "t_XLPE_original","J_XLPE_original")

J_smooth = smoothdata(J_XLPE_original,'gaussian',10);
t_interp = logspace(log10(t(1)),log10(t(end)),100);
J_interp = interp1(t,J_smooth,t_interp); 
J_interp(end) = J_smooth(end);

Jobjective = J_interp';
time_instants = t_interp';
% save('..\data\XLPE-PP\Data_XLPE', ...
%     "time_instants","Jobjective")
save('data\Data_XLPE', ...
    "time_instants","Jobjective")

%% PP
clearvars, clc, close all
pp = load("..\keep_data\XLPE-PP\PP_T90_30kV-mm_3.1744e-13_S-m.mat");
pp = pp.savemat;
I = pp.Current(5:end);
t = pp.Time(5:end);
A = pp.Area;
L = pp.Thickness;
dV = pp.Voltage;
E = dV/L; fprintf('Electric field: %f\n', E)
J = I / A;

t_PP_original = t';
J_PP_original = J';
% save('..\data\XLPE-PP\Data_PP_Original', ...
%     "t_PP_original","J_PP_original")
save('data\Data_PP_Original', ...
    "t_PP_original","J_PP_original")

J_smooth = smoothdata(J_PP_original,'gaussian',10);
t_interp = logspace(log10(t(1)),log10(t(end)),100);
J_interp = interp1(t,J_smooth,t_interp); 
J_interp(end) = J_smooth(end);

Jobjective = J_interp';
time_instants = t_interp';
% save('..\data\XLPE-PP\Data_PP', ...
%     "time_instants","Jobjective")
save('data\Data_PP', ...
    "time_instants","Jobjective")
