function [P] = updateP(P, names, values, exp_lin_flags, array_flags, equals)
%
% updateP is useful to update directly certain fields of a P (parameter)
% structure
%
% P is the original structure
%
% names is an array with strings representing the names of the variables to update
%
% values is a cell array containing the numbers that are going to be stored (scalar or array)
%
% exp_lin_flags is a logical vector containing a 1 if the parameter is an exponent and a 0 if
% the parameter is linear
%
% array_flags is a logical array containing a 1 if the parameter is an
% array and 0 otherwise
%
% equals -> cell array of cell arrays containing the name(str) and index(int) of a
% parameter to duplicate
%
if (length(names) == length(values)) && (length(values) == length(exp_lin_flags))
    dim = length(names);
    for i = 1:dim
        if array_flags(i)
            if exp_lin_flags(i)
                eval("P." + names(i) + " = [" + num2str(10.^values{i}) + "];")
            else
                eval("P." + names(i) + " = [" + num2str(values{i}) + "];")
            end
        else
            if exp_lin_flags(i)
                eval("P." + names(i) + " = " + num2str(10^values{i}) + ";")
            else
                eval("P." + names(i) + " = " + num2str(values{i}) + ";")
            end
        end
    end
    for i = 1:length(equals)
        index = equals{i}{2};
        if exp_lin_flags(i)
            eval("P." + equals{i}{1} + " = " + num2str(10^values{index}) + ";")
        else
            eval("P." + equals{i}{1} + " = " + num2str(values{index}) + ";")
        end
    end
else
    error('The input vectors sizes are not the same')
end
end

