function [temp_zl,grd] = roms_preprocess(fn,depth,lon_w,lon_e,lat_s,lat_n,logic_field_smooth,skip)
%preprocess of ROMS his data
%example: /backup/person/rensh/ROMS/data/2012_EnOI/scs_his_2012.nc
%Input: 
%   fn - Name of history or average file (file paths included)
%   depth - depth that you want to detect front
%	lon_w,lon_e,lat_s,lat_n - domain boundary 
%   logic_field_smooth - logic switch that do 3-point average of whole field 
%   skip - grid interval number of field 'temp_zl'
%Output:
%   temp_zl - field extracted by function
%
%   example:
fn='/backup/person/rensh/ROMS/data/2012_EnOI/scs_his_2012.nc';
romsfn=fn;


%Get vertical coordinate informations
disp('Getting grid informations ...')
vc = fn_getvcinfo(fn);
%Get horizontal grid informations
[grd] = fn_getgrdinfo(fn,lon_w,lon_e,lat_s,lat_n,skip);

eta_ind=grd.eta_ind;
xi_ind=grd.xi_ind;
eta_len=grd.eta_len;
xi_len=grd.xi_len;
%get time stamp of ncfile: 
%'seconds since 2000-01-01 00:00:00'
ocean_time=ncread(fn,'ocean_time'); 
d0=datenum(2000,01,01,00,00,00);
d1=d0+1+ocean_time/3600/24;
% format read by datenum
grd.time=d1;
%Read zeta,temperature/salinity, velocity from ROMS output
disp('Reading zeta, temperature, salinity and so on ...')
zeta = ncread(fn,'zeta',[xi_ind eta_ind 1],[xi_len eta_len 1],[skip skip 1]);
zeta(isnan(zeta)) = 0;
temp = ncread(fn,'temp',[xi_ind eta_ind 1 1],[xi_len eta_len 36 1],[skip skip 1 1]);
disp('Interpolating everything to given Z-level ...')
% Interpolate everything to given Z-level
temp_zl = roms3d_s2z(vc.s_rho,vc.Cs_r,vc.Tcline,zeta,grd.h,temp,depth);
%temp_zl(isnan(temp_zl)) = 0;
%temp_zl(temp_zl==0) = NaN;

if logic_field_smooth==1
    temp_smooth=filter2(fspecial('average',3),temp_zl);
    temp_smooth(1,:)=NaN;
    temp_smooth(end,:)=NaN;
    temp_smooth(:,1)=NaN;
    temp_smooth(:,end)=NaN;
    temp_zl=temp_smooth;
end

end