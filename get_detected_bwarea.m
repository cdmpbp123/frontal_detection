function [bw_area] = get_detected_bwarea(grd,tfrontline,tfrontarea)
% extract bw_area binary map from detected front struct
% find pixel coordinate from patch implementation instead of tfrontarea output pixel
lon = grd.lon_rho;
lat = grd.lat_rho;
[nx,ny] = size(lon);
bw_area = zeros(nx, ny);
fnum = length(tfrontline);
for ifr = 1:fnum
    for ip = 1:length(tfrontline{ifr}.row)
        lon_left(ip) = tfrontarea{ifr}{ip}.lon(1);
        lat_left(ip) = tfrontarea{ifr}{ip}.lat(1);
        lon_right(ip) = tfrontarea{ifr}{ip}.lon(end);
        lat_right(ip) = tfrontarea{ifr}{ip}.lat(end);
    end
    poly_lon = [lon_left fliplr(lon_right)];
    poly_lat = [lat_left fliplr(lat_right)];
    patch_index = inpolygon(lon, lat, poly_lon, poly_lat);
    [row_area, col_area] = find(patch_index == 1);
    for ii = 1:length(row_area)
        bw_area(row_area(ii), col_area(ii)) = 1;
    end
    clear poly_lon poly_lat
    clear lon_left lat_left lon_right lat_right
    clear row_area col_area
end

end

