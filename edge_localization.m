function [eout,thresh_out] = edge_localization(var,magGrad,tangle,thresh_in)
% edge localization - canny edge detection 
% This function rewrite from edge.m in MATLAB
% Input:
%   var: variable with preprocessing finished 
%   magGrad:  gradient magnitude
%   tangle:  angle of front
% Output:
%   eout: binary image result
%   thresh_out: thresh output
[m,n] = size(var);
% ---------user define parameter------------------------------------%
% Low thresh is this fraction of the high threshold.
ThresholdRatio = 0.4;
% Low and high frequency for histgram
low_freq = 0.8;
high_freq = 0.9;
% -----------------------------------------------------------%
global fig_path_test 
global fig_test
if fig_test
    figname = [fig_path_test,'autothreshold_histogram.png'];
else
    figname = [];
end
% Determine Hysteresis Thresholds
[lowThresh, highThresh] = thresh_select(thresh_in, low_freq, high_freq, magGrad, ThresholdRatio,figname);
thresh_out = [lowThresh, highThresh];
% edge localization
canny1=zeros(m,n);
canny2=zeros(m,n);
eout=zeros(m,n);
[sector]=sector_dividing8(tangle);
for im=2:m-1
    for in=2:n-1
        if sector(im,in)==1 || sector(im,in) == 5
            if ( magGrad(im,in)>magGrad(im+1,in) && magGrad(im,in)>magGrad(im-1,in) )
                canny1(im,in)=magGrad(im,in);
            else
                canny1(im,in)=0;
            end
        elseif sector(im,in)==2 || sector(im,in) == 6
            if ( magGrad(im,in)>magGrad(im+1,in+1) && magGrad(im,in)>magGrad(im-1,in-1) )
                canny1(im,in)=magGrad(im,in);
            else
                canny1(im,in)=0;
            end
        elseif sector(im,in)==3 || sector(im,in) == 7
            if ( magGrad(im,in)>magGrad(im,in+1) && magGrad(im,in)>magGrad(im,in-1) )
                canny1(im,in)=magGrad(im,in);
            else
                canny1(im,in)=0;
            end
        elseif sector(im,in)==4 || sector(im,in) == 8
            if ( magGrad(im,in)>magGrad(im+1,in-1) && magGrad(im,in)>magGrad(im-1,in+1) )
                canny1(im,in)=magGrad(im,in);
            else
                canny1(im,in)=0;
            end
        end
    end
end
%---------------------------------
%Hysteresis Thresholds detection
for im = 2:(m-1)
    for in = 2:(n-1)
        if canny1(im,in)<lowThresh %low threshold
            canny2(im,in) = 0;
            eout(im,in) = 0;
            continue;
        elseif canny1(im,in)>highThresh %high threshold
            canny2(im,in) = canny1(im,in);
            eout(im,in) = 1;
            continue;
        else
            %pixel with gradient between low and high thresh, if 8-neighbored 
            % pixel is above highthresh, name this pixel as frontal pixel
            neighbor8 =[canny1(im-1,in-1), canny1(im-1,in), canny1(im-1,in+1);
                canny1(im,in-1),    canny1(im,in),   canny1(im,in+1);
                canny1(im+1,in-1), canny1(im+1,in), canny1(im+1,in+1)];
            temMax = max(neighbor8(:));
            if temMax > highThresh
                canny2(im,in) = temMax(1);
                eout(im,in) = 1;
                continue;
            else
                canny2(im,in) = 0;
                eout(im,in) = 0;
                continue;
            end
        end
    end
end
global test_morph
if test_morph
    basedir = ['D:\lomf\frontal_detect\'];
    fig_path = [basedir,'\Fig\test\edge_localization\'];
    mkdir(fig_path)
    [ri0, ci0] = findisolatedpixels(eout);
    [rj0, cj0, re0, ce0] = findendsjunctions(eout);
    disp('raw image')
    disp(['isolate pixels= ',num2str(length(ri0))])
    disp(['junction pixels= ',num2str(length(rj0))])
    disp(['endpoint= ',num2str(length(re0))])
    figure;
    imshow(rot90(eout))
    title(['isolate pixels= ',num2str(length(ri0)),' ',...
        'junction pixels= ',num2str(length(rj0))])
    export_fig([fig_path,'raw_image.png'],'-png','-r200');
    %necessary morphological processing to detect frontal line
    eout = bwmorph(eout,'clean'); %remove isolated frontal pixels
    [ri0, ci0] = findisolatedpixels(eout);
    [rj0, cj0, re0, ce0] = findendsjunctions(eout);
    disp('after cleaning')
    disp(['isolate pixels= ',num2str(length(ri0))])
    disp(['junction pixels= ',num2str(length(rj0))])
    disp(['endpoint= ',num2str(length(re0))])
    figure;
    imshow(rot90(eout))
    title(['isolate pixels= ',num2str(length(ri0)),' ',...
        'junction pixels= ',num2str(length(rj0))])
    export_fig([fig_path,'cleaning.png'],'-png','-r200')
    %
    eout = bwmorph(eout,'hbreak'); % remove H-connect pixels
    % [ri0, ci0] = findisolatedpixels(eout);
    % [rj0, cj0, re0, ce0] = findendsjunctions(eout);
    % disp('after H-break')
    % disp(['isolate pixels= ',num2str(length(ri0))])
    % disp(['junction pixels= ',num2str(length(rj0))])
    % disp(['endpoint= ',num2str(length(re0))])
    eout = bwmorph(eout,'thin', Inf); %Make sure that edges are thinned or nearly thinned
    [ri0, ci0] = findisolatedpixels(eout);
    [rj0, cj0, re0, ce0] = findendsjunctions(eout);
    disp('after thinning')
    disp(['isolate pixels= ',num2str(length(ri0))])
    disp(['junction pixels= ',num2str(length(rj0))])
    disp(['endpoint= ',num2str(length(re0))])
    figure;
    imshow(rot90(eout))
    title(['isolate pixels= ',num2str(length(ri0)),' ',...
        'junction pixels= ',num2str(length(rj0))])
    export_fig([fig_path,'thinning.png'],'-png','-r200')
else
    %necessary morphological processing to detect frontal line
    eout = bwmorph(eout,'clean'); %remove isolated frontal pixels
    eout = bwmorph(eout,'hbreak'); % remove H-connect pixels
    eout = bwmorph(eout,'thin', Inf); %Make sure that edges are thinned or nearly thinned
end

end


