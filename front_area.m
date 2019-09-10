function [info_area,tfrontarea] = front_area(tfrontline,tgrad,tangle,grd,thresh)
% front_area: detect frontal zone based on frontal line rendered from function 'front_line'
% Input:
%   tfrontline - detected final frontal line  (struct type array)
%   temp_zl - temperature variable for diagnose
%   grd -  grid info (struct type array)
%   thresh - double threshold [lowThresh,highThresh]
% Ouput:
%   tfrontarea: frontal zone detect result (struct array)
lon = grd.lon_rho;
lat = grd.lat_rho;
% calculate grid area
grid_area = (1./grd.pm).*(1./grd.pn);
grid_area_mean = mean(grid_area(:));
lowThresh = thresh(1);
highThresh = thresh(2);
[sector] = sector_dividing8(tangle);
fronta = zeros(size(tgrad));
fronta(tgrad > highThresh) = 1;
%--preprocessing for fronta
% fronta = bwmorph(fronta,'close',Inf);
% fronta = bwmorph(fronta,'clean');
fnum = length(tfrontline);
% finding frontarea boundary
for ifr =1:fnum
    row = tfrontline{ifr}.row;
    col = tfrontline{ifr}.col;
    for  ip = 1: length(row)
        %detect frontal zone from central line 
        pcenter_row = row(ip);
        pcenter_col = col(ip);
        pcenter_sector = sector(pcenter_row,pcenter_col);
        [r0,c0] = find_sector_neighbor8(pcenter_sector,pcenter_row,pcenter_col,'across');
        % 记录锋区边缘点和横锋方向锋区点
        for ii=1:2
            start_prow = pcenter_row;
            start_pcol = pcenter_col;
            prow = r0(ii);
            pcol = c0(ii);
            if fronta(prow,pcol) ~= 1 
                if isnan(tgrad) == 1
                    frow = [pcenter_row];
                    fcol = [pcenter_col];
                else
                  frow = [pcenter_row prow];
                    fcol = [pcenter_col pcol];
                end
                front_brdy{ii}.row = frow;
                front_brdy{ii}.col = fcol;
                continue
            else
                frow = [pcenter_row prow];
                fcol = [pcenter_col pcol];
            end
            % 循环寻找边界点
            for m=1:length(row)*2
                psector = sector(prow,pcol);
                [rr,cc] = find_sector_neighbor8(psector,prow,pcol,'across');
                next_prow = rr(ii);
                next_pcol = cc(ii);
                %判断寻找的下一个点是否重复找过
                L0 = next_prow == frow & next_pcol == fcol;
                if isnan(tgrad(next_prow,next_pcol)) == 1 
                    break % quit loop:m
                elseif fronta(next_prow,next_pcol)==1 && isempty(find(L0==1))
                    frow = [frow next_prow];
                    fcol = [fcol next_pcol];
                    %更新迭代
                    prow=next_prow;
                    pcol=next_pcol;
                else
                    frow = [frow next_prow];
                    fcol = [fcol next_pcol];
                    break % quit loop:m
                end
            end
            front_brdy{ii}.row = frow;
            front_brdy{ii}.col = fcol;
            clear frow fcol
        end
        % combine across-front pixel of two directions
        row_left = fliplr(front_brdy{1}.row(2:end));
        row_right = front_brdy{2}.row(2:end);
        col_left = fliplr(front_brdy{1}.col(2:end));
        col_right = front_brdy{2}.col(2:end);
        across_row =  [row_left pcenter_row row_right];
        across_col = [col_left pcenter_col col_right];
        across_fronta{ip}.num = length(across_row);
        across_fronta{ip}.row = across_row;
        across_fronta{ip}.col =  across_col;
        % calculate front width
        width = 0;
        sum_tgrad = 0;
        for j = 1:length(across_row)
            if j >1
                width = width + spheric_dist(lat(across_row(j-1),across_col(j-1)), ...
                    lat(across_row(j),across_col(j)), ...
                    lon(across_row(j-1),across_col(j-1)),...
                    lon(across_row(j),across_col(j)));
            end
            sum_tgrad = sum_tgrad + tgrad(across_row(j),across_col(j));
            %writing data
            across_fronta{ip}.lon(j) = lon(across_row(j),across_col(j));
            across_fronta{ip}.lat(j) = lat(across_row(j),across_col(j));
            across_fronta{ip}.tgrad(j) = tgrad(across_row(j),across_col(j));
            across_fronta{ip}.sector(j) = sector(across_row(j),across_col(j));
        end
        across_fronta{ip}.width = width;
        across_fronta{ip}.mean_tgrad = sum_tgrad/length(across_row);
        clear width sum_tgrad
        
        brow_left(ip) = across_row(1);
        bcol_left(ip)= across_col(1);
        brow_right(ip) = across_row(end);
        bcol_right(ip) = across_col(end);
        across_fronta_width(ip) =  across_fronta{ip}.width;
        left_lon(ip) = lon(brow_left(ip),bcol_left(ip));
        left_lat(ip) = lat(brow_left(ip),bcol_left(ip));
        right_lon(ip) = lon(brow_right(ip),bcol_right(ip));
        right_lat(ip) = lat(brow_right(ip),bcol_right(ip));
    end
    % storage frontarea array
    tfrontarea{ifr} = across_fronta;
    % calculate max-width and mean width of frontal area
    max_width(ifr) = max(across_fronta_width);
    mean_width(ifr) = mean(across_fronta_width);
    % mean tgrad of frontal area
    ss = 0;
    nn = 0;
    for ip = 1:length(tfrontarea{ifr})
        ss = ss + tfrontarea{ifr}{ip}.mean_tgrad*tfrontarea{ifr}{ip}.num;
        nn = nn + tfrontarea{ifr}{ip}.num;
    end
    mean_tgrad(ifr) = ss/nn;
    clear ss nn
    % calculate area of frontal area
    poly_row = [brow_left fliplr(brow_right)];
    poly_col = [bcol_left fliplr(bcol_right)];
    %test figure for line and area
%     plot(poly_row,poly_col)
%     hold on
%     plot(row,col)
    % use internal function "polyarea" 
    area(ifr) = polyarea(poly_row,poly_col)*grid_area_mean;  % unit: m^2
    % equivalent mean frontal width = frontal area/frontal length, unit: m
    equivalent_width(ifr) = area(ifr) / tfrontline{ifr}.flen;
    % storage struct array of frontarea info
    info_area{ifr}.max_width = max(across_fronta_width);
    info_area{ifr}.mean_width = mean(across_fronta_width);
    info_area{ifr}.area = area(ifr);
    info_area{ifr}.equivalent_width = area(ifr) / tfrontline{ifr}.flen;
    info_area{ifr}.mean_tgrad = mean_tgrad(ifr);
    info_area{ifr}.across_fronta_width = across_fronta_width;
    info_area{ifr}.poly_row = poly_row;
    info_area{ifr}.poly_col = poly_col;
%     info_area{ifr}.brow_left = brow_left;
%     info_area{ifr}.brow_right = brow_right;
%     info_area{ifr}.bcol_left = bcol_left;
%     info_area{ifr}.bcol_right = bcol_right;
%     info_area{ifr}.left_lon = left_lon;
%     info_area{ifr}.left_lat = left_lat;
%     info_area{ifr}.right_lon = right_lon;
%     info_area{ifr}.right_lat = right_lat;
    clear across_fronta
    clear brow_left brow_right  bcol_left bcol_right poly_row poly_col 
    clear across_fronta_width 
    clear right_lat right_lon left_lat left_lon
    clear row col
end
end