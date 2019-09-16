function [M,bw_new] = edge_follow(bw,tgrad,grd,tangle)
%
% edge_follow :  this function extract frontal line from binary map derived from edge_localization function.
%
% Usage:  [M,bw_new] = edge_follow(bw,tgrad,grd,tangle)
%
% Input:      
%   bw : binary image derived from edge_localization
%   tgrad :  gradient magnitude  
%   grd : struct variable of grid info
%   tangle : gradient direction  (0-360 degree)
%
% Ouput:      
%   M : struct variable of frontal line output  
%   bw_new : binary image after edge_follow
%
% See also:  edge_localization, edge_merge, front_line
%   
% Description:
%     The algorithm scan the edge map from finding endpoint which has only one neighbor edge pixel,
%     then examine the 8-connected neighbors when meet branch pixels. When a branch
%     point is encountered, the contour following algorithm find which edge should be 
%     followed based on front direction and magnitude. The remaining branch is then processed 
%     as a separate contour. 
% ==============================================
%make sure tgrad and tangle have same mask with preprocessed bw
tgrad = tgrad .* bw; 
tangle = tangle .* bw;
[segment,num] = bwlabel(bw,8);
[sector]  = sector_dividing8(tangle);
bw_new=zeros(size(tgrad));
lon = grd.lon_rho;
lat = grd.lat_rho;
ff = 0 ;
for ifr = 1 : num
    [row, col] = find(segment == ifr);
    bw_ifr = bwselect(bw, col, row, 8);
    bw_ifr = bwmorph(bw_ifr,'thin'); % thinning again
    bw_index = bw_ifr;
    bw_sector = bw_ifr.*sector;
    bw_tangle = bw_ifr.*tangle;
    [N,neigh_num] = find_neighbor_info(bw,row,col);
    neigh1 = find(neigh_num  ==  1); % find endpoint index
    for i1 = 1 : length(neigh1)
        ip = neigh1(i1);
        start_prow = row(ip);
        start_pcol = col(ip);
        if bw_index(start_prow,start_pcol) == 0 || bw_new(start_prow,start_pcol) == 2
            continue
        end
        porder = ip; % frontal pixel order initalization
        bw_index(row(ip),col(ip)) = 0;
        bw_new(row(ip),col(ip)) = 1;
        next_prow = N{ip}.row;
        next_pcol = N{ip}.col;
        for m = 1 : length(row)*2
            if length(next_prow) ~= 1 || length(next_pcol) ~= 1
                break
            end
            prow = next_prow;
            pcol = next_pcol;
            [ip] = find(row(:) == next_prow & col(:) == next_pcol);
            if bw_new(row(ip),col(ip)) == 2
                ff = ff +1;
                break
            end
            if neigh_num(ip) == 1
                porder = [porder ip];
                bw_index(row(ip),col(ip)) = 0;
                bw_new(row(ip),col(ip)) = 1;
                next_prow = [];
                next_pcol = [];
                ff = ff+1;
                break
            elseif neigh_num(ip) == 2
                porder = [porder ip];
                bw_index(row(ip),col(ip)) = 0;
                bw_new(row(ip),col(ip)) = 1;
                rr = N{ip}.row;
                cc = N{ip}.col;
                for j = 1:2
                    L(j) = (rr(j) == start_prow) & (cc(j) == start_pcol);
                end
                LL = find(L ~= 1);
                next_prow = rr(LL);
                next_pcol = cc(LL);
                start_prow = prow;
                start_pcol = pcol;
                continue  % jump back to loop: m = 1 : length(row)*2
            elseif neigh_num(ip) >= 3
                % the algorithm first finds two neighbored pixels in along-front direction. 
                p_sector= bw_sector(prow,pcol);
                [rr,cc]=find_sector_neighbor8(p_sector,prow,pcol,'along');
                if isempty(rr) || isempty(cc)
                    ff = ff+1;
                    break
                end
                % examine how many  8-connected neighbors (whose pixel value bw_new=1) located along the direction
                % need to initialize L & LL
                L = zeros(neigh_num(ip),2);
                LL = zeros(neigh_num(ip),1);
                for ii = 1:neigh_num(ip)
                    nrow = N{ip}.row(ii);
                    ncol = N{ip}.col(ii);
                    % debug of re-assign value to pixel with bw_new = 2
                    % reassign value will cause junctions
                    if bw_new(nrow,ncol) == 2
                        continue
                    end
                    for jj =1:2
                        L(ii,jj) = ((rr(jj) == nrow) & (cc(jj) == ncol));
                    end
                    if L(ii,1) == 1 || L(ii,2) == 1
                        LL(ii) = 1;
                    else
                        LL(ii) = 0;
                    end
                end
                % index of neighbor front pixel located in along-front direction
                miss_index = find(LL ~=1);
                hit_index = find(LL == 1);
                miss_row = N{ip}.row(miss_index);
                miss_col = N{ip}.col(miss_index);
                hit_row = N{ip}.row(hit_index);
                hit_col = N{ip}.col(hit_index);
                clear L LL
                bw_index(row(ip),col(ip)) = 0; % discard branch point from bw_index
                bw_new(row(ip),col(ip)) = 1; % mark branch point as front point in bw_new first
                if length(hit_row) == 2   
                    % two frontal points at along-front direction 
                    start_index = find(hit_row(:) == start_prow & hit_col(:) == start_pcol, 1);
                    next_index = find(~(hit_row(:) == start_prow & hit_col(:) == start_pcol));
                    if isempty(start_index)
                        %discard start point and link two hit points
                        bw_new(start_prow,start_pcol) = 2; 
                        %change along-front pixel bw value
                        bw_new(hit_row(1),hit_col(1)) = 1;
                        bw_new(hit_row(2),hit_col(2)) = 1;
                        porder(end) = [] ;
                        ff = ff+1;
                        break
                    else
                        next_prow = hit_row(next_index);
                        next_pcol = hit_col(next_index);
                        porder = [porder ip];
                    end
                    skip_index = [1:length(miss_row)]; % mark every miss row/col as skip_index
                elseif length(hit_row) == 1 
                    % only 1 frontal points located in along-front direction
                    if hit_row == start_prow && hit_col == start_pcol  
                        % if frontal points along-front direction is the start point, choose the branch 
                        % that least changes the direction of the current contour.
                        [next_prow,next_pcol,~] = find_least_direction_change(prow,pcol,miss_row,miss_col,tangle);
                        porder =  [porder ip];
                        if isempty(next_prow) || isempty(next_pcol)
                            % when next point is not found from other 2 neighbored point,
                            % break loop and end the contour
                            bw_new(miss_row(1),miss_col(1)) = 2;
                            bw_new(miss_row(2),miss_col(2)) = 2;
                            ff = ff+1;
                            break
                        end
                        skip_index = find(miss_row(:) ~= next_prow | miss_col(:) ~= next_pcol );
                    else
                        next_prow = hit_row;
                        next_pcol = hit_col;
                        porder =  [porder ip];
                        skip_index =  find(miss_row(:) ~= start_prow | miss_col(:) ~= start_pcol);
                    end
                elseif length(hit_row) == 0 
                    % no frontal points located in along-front direction
                    start_index = find(miss_row(:) == start_prow & miss_col(:) == start_pcol);
                    miss_row(start_index) = [];
                    miss_col(start_index) = [];
                    [next_prow,next_pcol,~] = find_least_direction_change(prow,pcol,miss_row,miss_col,tangle);
                    if isempty(next_prow) || isempty(next_prow)
                        bw_new(miss_row(1),miss_col(1)) = 2;
                        bw_new(miss_row(2),miss_col(2)) = 2;
                        ff = ff+1;
                        break
                    end
                    porder =  [porder ip];
                    skip_index = find(miss_row(:) ~= next_prow | miss_col(:) ~= next_pcol);
                end
                start_prow = prow;
                start_pcol = pcol;
                r_skip = miss_row(skip_index);
                c_skip = miss_col(skip_index);
                % after contour following, mark cutting points as bw_new = 2
                % for separate contour 
                for ik = 1:length(skip_index)
                    if bw_new(r_skip(ik),c_skip(ik)) == 0
                        bw_new(r_skip(ik),c_skip(ik)) = 2;
                    end
                end
            end
        end
        M{ff}.row=row(porder);
        M{ff}.col=col(porder);
        % add other parameter for figure later
        for ip = 1:length(M{ff}.row)
            M{ff}.lon(ip) = lon(M{ff}.row(ip),M{ff}.col(ip));
            M{ff}.lat(ip) = lat(M{ff}.row(ip),M{ff}.col(ip));
            M{ff}.tgrad(ip) = tgrad(M{ff}.row(ip),M{ff}.col(ip));
            M{ff}.tangle(ip) = tangle(M{ff}.row(ip),M{ff}.col(ip));
        end
    end
    clear N
end
bw_new(bw_new == 2) = 0;
% add edge filter
filter_pixel_length = 1;
[bw_filter,M_filter] = edge_filter(bw_new,M,filter_pixel_length);
bw_new = bw_filter;
M = M_filter;
% check edge follow algorithm
[rj, cj, ~, ~] = findendsjunctions(bw_new);
if isempty(rj) ~= 1 || isempty(cj) ~= 1
    error('error: after edge following, junction points should no longer exist')
end

end % end main function
