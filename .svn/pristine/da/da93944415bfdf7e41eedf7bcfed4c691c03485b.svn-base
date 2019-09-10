function [temp_zl,grd] = hycom_RA_preprocess(fn,depth,lon_w,lon_e,lat_s,lat_n,logic_field_smooth,skip)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%preprocess of HYCOM reanalysis  data
%Input: 
%   fn - Name of HYCOM data file (file paths included)
%   depth - depth that you want to detect front
%	lon_w,lon_e,lat_s,lat_n - domain boundary 
%   logic_field_smooth - logic switch that do 3-point average of whole field 
%   skip - grid interval number of field 'temp_zl'
%Output:
%   temp_zl - field extracted by function
%
% Example:
% fn='..\hycom_glb_910_2014010300_t000_ts3z.nc';
% info=ncinfo(fn);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lon1 = ncread(fn,'lon');
lat1 = ncread(fn,'lat');
mask_xi=find(lon1(:)>lon_w & lon1(:)<lon_e);
mask_eta=find(lat1(:)>lat_s & lat1(:)<lat_n);
%Set xi and eta limitation for South China Sea
eta_ind = min(mask_eta);
eta_len = length(mask_eta);
xi_ind = min(mask_xi);
xi_len =length(mask_xi);
%Read depth
zlevel=ncread(fn,'depth');
%Read temperature from hycom data
temp_zl = ncread(fn,'water_temp',[xi_ind eta_ind 1 1],[xi_len eta_len 1 1]);
%temp_zl(isnan(temp_zl))=0;
lon=ncread(fn,'lon',[xi_ind],[xi_len]);
lat=ncread(fn,'lat',[eta_ind],[eta_len]);
[grd.lat_rho,grd.lon_rho]=meshgrid(lat,lon);
grd.eta_ind=eta_ind;
grd.xi_ind=xi_ind;
grd.eta_len=eta_len;
grd.xi_len=xi_len;
%0.08 is horizontal resolution for hycom dataset
resolution=0.08;
pm=1./(cos(lat*pi/180.)*111.1e3*resolution); 
pn=ones(size(lon))*1./(111.1e3*resolution);
[grd.pm,grd.pn]=meshgrid(pm,pn);
%get time stamp of ncfile: 
%'hours since 2000-01-01 00:00:00'
ocean_time=ncread(fn,'time'); 
d0=datenum(2000,01,01,00,00,00);
d1=double(d0+ocean_time/24);
% format read by datenum
grd.time=d1;
%%是否对温度场进行平滑滤波
if logic_field_smooth==1
    temp_smooth=filter2(fspecial('average',3),temp_zl);
    temp_smooth(1,:)=NaN;
    temp_smooth(end,:)=NaN;
    temp_smooth(:,1)=NaN;
    temp_smooth(:,end)=NaN;
    temp_zl=temp_smooth;
end


end