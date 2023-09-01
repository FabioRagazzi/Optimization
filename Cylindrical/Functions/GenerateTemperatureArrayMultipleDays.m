function [output_temperature] = GenerateTemperatureArrayMultipleDays(important_temperatures, days_number)
% GenerateTemperatureArrayMultipleDay Summary of this function goes here
%   Detailed explanation goes here
important_temperatures_repeat = important_temperatures(2:end);
L_important = length(important_temperatures);
l_repeat = length(important_temperatures_repeat);
output_temperature = zeros(1, L_important + l_repeat*(days_number-1));
output_temperature(1:L_important) = important_temperatures;
for i = 1:days_number-1
    output_temperature(L_important+(i-1)*l_repeat+1:L_important+i*l_repeat) = important_temperatures_repeat;
end

end
