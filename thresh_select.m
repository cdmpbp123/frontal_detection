function [lowThresh, highThresh] = thresh_select(thresh, LowFreq,HighFreq,magGrad,ThresholdRatio)
%
%   Local Function : thresh_select
%
[m,n] = size(magGrad);
% Select the thresholds
if isempty(thresh)
    [lowThresh, highThresh] = calculate_thresh_by_histogram(LowFreq,HighFreq,magGrad);
elseif length(thresh)==1
    highThresh = thresh;
    lowThresh = ThresholdRatio*thresh;
elseif length(thresh)==2
    lowThresh = thresh(1);
    highThresh = thresh(2);
    if (lowThresh >= highThresh) || (highThresh >= 1)
        error(message('images:edge:thresholdOutOfRange'))
    end
end
end

function [lowThresh, highThresh] = calculate_thresh_by_histogram(LowFreq,HighFreq,magGrad)
    nonan_number = numel(find(~isnan(magGrad)));
    [b x]=hist(magGrad(:),100);
    cum_freq=cumsum(b/nonan_number);
    c0 = find(cum_freq<LowFreq,1,'last');
    c1 = find(cum_freq>LowFreq,1,'first');
    lowThresh = interp1(cum_freq(c0:c1),x(c0:c1),LowFreq);
    clear c0 c1
    c0 = find(cum_freq<HighFreq,1,'last');
    c1 = find(cum_freq>HighFreq,1,'first');
    highThresh = interp1(cum_freq(c0:c1),x(c0:c1),HighFreq);
    clear c0 c1
end