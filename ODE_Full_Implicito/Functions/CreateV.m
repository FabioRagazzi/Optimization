function [V] = CreateV(deltas)
% CreateV Computes the volumes of the cells of the domain
% INPUT
% deltas -> spacing between the domain points
% OUTPUT
% V -> volumes of the cells (column vector)
V = (deltas(2:end-2) + deltas(3:end-1)) / 2;
V = [deltas(1) + deltas(2)/2; V'; deltas(end) + deltas(end-1)/2];
end

