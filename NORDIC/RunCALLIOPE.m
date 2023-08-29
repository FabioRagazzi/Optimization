clearvars, clc, close all
rng default
for m = ["BLEND", "PP", "XLPE", "SGI"]
    for t = ["LeRoy", "Doedens"]
        for a = ["TRRA", "PS"]
            for s = ["Yes", "No"]
                [xv, wct, fitness] = GeneralOptimization(m, a, t, s);
            end
        end
    end
end
