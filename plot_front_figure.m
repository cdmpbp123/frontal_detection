function plot_front_figure(varargin)
% plot front figures as image product
%
% domain for figure
[lon_w,lon_e,lat_s,lat_n]=varargin{1:4};
% figure name
fig_fn = varargin{5};
% bw & sst variable (array)
[bw, temp_zl] = varargin{6:7};
% struct variable
[grd, tfrontline, tfrontarea, info_area] = varargin{8:11};
% figure parameter
[data_type,fig_type,fig_show] = varargin{12:14};
% fig_show = 'off' /  'on'
dtime_str = datestr(grd.time,'yyyymmdd');
lon = grd.lon_rho;
lat = grd.lat_rho;
fnum = length(tfrontline);
[nx,ny] = size(bw);
%figure setup
line_width = 0.5;
face_alpha = 0.5;
minT = nanmin(temp_zl(:));
maxT = nanmax(temp_zl(:));
if strcmp(fig_type,'front_product')
    % image product: SST + frontline + frontarea with transparent shading
    bw_area = ones(nx,ny)*NaN;
    figure('visible',fig_show,'color',[1 1 1])
    m_proj('Miller','lat',[lat_s lat_n],'lon',[lon_w lon_e]);
    P0=m_pcolor(lon,lat,temp_zl);
    set(P0,'LineStyle','none');
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
        patch_index = inpolygon(lon, lat, poly_lon, poly_lat);
        [row_area, col_area] = find(patch_index == 1);
        for ii = 1:length(row_area)
            bw_area(row_area(ii), col_area(ii)) = 1;
        end
        hold on
        m_plot(plon,plat,'k','LineWidth',line_width)
        hold on
        clear poly_lon poly_lat
        clear lon_left lat_left lon_right lat_right
        clear plon plat
    end
    %     % no need to use bwperim function
    %     contour_bw = bwperim(bw_area);
    hold on
    P1=m_pcolor(lon,lat,bw_area);
    set(P1,'LineStyle','none','FaceAlpha',face_alpha);
    shading interp
    hold on
    colorbar
    % add color for transparent shading
    mycolormap = colormap(jet);
    mycolormap(1,:)= [0.8,0.8,0.8];
    colormap(mycolormap)
    caxis([minT maxT])
    m_gshhs_i('patch', 'w', 'edgecolor', 'none');
    m_grid('box','fancy','tickdir','in','linest','none','ytick',-10:5:40,'xtick',90:5:150);
    title([data_type,' frontal product: ',dtime_str])
    export_fig(fig_fn,'-png','-r300');
elseif strcmp(fig_type,'sst_frontline')
    % SST + frontline
    figure('visible',fig_show,'color',[1 1 1])
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
        end
        m_plot(plon,plat,'k','LineWidth',line_width)
        hold on
        clear plon plat
    end
    %  caxis([15 30])
    colorbar
    colormap(jet);
    m_gshhs_i('patch', 'w', 'edgecolor', 'none');
    m_grid('box','fancy','tickdir','in','linest','none','ytick',-10:5:40,'xtick',90:5:150);
    title([data_type,' frontal line overlayed with SST ',dtime_str])
    export_fig(fig_fn,'-png','-r300');
end

end
