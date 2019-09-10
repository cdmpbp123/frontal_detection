function [r,c,index] = find_closest_distance(grd,center_row,center_col,neigh_row,neigh_col)
% find closest points from the center points
% Input:

% Ouput:

% Need:
%   spheric_dist, 
%%
lat = grd.lat_rho;
lon = grd.lon_rho;
neigh_no = length(neigh_row);
lat_c = lat(center_row,center_col);
lon_c = lon(center_row,center_col);
dist = zeros(neigh_no,1);
for i = 1:neigh_no
    nrow = neigh_row(i);
    ncol = neigh_col(i);
    dist(i) = spheric_dist(lat_c, lat(nrow,ncol), lon_c, lon(nrow,ncol));
end
[ ~ , index ] = nanmin(dist);
r = neigh_row(index);
c = neigh_col(index);

end