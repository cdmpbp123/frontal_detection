function [tfrontarea, bw_area_final] = front_area(tfrontline,tgrad,tangle,grd,thresh)
% front_area: detect frontal zone based on frontal line rendered from function 'front_line'
% Input:
%   tfrontline - detected final frontal line  (struct type array)
%   temp_zl - temperature variable for diagnose
%   grd -  grid info (struct type array)
%   thresh - double threshold [lowThresh,highThresh]
% Ouput:
%   tfrontarea: frontal zone detect result (struct array)
%   bw_area_final: bw_area binary map from detected front struct
lon = grd.lon_rho;
lat = grd.lat_rho;
lowThresh = thresh(1);
highThresh = thresh(2);
[sector] = sector_dividing8(tangle);
fronta = zeros(size(tgrad));
fronta(tgrad > highThresh) = 1;
logic_morph = 0;  % TBD: close morphlogical preprocessing for fronta for now
if logic_morph
    fronta = bwmorph(fronta,'close',Inf);
    fronta = bwmorph(fronta,'clean');
end
fnum = length(tfrontline);
tfrontarea = cell(1,fnum);
% finding frontarea boundary
for ifr =1:fnum
    row = tfrontline{ifr}.row;
    col = tfrontline{ifr}.col;
    %detect frontal zone from each pixels of frontal line 
    for  ip = 1: length(row)
        pcenter_row = row(ip);
        pcenter_col = col(ip);
        pcenter_sector = sector(pcenter_row,pcenter_col);
        [r0,c0] = find_sector_neighbor8(pcenter_sector,pcenter_row,pcenter_col,'across');
        % keep the record of frontal line and pixel accross-front direction
        front_brdy = cell(2,1);
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
                  % still add one pixel to the width
                  % to make sure frontwidth at least 3 pixels
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
            %
            for m=1:length(row)*2
                psector = sector(prow,pcol);
                [rr,cc] = find_sector_neighbor8(psector,prow,pcol,'across');
                next_prow = rr(ii);
                next_pcol = cc(ii);
                % determine if next point is already searched
                L0 = next_prow == frow & next_pcol == fcol;
                if isnan(tgrad(next_prow,next_pcol)) == 1 
                    break % finish searching and quit loop of m 
                elseif fronta(next_prow,next_pcol) == 1 && isempty(find(L0 == 1))
                    frow = [frow next_prow];
                    fcol = [fcol next_pcol];
                    prow = next_prow;
                    pcol = next_pcol;
                else
%                     frow = [frow next_prow];
%                     fcol = [fcol next_pcol];
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
        clear row_left row_right col_left col_right
        clear front_brdy
        across_fronta{ip}.num = length(across_row);
        across_fronta{ip}.row = across_row;
        across_fronta{ip}.col =  across_col;
        % calculate across direction width for each frontline pixel
        width = 0;
        sum_tgrad = 0;
        for j = 1:length(across_row)
            if j>1
                width = width + spheric_dist(lat(across_row(j-1),across_col(j-1)), ...
                    lat(across_row(j),across_col(j)), ...
                    lon(across_row(j-1),across_col(j-1)),...
                    lon(across_row(j),across_col(j)));
            end
            if isnan(tgrad(across_row(j),across_col(j))) ~=1
                sum_tgrad = sum_tgrad + tgrad(across_row(j),across_col(j));
            end
            across_fronta{ip}.lon(j) = lon(across_row(j),across_col(j));
            across_fronta{ip}.lat(j) = lat(across_row(j),across_col(j));
%             across_fronta{ip}.tgrad(j) = tgrad(across_row(j),across_col(j));
%             across_fronta{ip}.sector(j) = sector(across_row(j),across_col(j));
        end
        across_fronta{ip}.width = width;
        across_fronta{ip}.mean_tgrad = sum_tgrad/length(across_row);
        clear width sum_tgrad
    end
    % storage frontarea array
    tfrontarea{ifr} = across_fronta;
    clear across_fronta
    clear row col
end
% extract bw_area binary map from detected front struct
[bw_area_final] = get_detected_bwarea(grd,tfrontline,tfrontarea);
end