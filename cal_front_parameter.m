function [front_parameter] = cal_front_parameter(tfrontline,tfrontarea,grd)
%{
    calculate parameter of frontal line and frontal area
    saving in same variable 'front_parameter'
    frontal line:
        front length (unit: m)
        frontal line mean gradient (unit: C/km)
        frontal line center lon
        frontal line center lat
    frontal area:
        Area (unit: m2) 
        mean width (unit: m)
        max_width (unit: m) 
        equivalent_width (unit: m)
        frontal area mean gradient (unit: C/km) 
%}
lon = grd.lon_rho;
lat = grd.lat_rho;
fnum = length(tfrontline);
% calculate grid area
grid_area = (1./grd.pm).*(1./grd.pn);
grid_area_mean = mean(grid_area(:));
% save frontline parameter to new struct 'front_parameter'
front_parameter = cell(fnum,1);
for ifr = 1:fnum
    front_parameter{ifr}.length = tfrontline{ifr}.flen;
    front_parameter{ifr}.line_tgrad_mean = tfrontline{ifr}.tgrad_mean;
    front_parameter{ifr}.line_mid_lat = tfrontline{ifr}.mid_lat;
    front_parameter{ifr}.line_mid_lon = tfrontline{ifr}.mid_lon;
end
% before save frontarea paramter, some preparation calculation needed
[mean_frontarea_tgrad] = cal_frontarea_mean_tgrad(tfrontarea);
[area] = cal_frontarea_area(tfrontarea,grid_area_mean);
[mean_width, max_width] = cal_frontarea_width(tfrontarea);
% save frontarea parameter to new struct 'front_parameter'
for ifr = 1:fnum
    front_parameter{ifr}.area = area(ifr);
    front_parameter{ifr}.mean_width = mean_width(ifr);
    front_parameter{ifr}.max_width = max_width(ifr);
    front_parameter{ifr}.area_tgrad_mean = mean_frontarea_tgrad(ifr);
    % equivalent mean frontal width = frontal area/frontal length, unit: m
    front_parameter{ifr}.equivalent_width = area(ifr) / tfrontline{ifr}.flen;
end

end

function [mean_tgrad] = cal_frontarea_mean_tgrad(tfrontarea)
% calculate mean tgrad of frontal area
fnum = length(tfrontarea);
mean_tgrad = zeros(fnum,1);
for ifr = 1:fnum
    ss = 0;
    nn = 0;
    for ip = 1:length(tfrontarea{ifr})
        ss = ss + tfrontarea{ifr}{ip}.mean_tgrad*tfrontarea{ifr}{ip}.num;
        nn = nn + tfrontarea{ifr}{ip}.num;
    end
    mean_tgrad(ifr) = ss/nn;
    clear ss nn
end

end

function [area] = cal_frontarea_area(tfrontarea,grid_area_mean)
% calculate area from tfrontarea struct
fnum = length(tfrontarea);
area = zeros(fnum,1); % unit: m^2
for ifr = 1:fnum
    across_fronta = tfrontarea{ifr};
    for ip = 1:length(across_fronta)
        brow_left(ip) = across_fronta{ip}.row(1);
        brow_right(ip) = across_fronta{ip}.row(end);
        bcol_left(ip) = across_fronta{ip}.col(1);
        bcol_right(ip) = across_fronta{ip}.col(end);
    end
    % use internal function "polyarea" calculate area of frontal area
    poly_row = [brow_left fliplr(brow_right)];
    poly_col = [bcol_left fliplr(bcol_right)];
    area(ifr) = polyarea(poly_row,poly_col)*grid_area_mean;
    clear brow_left brow_right  bcol_left bcol_right poly_row poly_col
    clear across_fronta
end

end

function [mean_width, max_width] = cal_frontarea_width(tfrontarea)
% calculate frontarea width from tfrontarea struct
fnum = length(tfrontarea);
mean_width = zeros(fnum,1);
max_width = zeros(fnum,1);
for ifr = 1:fnum
    across_fronta = tfrontarea{ifr};
    across_fronta_width = zeros(length(across_fronta),1);
    for ip = 1:length(across_fronta)
        across_fronta_width(ip) = across_fronta{ip}.width;
    end
    max_width(ifr) = max(across_fronta_width);
    mean_width(ifr) = mean(across_fronta_width);
    clear across_fronta across_fronta_width
end

end
