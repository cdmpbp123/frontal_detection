function [M] = cal_front_parameter(M,grd,tgrad)
% calculate parameter of frontal line: mean frontal strength and front length
% other parameter to be finished
    lon = grd.lon_rho;
    lat = grd.lat_rho;
    fnum = length(M);
    for ifr = 1:fnum
        row = M{ifr}.row;
        col = M{ifr}.col;
        mid_idx = round(length(M{ifr}.row)/2);
        flen = 0;
        tgrad_sum = tgrad(row(1),col(1));
        tgrad_num = 1;
        for ip = 2:length(row)
            flen = flen + spheric_dist(lat(row(ip-1),col(ip-1)),lat(row(ip),col(ip)), ...
                lon(row(ip-1),col(ip-1)),lon(row(ip),col(ip)));
            if isnan(tgrad(row(ip),col(ip))) ~=1
                tgrad_sum = tgrad_sum + tgrad(row(ip),col(ip));
                tgrad_num = tgrad_num + 1;
            end
        end
        M{ifr}.flen = flen;
        M{ifr}.tgrad_mean = tgrad_sum/tgrad_num;
        % mid pixel of frontline
        M{ifr}.mid_lat = lat(row(mid_idx),col(mid_idx));
        M{ifr}.mid_lon =  lon(row(mid_idx),col(mid_idx));
        clear tgrad_sum tgrad_num flen mid_idx
        clear row col mid_idx
    end
end