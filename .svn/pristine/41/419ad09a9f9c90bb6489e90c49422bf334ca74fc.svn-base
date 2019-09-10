function [temp_zl,grd] = mercator_preprocess(fn,depth,lon_w,lon_e,lat_s,lat_n,logic_field_smooth,skip)
%preprocess of Mercator Reanalysis data
%Input: 
%   fn - Name of Mercator data file (file paths included)
%   depth - depth that you want to detect front
%	lon_w,lon_e,lat_s,lat_n - domain boundary 
%   logic_field_smooth - logic switch that do 3-point average of whole field 
%   skip - grid interval number of field 'temp_zl'
%Output:
%   temp_zl - field extracted by function
%
% Example:
%
lon1=ncread(fn,'nav_lon');
lat1=ncread(fn,'nav_lat');
mask_xi=find(lon1(:,1)>lon_w & lon1(:,1)<lon_e);
mask_eta=find(lat1(1,:)>lat_s & lat1(1,:)<lat_n);
%Set xi and eta limitation for South China Sea
eta_ind = min(mask_eta);
eta_len = length(mask_eta);
xi_ind = min(mask_xi);
xi_len =length(mask_xi);
%Read temperature from Mercator data
temp_zl = ncread(fn,'votemper',[xi_ind eta_ind 1 1],[xi_len eta_len 1 1]);
% scale_factor=ncreadatt(fn,'votemper','scale_factor');
% add_offset=ncreadatt(fn,'votemper','add_offset');
temp_zl(temp_zl<0)=NaN;
lon = ncread(fn,'nav_lon',[xi_ind eta_ind],[xi_len eta_len]);
lat = ncread(fn,'nav_lat',[xi_ind eta_ind],[xi_len eta_len]);
grd.lon_rho=lon;
grd.lat_rho=lat;
grd.eta_ind=eta_ind;
grd.xi_ind=xi_ind;
grd.eta_len=eta_len;
grd.xi_len=xi_len;
%0.08 is horizontal resolution for Mercator dataset
resolution=0.08;
pm=1./(cos(lat*pi/180.)*111.1e3*resolution); 
pn=ones(size(lon))*1./(111.1e3*resolution);
grd.pm=pm;
grd.pn=pn;
%get time stamp of ncfile: 
%'seconds since 2007-10-31 00:00:00'
ocean_time=ncread(fn,'time_counter'); 
d0=datenum(2007,10,31,00,00,00);
d1=double(d0+ocean_time/3600/24);
% format read by datenum
grd.time=d1;
%mask of data
[m,n]=size(temp_zl);
mask=ones(m,n);
mask(isnan(temp_zl))=0;
grd.mask_rho=mask;
%
if logic_field_smooth==1
    temp_smooth=filter2(fspecial('average',3),temp_zl);
    temp_smooth(1,:)=NaN;
    temp_smooth(end,:)=NaN;
    temp_smooth(:,1)=NaN;
    temp_smooth(:,end)=NaN;
    temp_zl=temp_smooth;
end

    
end