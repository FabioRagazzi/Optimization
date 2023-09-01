function [] = GraphTstruct(name, time_instants, ri, ro)
% GraphTstruct Summary of this function goes here
%   Detailed explanation goes here
Tstruct = GetTstructList(name, time_instants(1), time_instants(end), [ri;ro], ri, ro);
geo.x_int = [ri; ro];
geo.x = [ri; ro];

nt = length(time_instants);
T = zeros(2,nt);
for i = 1:nt
    T(:,i) = GetTemperature(time_instants(i), Tstruct, geo);
end

tiledlayout(2,1)
nexttile
plot(time_instants/3600, T(1,:))
title("ri = " + num2str(ri*1000) + " (mm)")
xticks(Tstruct.time/3600)
xlabel("time (h)")
ylabel("Temperature (°C)")
grid on
nexttile
plot(time_instants/3600, T(2,:))
title("ro = " + num2str(ro*1000) + " (mm)")
xticks(Tstruct.time/3600)
xlabel("time (h)")
ylabel("Temperature (°C)")
grid on

end
