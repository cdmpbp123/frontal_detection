function plot_front_figure(varargin)
% plot front figures as image product
%
% domain for figure
[lon_w,lon_e,lat_s,lat_n]=varargin{1:4};
% output path (full path)
fig_path = varargin{5};
% bw & sst variable (array)
[bw, temp_zl] = varargin{6:7};
% struct variable
[grd, tfrontline, tfrontarea, info_area] = varargin{8:11};
% figure parameter
[fig_type] = varargin{12};

dtime_str = datestr(grd.time,'yyyymmdd');
lon = grd.lon_rho;
lat = grd.lat_rho;
fnum = length(tfrontline);
if strcmp(fig_type,'front_product')
    % image product
    % SST + frontline + frontarea with transparent shading
    figure('visible','on','color',[1 1 1])
    m_proj('Miller','lat',[lat_s lat_n],'lon',[lon_w lon_e]);
    P=m_pcolor(lon,lat,temp_zl);
    set(P,'LineStyle','none');
    shading interp
    hold on
    % frontline pixel overlaid
    for ifr = 1:fnum
        for ip = 1:length(tfrontline{ifr}.row)
            plon(ip) = lon(tfrontline{ifr}.row(ip),tfrontline{ifr}.col(ip));
            plat(ip) = lat(tfrontline{ifr}.row(ip),tfrontline{ifr}.col(ip));
            lon_left(ip) = tfrontarea{ifr}{ip}.lon(1);
            lat_left(ip) = tfrontarea{ifr}{ip}.lat(1);
            lon_right(ip) = tfrontarea{ifr}{ip}.lon(end);
            lat_right(ip) = tfrontarea{ifr}{ip}.lat(end);
        end
        poly_lon = [lon_left fliplr(lon_right)];
        poly_lat = [lat_left fliplr(lat_right)];
        m_patch(poly_lon,poly_lat,[.7 .7 .7],'FaceAlpha', .5,'EdgeColor','none')
        hold on
        m_plot(plon,plat,'k','LineWidth',1)
        hold on
        clear poly_lon poly_lat
        clear lon_left lat_left lon_right lat_right
        clear plon plat
    end
    %  caxis([15 30])
    colorbar
    colormap(jet);
%     m_gshhs_i('patch', [.8 .8 .8], 'edgecolor', 'none');
    m_gshhs_i('patch', 'w', 'edgecolor', 'none');
    m_grid('box','fancy','tickdir','in','linest','none','ytick',0:2:40,'xtick',90:2:140);
    title(['SST ',dtime_str])
%     export_fig([fig_path,'/sst_front_',dtime_str],'-png','-r300');
    print ('-dpng','-r300',[fig_path,'/sst_front_',dtime_str,'.png']);
elseif strcmp(fig_type,'sst_frontline')
    %TBD
end



end
