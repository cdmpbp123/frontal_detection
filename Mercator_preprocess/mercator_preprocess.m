function [temp_zl,grd] = mercator_preprocess(fn,depth,lon_w,lon_e,lat_s,lat_n,skip)
%preprocess of Mercator Reanalysis data:
% format: ext-PSY4V3R1_1dAV_20171228_20171229_gridT_R20180110.nc 
% data description: 
%Input: 
%   fn - Name of Mercator data file (file paths included)
%   depth - depth that you want to extract
%	lon_w,lon_e,lat_s,lat_n - domain boundary 
%   skip - grid interval number of field 'temp_zl'
%Output:
%   temp_zl: temperature output
%   grd: struct variable of grid information 
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
%Read SST
temp_zl = ncread(fn,'votemper',[xi_ind eta_ind 1 1],[xi_len eta_len 1 1]);
% scale_factor=ncreadatt(fn,'votemper','scale_factor');
% add_offset=ncreadatt(fn,'votemper','add_offset');
lon = ncread(fn,'nav_lon',[xi_ind eta_ind],[xi_len eta_len]);
lat = ncread(fn,'nav_lat',[xi_ind eta_ind],[xi_len eta_len]);
grd.lon_rho=lon;
grd.lat_rho=lat;
grd.eta_ind=eta_ind;
grd.xi_ind=xi_ind;
grd.eta_len=eta_len;
grd.xi_len=xi_len;
%0.08 is horizontal resolution for Mercator 1/12 degree dataset  
resolution=0.08;
pm=1./(cos(lat*pi/180.)*111.1e3*resolution); 
pn=ones(size(lon))*1./(111.1e3*resolution);
grd.pm=pm;
grd.pn=pn;
%get time stamp of ncfile based on netCDF variable attribute 
ocean_time=ncread(fn,'time_counter'); 
date_start = ncreadatt(fn,'time_counter','units');
S = regexp(date_start, '\s+', 'split');
type = [S{1}];
date_string = [S{end-1},' ',S{end}];
d0 = datenum(date_string,31);
% format read by datenum
if strcmp(type,'hours')
    d1=double(d0+ocean_time/24);
%     datestr(d1)
elseif strcmp(type,'seconds')
end
grd.time=d1;
%mask of data
[m,n]=size(temp_zl);
mask=ones(m,n);
mask(isnan(temp_zl))=0;
grd.mask_rho=mask;
%
    
end