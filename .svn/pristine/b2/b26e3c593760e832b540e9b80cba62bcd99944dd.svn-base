function [lowThresh, highThresh] = thresh_select(thresh, LowFreq,HighFreq,magGrad,ThresholdRatio,figname)
%
%   Local Function : thresh_select
%
if nargin < 6
    figname = [];
end
[m,n] = size(magGrad);
% Select the thresholds
if isempty(thresh)
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
    if isempty(figname)~=1
        ymin = 50;
        ymax = 100;
        LowFreqPercent = LowFreq*100;
        HighFreqPercent = HighFreq*100;
        figure;
        plot(x,cum_freq*100,'LineWidth',2)
        set(gca,'YLim',[ymin ymax])
        xlabel('gradient (\circC/km)','FontSize',12)
        ylabel('Percent','FontSize',12)
        hold on
        plot([lowThresh lowThresh],[ymin LowFreqPercent],'LineStyle','-','Color','k','LineWidth',1)
        plot([0 lowThresh],[LowFreqPercent LowFreqPercent],'LineStyle','-','Color','k','LineWidth',1)
        hold on
        plot([highThresh highThresh],[ymin HighFreqPercent],'LineStyle','-','Color','r','LineWidth',1)
        plot([0 highThresh],[HighFreqPercent HighFreqPercent],'LineStyle','-','Color','r','LineWidth',1)
        t_string = ['low thresh = ',num2str(lowThresh,'%4.3f'),', high thresh =',num2str(highThresh,'%4.3f')];
        title(t_string,'FontSize',14)
        print ('-djpeg95','-r300',figname);
        close all
    end
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