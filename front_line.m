function [tfrontline,bw_final,thresh_out,tgrad_new,tangle_new] = front_line(temp_zl,thresh_in,grd,flen_crit,logic_morph)
%% front_line - main function of extracting frontal line from SST and dumping frontline to the struct variable
% Usage: [tfrontline,thresh_out] = front_line(temp_zl,thresh_in,grd,flen_crit,logic_morph)
% Input:
%   temp_zl - 2D temperature variable after preprocessing
%   thresh_in - threshold input (C/km)
%   grd - struct variable of grid info
%   flen_crit - length criterion for detecting front (unit: m)
%   logic_morph - switch of morphology processing (0 or 1)
% Output:
%   tfrontline - struct variable of frontal line detect result 
%   thresh_out - threshold output (unit: degree/km) and length threshold (unit: meter)
%   bw_final - final binary image
%% calculate front magnitude and direction
[tgrad, tangle] = get_front_variable(temp_zl,grd);
%% edge localization
disp('edge localization...start')
tic
[bw, thresh_out] = edge_localization(temp_zl,tgrad,tangle,thresh_in);
toc
disp('edge localization...finish')
%% morphlogical processing
bw = bwmorph(bw,'clean'); %remove isolated frontal pixels
bw = bwmorph(bw,'hbreak'); % remove H-connect pixels
bw = bwmorph(bw,'thin', Inf); %Make sure that edges are thinned or nearly thinned
%% edge follow
disp('edge following...start')
tic
[M,bw_new] = edge_follow(bw,tgrad,grd,tangle);
toc
disp('edge following...stop')
%% edge merge
disp('edge merging... start')
tic
gapsize = 3;
[M_merge,bw_merge,tgrad_new,tangle_new] = edge_merge(tgrad,grd,tangle,bw_new,M,gapsize);
toc
disp('edge merging... stop')
%% edge postprocessing
[tfrontline,bw_final,length_thresh] = edge_postprocessing(M_merge,bw_merge,grd,flen_crit,logic_morph);
thresh_out(3) = length_thresh; 
%% 
if length(tfrontline)==0
    tfrontline=[];
    disp('no detected frontline')
end
end %end main function