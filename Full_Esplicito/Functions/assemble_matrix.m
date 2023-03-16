function [Matrix] = assemble_matrix(column1, column2, dim_M)
% ASSEMBLE_MATRIX Creates a matrix given a column vector of coefficients
%   Detailed explanation goes here
Matrix = zeros(dim_M, dim_M);
Matrix(1:dim_M+1:dim_M*(dim_M-1)) = column1';
Matrix(dim_M+2:dim_M+1:dim_M^2) = Matrix(dim_M+2:dim_M+1:dim_M^2) + column2';
Matrix(dim_M+1:dim_M+1:dim_M^2) = -column2';
Matrix(2:dim_M+1:dim_M*(dim_M-1)) = -column1';
end

