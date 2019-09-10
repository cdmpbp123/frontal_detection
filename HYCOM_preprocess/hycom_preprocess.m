function [temp_zl,grd] = hycom_preprocess(hycom_file,hycom_path,file_type,variable_name,lon_w,lon_e,lat_s,lat_n,logic_field_smooth)
%%===================================================================================
%preprocess of HYCOM raw data, format: .a[b]
%Input: 
%   fn - Name of HYCOM data file (file paths included)
%   depth - depth that you want to detect front  isopycnal layer for now
%	lon_w,lon_e,lat_s,lat_n - domain boundary 
%   logic_field_smooth - logic switch that do 3-point average of whole field 
%Output:
%   temp_zl - field extracted by function
%
%% Example:
%% fn='..\hycom_glb_910_2014010300_t000_ts3z.nc';
%%domain
%lon_w=117.;  lon_e=121.; lat_s=21.;  lat_n=26.;  % TaiwanBank
%%Default setup
%logic_field_smooth=0;
%flen_crit=10e3;
%Ct_crit=10;
%logic_frontal_length=1;
%logic_morph=1;
%plot_switch=2;
%hycom_path='/work/person/rensh/backup/HYCOM/xjp/result/HCS_result/exp010/tide/';
%hycom_file=[hycom_path,'HCSDAILY_0000_08.a'];
%file_type='daily';
%variable_name='temp';
%%===================================================================================
if strcmp(file_type,'weekly')
[T,~,~,~]=loadweekly(hycom_file,variable_name,1,1);
elseif   strcmp(file_type,'daily')
[T,~,~,~]=loaddaily(hycom_file,variable_name,1,1);
end
T(T==0)=NaN;T(T>1e9)=NaN;
[idm,jdm]=size(T);
[lon1(:,:),~,~,~]=loada([hycom_path,'regional.grid.a'],1,idm,jdm);
[lat1(:,:),~,~,~]=loada([hycom_path,'regional.grid.a'],2,idm,jdm);
[scpx(:,:),~,~,~]=loada([hycom_path,'regional.grid.a'],10,idm,jdm);
[scpy(:,:),~,~,~]=loada([hycom_path,'regional.grid.a'],11,idm,jdm);
mask_xi=find(lon1(:,1)>lon_w & lon1(:,1)<lon_e);
mask_eta=find(lat1(1,:)>lat_s & lat1(1,:)<lat_n);
%Set xi and eta limitation
eta_ind = min(mask_eta);
eta_len = length(mask_eta);
eta_end=max(mask_eta);
xi_ind = min(mask_xi);
xi_len =length(mask_xi);
xi_end=max(mask_xi);
temp_zl=T(xi_ind:xi_end,eta_ind:eta_end);
lon=lon1(xi_ind:xi_end,eta_ind:eta_end);
lat=lat1(xi_ind:xi_end,eta_ind:eta_end);
grd.lat_rho=lat;
grd.lon_rho=lon;
grd.eta_ind=eta_ind;
grd.xi_ind=xi_ind;
grd.eta_len=eta_len;
grd.xi_len=xi_len;
%Read depth
fid=fopen([hycom_path,'regional.depth.a'],'r','ieee-be');
model_depth=fread(fid,[idm jdm],'single');
fclose(fid);
mask=find(model_depth>1e9);model_depth(mask)=NaN;	

grd.pm=1./scpx(xi_ind:xi_end,eta_ind:eta_end); 
grd.pn=1./scpy(xi_ind:xi_end,eta_ind:eta_end);

%%get time stamp of ncfile: 
%%'hours since 2000-01-01 00:00:00'
%ocean_time=ncread(fn,'time'); 
%d0=datenum(2000,01,01,00,00,00);
%d1=double(d0+ocean_time/24);
%% format read by datenum
%grd.time=d1;

if logic_field_smooth==1
    temp_smooth=filter2(fspecial('average',3),temp_zl);
    temp_smooth(1,:)=NaN;
    temp_smooth(end,:)=NaN;
    temp_smooth(:,1)=NaN;
    temp_smooth(:,end)=NaN;
    temp_zl=temp_smooth;
end


end