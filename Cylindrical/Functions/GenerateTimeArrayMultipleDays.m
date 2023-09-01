function [output_time] = GenerateTimeArrayMultipleDays(important_time_instants, days_number)
% GenerateTimeArrayMultipleDays Summary of this function goes here
%   Detailed explanation goes here
important_time_instants_no_zero = important_time_instants(2:end);
L_important = length(important_time_instants);
l_repeat = length(important_time_instants_no_zero);
output_time = zeros(L_important + l_repeat*(days_number-1), 1);
output_time(1:L_important) = important_time_instants;
for i = 1:days_number-1
    output_time(L_important+(i-1)*l_repeat+1:L_important+i*l_repeat) = important_time_instants_no_zero + 24*i;
end

end
