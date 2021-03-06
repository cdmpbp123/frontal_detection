function [grd] = fn_getgrdinfo(fn,lon_w,lon_e,lat_s,lat_n,skip)
%
lon_rho = ncread(fn,'lon_rho');
lat_rho = ncread(fn,'lat_rho');
[xi_rho,eta_rho]=size(lon_rho);
mask_xi=find(lon_rho(:,1)>lon_w & lon_rho(:,1)<lon_e);
mask_eta=find(lat_rho(1,:)>lat_s & lat_rho(1,:)<lat_n);
mask_xi=mask_xi(1:skip:end);
mask_eta=mask_eta(1:skip:end);
%Set xi and eta limitation 
eta_ind = min(mask_eta);
eta_len = length(mask_eta);
xi_ind = min(mask_xi);
xi_len =length(mask_xi);
%Read some model paramters from ROMS file
grd.pm = ncread(fn,'pm',[xi_ind eta_ind],[xi_len eta_len],[skip skip]);
grd.pn = ncread(fn,'pn',[xi_ind eta_ind],[xi_len eta_len],[skip skip]);
grd.pm =grd.pm/skip;
grd.pn =grd.pn/skip;
grd.lon_rho = ncread(fn,'lon_rho',[xi_ind eta_ind],[xi_len eta_len],[skip skip]);
grd.lat_rho = ncread(fn,'lat_rho',[xi_ind eta_ind],[xi_len eta_len],[skip skip]);
grd.mask_rho = ncread(fn,'mask_rho',[xi_ind eta_ind],[xi_len eta_len],[skip skip]);
%grd.lon_u = ncread(fn,'lon_u',[xi_ind eta_ind-1],[xi_len eta_len]);
%grd.lat_u = ncread(fn,'lat_u',[xi_ind eta_ind-1 ],[xi_len eta_len]);
%grd.lon_v = ncread(fn,'lon_v',[eta_ind-1 xi_ind],[xi_len eta_len]);
%grd.lat_v = ncread(fn,'lat_v',[eta_ind-1 xi_ind],[xi_len eta_len]);
grd.h = ncread(fn,'h',[xi_ind eta_ind],[xi_len eta_len],[skip skip]);
grd.h(grd.h > 5000) = 5000;
%get grd of the domain
grd.eta_ind=eta_ind;
grd.eta_len=eta_len;
grd.xi_ind=xi_ind;
grd.xi_len=xi_len;
end