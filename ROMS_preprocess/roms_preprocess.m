function [temp_zl,grd] = roms_preprocess(fn,fntype,grdfn,depth,lon_w,lon_e,lat_s,lat_n,fill_value,skip,date_str)
%%preprocess of ROMS data
% Input: 
% fn - Name of ROMS file (file paths included)
%   fntype - roms file type ('ini', 'avg', 'his', ...)
%   depth - depth that you want to detect front
%	lon_w,lon_e,lat_s,lat_n - domain boundary 
%   fill_value - set fill_value for NaN
%   skip - grid interval number of field 'temp_zl'
%Output:
%   temp_zl - field extracted by function
%   grd - grid info 
%
%Get horizontal grid informations
[grd] = fn_getgrdinfo(grdfn,lon_w,lon_e,lat_s,lat_n,skip);
eta_ind=grd.eta_ind;
xi_ind=grd.xi_ind;
eta_len=grd.eta_len;
xi_len=grd.xi_len;
% read ocean time
    ocean_time=ncread(fn,'ocean_time'); 
    tmp = ncreadatt(fn,'ocean_time','units');
    S = regexp(tmp, '\s+', 'split');
    date_string = [S{end-1},' ',S{end}];
    d0=datenum(date_string,31);
%
if strcmp(fntype,'ini')
    %get time stamp of ncfile and dumping to grd file
    d1=d0+ocean_time/3600/24;
    %Read zeta,temperature/salinity, velocity from ROMS output
    zeta = ncread(fn,'zeta',[xi_ind eta_ind 1],[xi_len eta_len 1],[skip skip 1]);
    % fill_value = ncreadatt(fn,'zeta','_FillValue');
    zeta(zeta>1e+9 | isnan(zeta)) = fill_value;
    temp = ncread(fn,'temp',[xi_ind eta_ind 1 1],[xi_len eta_len Inf Inf],[skip skip 1 1]);
    temp(temp>1e+9 | isnan(temp)) = fill_value;
elseif strcmp(fntype,'avg')
    if length(ocean_time) ~= 1
        %concatenate 1-year data into one file
        d1 = datenum(date_str,'yyyymmdd');
        [yyyy,mm,dd] = datevec(d1);
        d_start = datenum(yyyy,1,1,0,0,0);
        iday  = d1 - d_start + 1;
        temp = ncread(fn,'temp',[xi_ind eta_ind 1 iday],[xi_len eta_len Inf 1],[skip skip 1 1]);
        temp(temp>1e+9 | isnan(temp)) = fill_value;
    else
        % scs_avg_yyyymmdd.nc
    end
end
grd.time=d1;
%switch temp_extract method
temp_switch=2;
switch temp_switch
    case 1
        % Interpolate to given Z-level
        %Get vertical coordinate informations
        vc = fn_getvcinfo(fn);
        temp_zl = roms3d_s2z(vc.s_rho,vc.Cs_r,vc.Tcline,zeta,grd.h,temp,depth);
    case 2
        %saving time, extract SST
        temp_zl = squeeze(temp(:,:,end));
end
  
end