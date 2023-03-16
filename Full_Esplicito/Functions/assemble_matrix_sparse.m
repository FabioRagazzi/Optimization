function [Matrix_sparse] = assemble_matrix_sparse(column1, column2, dim_M)
%ASSEMBLE_MATRIX_SPARSE Assemble a matrix directly as sparse
%   Detailed explanation goes here
I = [1:dim_M, 1:dim_M-1, 2:dim_M];
J = [1:dim_M, 2:dim_M, 1:dim_M-1];
v = [ [column1',0] + [0, column2'], -column2', -column1'];
Matrix_sparse = sparse(I, J, v);
end

