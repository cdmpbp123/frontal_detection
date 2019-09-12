function [M_merge,bw_merge,tgrad,tangle] = edge_merge(tgrad,grd,tangle,bw,M,gapsize,min_len)
% main function: final step of frontline detection, merge neighboring edge segments.
% Input:      
%   bw : binary image derived after edge_follow
%   tgrad :  gradient magnitude  
%   grd : struct variable of grid info
%   tangle : gradient direction  (0-360 degree)
%   M : struct variable of frontal line output after function edge_follow 
%   gapsize: blob for link edge segment (in pixel)
%   min_len: length threhold in pixel for edge merge 
%
% Ouput:      
%   M_merge : struct variable of frontal line output after edge merging
%   bw_merge : binary image after edge merging
%
% See also:  edge_localization, edge_follow, front_line
%   
% Description:
%     
% ==============================================
if nargin<7
    min_len = gapsize;
end
bw = bwmorph(bw,'clean');  % remove isolated pixel
% initialize bw and M
M_merge=[];
bw_merge = bw;  
blob = circularstruct(gapsize); % build edge merging extent based on third-party toolbox
[rj, cj, re, ce] = findendsjunctions(bw);
% start from endpoint
for ip = 1:length(re)
    r0 = re(ip);
    c0 = ce(ip);
    if isnan(r0) || isnan(c0)
        continue
    end
    ff = locate_front(M,r0,c0);
    %find another endpoint of this edge
    rr = [M{ff}.row(1),M{ff}.row(end)];
    cc = [M{ff}.col(1),M{ff}.col(end)];
    ind = find( ~(r0 == rr & c0 == cc) );
    r1 = rr(ind);
    c1 = cc(ind);
    % return global row & col of edge merging extent and local bw
    [bw_loc0,blob_loc,row_g,col_g] = index_local_to_global(bw,r0,c0,gapsize);
    %find local index for all frontal line pixels within the extent
    bw_loc = blob_loc & bw_loc0;
    [rLoc , cLoc] = find(bw_loc == 1);
    len_loc = length(rLoc);
    bw_row_g = zeros(len_loc,1);
    bw_col_g = zeros(len_loc,1);
    idxBwG = zeros(len_loc,1);
    for iLoc = 1:length(rLoc)
        bw_row_g(iLoc) = row_g(rLoc(iLoc),cLoc(iLoc));
        bw_col_g(iLoc) = col_g(rLoc(iLoc),cLoc(iLoc));
        % examine if front pixels within the extent is endpoint
        if find((bw_row_g(iLoc) == re & bw_col_g(iLoc) == ce))
            idxBwG(iLoc) = 1;
        else
            idxBwG(iLoc) = 0;
            continue
        end
        % exclude endpoints from located front 'ff'
        if find((bw_row_g(iLoc) == r0 & bw_col_g(iLoc) == c0) | ...
                (bw_row_g(iLoc) == r1 & bw_col_g(iLoc) == c1)) 
            idxBwG(iLoc) = 0;
        end
    end
    idxBw = find(idxBwG == 1); % endpoints frontal index from bw_row_g & bw_col_g
    %find pixels need to merge
    if isempty(idxBw)
        continue % no pixel to merge
    elseif length(idxBw) == 1
        % mark merge points with found endpoint  
        merge_row = bw_row_g(idxBw);
        merge_col = bw_col_g(idxBw);
    elseif length(idxBw) >= 2
        ep_row = bw_row_g(idxBw);
        ep_col = bw_col_g(idxBw); 
        % choose which endpoints to merge
        [merge_row, merge_col] = find_merge_endpoint(M,grd,r0,c0,ep_row,ep_col,tangle,'direction');
    end
    clear rLoc cLoc
    %  
    if isempty(merge_row) || isempty(merge_col)
        % if no merge pixel is found, skip out of loop endpoint ip
        continue
    else
        % locate front number by endpoint row and col
        [ff1] = locate_front(M,merge_row,merge_col);
        if isempty(ff1)
            continue
        end
        % find merge pixel index from endpoints array re & ce 
        ip0 = find(re(:) == merge_row & ce(:) == merge_col); 
        %  set both of connected endpoints NaN to skip later loop
        re(ip) = NaN; ce(ip) = NaN;
        if ~isempty(ip0)
            re(ip0)  = NaN; ce(ip0) = NaN;
        end
    end
    clear merge_row merge_row 
    clear ep_row ep_col
    % extract two merged edges only, then link them with function filledge
    bw_before_link = zeros(size(bw));
    for j = 1:length(M{ff}.row)
        bw_merge(M{ff}.row(j),M{ff}.col(j)) = 0;
        bw_before_link(M{ff}.row(j),M{ff}.col(j)) = 1;
    end
    clear j
    for j = 1:length(M{ff1}.row)
        bw_merge(M{ff1}.row(j),M{ff1}.col(j)) = 0;
        bw_before_link(M{ff1}.row(j),M{ff1}.col(j)) = 1;
    end
    clear j
    % link two edges
    bw_after_link = filledgegaps(bw_before_link, gapsize);
    % identify linking points between two edges
    [rowT,colT] = find(bw_before_link == 0 & bw_after_link == 1);
    % if we add some new front pixels between two edges
    % we need to give value for front magnitude and direction
    % to make sure followed function front_area run correctly
    % simplest way£º give value of endpoints,
    % TBD: further algorithm
    for ii = 1:length(rowT)
        tgrad(rowT(ii),colT(ii))  = tgrad(r0,c0);
        tangle(rowT(ii),colT(ii))  = tangle(r0,c0);
    end
    clear rowT colT
    % examine if still exist branch structure
    [rj1, cj1, ~, ~] = findendsjunctions(bw_after_link);
    if isempty(rj1) == 1 || isempty(cj1) == 1
        bw_single_new = bw_after_link;
    else
        % TBD: cut off shorter branch and remain the longer one
        %         [bw_single_new] = extract_single_segment(bw_after_link);
        bw_single_new = bwmorph(bw_after_link,'thin'); % thinning again
        bw_single_new = bwmorph(bw_single_new,'spur'); % remove spur
    end
    bw_merge(bw_single_new == 1) = 1; %return back to bw_merge
    clear bw_single_new
end  % end for loop ip 
[rj, cj, re, ce] = findendsjunctions(bw_merge);
% update M_merge by calling edge_follow again
[M_merge,bw_merge] = edge_follow(bw_merge,tgrad,grd,tangle);
% set minimum pixel length threshold
[bw_merge,M_merge] = edge_filter(bw_merge,M_merge,min_len);
end  % end main function

function [merge_row, merge_col] = find_merge_endpoint(M,grd,r0,c0,ep_row,ep_col,tangle,type)
% if two or more endpoints are located within radius for edge merge
% this function finds which points to merge from 
% the selected endpoints [r0,c0]
% we list three different merge criterions:
% 1. least direction change
% 2. shortest distance
% 3. combine above two criterion
for ii = 1: length(ep_row)
    idx(ii) =  locate_front(M,ep_row(ii),ep_col(ii));
end
% deal with the condition that two endpoint of same edge both located
% within the extent, if two endpoints in same edge,
% only remain the one closer to center pixel
[front_idx,ia,ic] = unique(idx,'stable');
if length(front_idx) < length(idx)
    for ii = 1: length(front_idx)
        nn = find(idx == front_idx(ii));
        if length(nn) == 2
             [rr,cc,hit_idx] = find_closest_distance(grd,r0,c0,ep_row(nn),ep_col(nn));
             % delete pixel value of endpoints at the further end
             miss_idx = find(nn ~= hit_idx); 
             ep_row(miss_idx) = [];
             ep_col(miss_idx) = [];
        end
    end
end
if strcmp(type,'direction')
    [merge_row,merge_col,~] = find_least_direction_change(r0,c0,ep_row,ep_col,tangle);
elseif strcmp(type,'distance')
    [merge_row,merge_col,~] = find_closest_distance(grd,r0,c0,ep_row,ep_col);
elseif strcmp(type,'combine')
    % TBD
    % if angle for nearest endpoints large than 
    % choose least angle difference points 
    % if no angle , go back to nearest points
else
    merge_row = [];
    merge_col = [];
end

end % end function find_merge_endpoint


