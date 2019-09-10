function [tfrontline,tfrontarea] = front_detection(varargin)
%% Usage:
% [tfrontline,tfrontarea] =front_detection(fn,depth,lon_w,lon_e,lat_s,lat_n,datatype,dtcrit,logic_field_smooth,...
% skip,flen_crit,Ct_crit,logic_frontal_length,logic_morph,plot_switch,tfname,tfrontline_nc_output,tfrontarea_nc_output);
%% Input:
%   fn: Name of history or average file (file paths included)
%   depth: depth that you want to detect front
%   [lon_w,lon_e,lat_s,lat_n]: domain boundary 
%   datatype: data type
%   dtcrit: threshold for diagnose front (modify if need)
%   logic_field_smooth: logic switch that if do 3-point average of whole field     
%   skip:  grid interval number of field
%   flen_crit: frontal lenth threshold
%   Ct_crit: pixel length threshold
%   logic_frontal_length: logic switch if extract frontal length longer than flen_crit
%   logic_morph: logic switch if do morphology transformation of frontal line 'bw'
%   plot_switch: plotting switch of figure. 
%       (0) no figure
%       (1) frontline overlaying on temp_zl
%       (2) frontarea overlaying on tgrad      
%       (3) background (temp_zl) only 
%       (4) (1) with temp contour
%   tfname: name of figure (file paths included)
%   tfrontline_nc_output: filename of frontal line Netcdf format (file paths included)
%   tfrontarea_nc_output: filename of frontal area Netcdf format (file paths included)
%% Defaults:
% Example:
% fn='..\scs_ini_20161107.nc';  
% depth=1;
% dtcrit=0.05;
% datatype='roms';
% logic_field_smooth=1;
% skip=1;
% flen_crit=50e3;
% Ct_crit=20;
% logic_frontal_length=1;
% logic_morph=1;
% plot_switch=1;
% tfname='1.jpg';
% tfrontline_nc_output='test1.nc';
% tfrontarea_nc_output='test2.nc';
%%
fn=varargin{1};
depth=varargin{2};
[lon_w,lon_e,lat_s,lat_n]=varargin{3:6};
datatype=varargin{7};
dtcrit=varargin{8};
logic_field_smooth=varargin{9};
skip=varargin{10};
flen_crit=varargin{11}; 
Ct_crit=varargin{12};  
logic_frontal_length=varargin{13};
logic_morph=varargin{14};
plot_switch=varargin{15};
tfname=varargin{16};
tfrontline_nc_output=varargin{17};
tfrontarea_nc_output=varargin{18};
%
%data preprocess
if strcmp(datatype,'roms')
    [temp_zl,grd]=roms_preprocess(fn,depth,lon_w,lon_e,lat_s,lat_n,logic_field_smooth,skip);
elseif strcmp(datatype,'ostia')
    [temp_zl,grd]=ostia_preprocess(fn,lon_w,lon_e,lat_s,lat_n,logic_field_smooth);
elseif strcmp(datatype,'hycom')
    [temp_zl,grd]=hycom_preprocess(fn,depth,lon_w,lon_e,lat_s,lat_n,logic_field_smooth,skip);
elseif strcmp(datatype,'mercator')
    [temp_zl,grd] = mercator_preprocess(fn,depth,lon_w,lon_e,lat_s,lat_n,logic_field_smooth,skip);
end
%Detect temperature front area
[txgrad,tygrad] = grad_sobel(temp_zl,grd.pm,grd.pn);
tgrad = (txgrad .^ 2 + tygrad .^ 2) .^ 0.5;
% tgrad(tgrad > dtcrit_max) = 0;
% tgrad(temp_zl==0) = 0;
tangle = atan2(tygrad,txgrad) / pi * 180;
fronta = zeros(size(tgrad));
fronta(tgrad > dtcrit) = 1;
% fronta(tgrad > dtcrit_max) = 0;
fronta=bwmorph(fronta,'close',Inf);
fronta=bwmorph(fronta,'clean');
%frontal area
[tfrontarea] = front_area(fronta,tgrad,tangle,grd,Ct_crit);
%frontal line
[tfrontline] = front_line(temp_zl,dtcrit,tgrad,tangle,grd,flen_crit,Ct_crit,logic_frontal_length,logic_morph);
%plot figure
plot_front_figure(lon_w,lon_e,lat_s,lat_n,grd,temp_zl,tgrad,fronta,dtcrit,tfrontline,tfrontarea,plot_switch,tfname);
%dumping frontal line result to NetCDF file
dumping_frontal_line_stats(tfrontline,tfrontline_nc_output);
%dumping frontal area result to NetCDF file
dumping_frontal_area_stats(tfrontarea,tfrontarea_nc_output);
%
end
