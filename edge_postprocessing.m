function [M_final,bw_final,flen_thresh_out] = edge_postprocessing(M,bw,grd,flen_thresh_in,logic_morph,min_length_pixel,freq4flen)
%{
     edge postprocessing
    1. preliminary approach to cut off edges whose length pixels shorter than min_length_pixel
    2. calculate frontline parameter (mean frontal strength, front length and mid-position of front)
    3. set length threshold to extract main fronts (if length threshold is not given, use auto-threshold to calculate)
%}
if nargin<7
    freq4flen = 0.7;
    if nargin<6
        min_length_pixel = 3; % default minimum length pixel
    end
end
% cut off edges whose length pixels shorter than min_length_pixel
[M,bw] = edge_filter(M,bw,min_length_pixel);
% calculate parameter of frontal line
lon = grd.lon_rho;
lat = grd.lat_rho;
fnum = length(M);
for ifr = 1:fnum
    row = M{ifr}.row;
    col = M{ifr}.col;
    front_lon = M{ifr}.lon;
    front_lat = M{ifr}.lat;
    front_tgrad = M{ifr}.tgrad;
    mid_idx = round(length(M{ifr}.row)/2);
    flen = 0;
    tgrad_sum = front_tgrad(1);
    tgrad_num = 1;
    for ip = 2:length(row)
        flen = flen + spheric_dist(front_lat(ip-1),front_lat(ip), ...
            front_lon(ip-1),front_lon(ip));
        if isnan(front_tgrad(ip)) ~=1
            tgrad_sum = tgrad_sum + front_tgrad(ip);
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
% use front length threhold to extract primary fronts 
if isempty(flen_thresh_in)
    [flen_thresh_out] = length_auto_thresold(M, freq4flen);
else
    flen_thresh_out = flen_thresh_in;
end
% set frontal length threshold, unit: km
bw_flen=zeros(size(bw));
fnum = 0;
for ifr=1:length(M)
    row = M{ifr}.row;
    col = M{ifr}.col;
    flen = M{ifr}.flen;
    if length(row) >= min_length_pixel && flen > flen_thresh_out
        fnum = fnum +1;
        M_length{fnum}=M{ifr};
        for ip = 1:length(row)
            bw_flen(row(ip),col(ip))=1;
        end
    end
end
%morphological processing
if logic_morph
    % TBD: deal with morphology operator to connect neighbor segment
    % bw2=bwmorph(bw1,'close',Inf);
    % close operator change non-front pixel to front pixel, may cause error
end
% bw_final and M_final
bw_final = bw_flen;
M_final = M_length;
end