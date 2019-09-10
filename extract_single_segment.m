function [bw_single_new] = extract_single_segment(bw_single)
% extract single edge segment based on segment length
% cut off shorter branch and remain the longer one
% TBD
[rj, cj, re, ce] = findendsjunctions(bw_single); 
if ~isempty(rj) || ~isempty(cj)
    error('junction points still exist, check it!')
end

end