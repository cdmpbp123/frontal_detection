function [r,c,min] = find_least_direction_change(center_row,center_col,neigh_row,neigh_col,tangle)
% selects the edge pixel that least changes the direction of the front line to become the next pixel of the line
% Input:
%   center_prow - row index for center pixel
%   center_pcol - column index for center pixel
%   neigh_prow - row index for neighbor pixel
%   neigh_pcol - column index for neighbor pixel
%   tangle - pixel front direction, range from 0~360
% Ouput:
%   r - row index 
%   c - column index 
%   min - minimum angle difference between center pixel and neighbored
%       pixel
%%
neigh_no = length(neigh_row);
angle_diff = zeros(neigh_no,1);
for i = 1:neigh_no
    nrow = neigh_row(i);
    ncol = neigh_col(i);
    angle_diff(i) = abs(tangle(center_row,center_col)-tangle(nrow,ncol));
end
mk = find( abs(angle_diff) > 180 );
angle_diff(mk) = 360 - angle_diff(mk);
[ min , index ] = nanmin(angle_diff);
if min > 90
    r = [];
    c = [];
    min = [];
else
    r = neigh_row(index);
    c = neigh_col(index);
end

return