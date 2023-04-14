function [] = Movie(x, Matrix, p)
% Movie displays a video showing the evolution in time of Matrix
% INPUT
% x -> vector containing the x for the plot
% Matrix -> data to be plotted, column by column
% p -> pause between one frame and th other in seconds
% OUTPUT
% [] -> none
figure
id = plot(x, Matrix(:,1), 'LineWidth', 2);
pause(1);
for i = 2:size(Matrix,2)
    delete(id)
    id = plot(x, Matrix(:,i), 'LineWidth', 2);
    pause(p);
end
end

