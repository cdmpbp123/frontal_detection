function [tfrontline,bw_final,thresh_out,tgrad_new,tangle_new] = front_line(temp_zl,thresh_in,grd,flen_crit,logic_morph)
%% front_line - main function of extracting frontal line from SST and dumping frontline to the struct variable
%    
% Usage: [tfrontline,thresh_out] = front_line(temp_zl,thresh_in,grd,flen_crit,logic_morph)
%
% Input:
%   temp_zl - 2D temperature variable after preprocessing
%   thresh_in - threshold input (C/km)
%   grd - struct variable of grid info
%   flen_crit - length criterion for detecting front (unit: m)
%   logic_morph - switch of morphology processing (0 or 1)

% Output:
%   tfrontline - struct variable of frontal line detect result 
%   thresh_out - threshold output (C/km)
%   bw_final - final binary image
%% 
[tgrad, tangle] = get_front_variable(temp_zl,grd);
% [sector8] = sector_dividing8(tangle);
%% edge localization
disp('edge localization...')
[bw, thresh_out] = edge_localization(temp_zl,tgrad,tangle,thresh_in);
%% edge follow
disp('edge following...')
[M,bw_new] = edge_follow(bw,tgrad,grd,tangle);
%% edge merge
disp('edge merging...')
gapsize = 3;
[M_merge,bw_merge,tgrad_new,tangle_new] = edge_merge(tgrad,grd,tangle,bw_new,M,gapsize);
%% calculate frontal line parameter
[M_merge] = cal_front_parameter(M_merge,grd,tgrad_new);
%% post_processing
[tfrontline,bw_final] = edge_postprocessing(M_merge,bw_merge,grd,flen_crit,logic_morph);
%%
fnum = length(tfrontline);
if fnum==0
    tfrontline=[];
    disp('no detected frontline')
end
end %end main function