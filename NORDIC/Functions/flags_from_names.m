function [flagT, flagS, flagSbase] = flags_from_names(names)
% flags_from_names Computes the flags used in 'CompleteP'
flagT = false;
flagS = false;
flagSbase = false;
for i = 1:length(names)
    if names(i) == "S0" || names(i) == "S1" || names(i) == "S2" || names(i) == "S3"
        flagS = true;
    elseif names(i) == "T"
        flagT = true;
    elseif names(i) == "S_base(1)" || names(i) == "S_base(2)" || names(i) == "S_base(3)" || names(i) == "S_base(4)" || names(i) == "S_base"
        flagSbase = true;
    end
end
end

