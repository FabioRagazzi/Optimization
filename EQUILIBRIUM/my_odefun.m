function [dndt] = my_odefun(t, n, param)
dndt = Omega(n', param.num_points, param.N0t, param.N0t, param.B, param.B, ...
                 param.D, param.D, param.S0, param.S12, param.S12, param.S3, param.U);
end
