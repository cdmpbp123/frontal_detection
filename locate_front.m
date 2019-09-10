function [front_index] = locate_front(M,ep_row,ep_col)
% locate front index according endpoint
%
% Input:
%   bw : binary image derived from edge_localization
%   tgrad :  gradient magnitude
%   grd : struct variable of grid info
%   tangle : gradient direction  (0-360 degree)
%   M : struct variable of frontal line output after function edge_follow
%   gapsize: blob for link edge segment (in pixel)
%   min_len: length threhold for edge merge
%
% Ouput:
%   M_merge : struct variable of frontal line output after edge merging
%   bw_merge : binary image after edge merging
% ==============================================
ep_index = zeros(size(ep_row));
front_index = zeros(size(ep_row));
for ff = 1:length(M)
    r0 = M{ff}.row(1);
    r1 = M{ff}.row(end);
    c0 = M{ff}.col(1);
    c1 = M{ff}.col(end);
    for ii = 1:length(ep_row)
        ep_index(ii) = (ep_row(ii) == r0 & ep_col(ii) == c0) | (ep_row(ii) == r1 & ep_col(ii) == c1);
        if ep_index(ii)
            front_index(ii) = ff;
        else
            continue
        end
    end
end

end % end function locate_front