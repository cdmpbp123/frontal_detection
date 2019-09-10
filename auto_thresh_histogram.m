function [LowThresh, HighThresh] = auto_thresh_histogram(tgrad, LowFreq, HighFreq, figname)
% histogram of sst gradient
%
tgrad_col = tgrad(:);
nonan_number = numel(find(~isnan(tgrad_col)));
[b,x]=hist(tgrad_col,100);
cum_freq=cumsum(b/nonan_number);
c0 = find(cum_freq<LowFreq,1,'last');
c1 = find(cum_freq>LowFreq,1,'first');
LowThresh = interp1(cum_freq(c0:c1),x(c0:c1),LowFreq);
clear c0 c1
c0 = find(cum_freq<HighFreq,1,'last');
c1 = find(cum_freq>HighFreq,1,'first');
HighThresh = interp1(cum_freq(c0:c1),x(c0:c1),HighFreq);
if isempty(figname)~=1
    ymin = 50;
    ymax = 100;
    LowFreqPercent = LowFreq*100;
    HighFreqPercent = HighFreq*100;
    figure;
    plot(x,cum_freq*100,'LineWidth',2)
    set(gca,'YLim',[ymin ymax])
    xlabel('gradient (C/km)','FontSize',12)
    ylabel('Percent','FontSize',12)
    hold on
    plot([LowThresh LowThresh],[ymin LowFreqPercent],'LineStyle','-','Color','k','LineWidth',1)
    plot([0 LowThresh],[LowFreqPercent LowFreqPercent],'LineStyle','-','Color','k','LineWidth',1)
    hold on
    plot([HighThresh HighThresh],[ymin HighFreqPercent],'LineStyle','-','Color','r','LineWidth',1)
    plot([0 HighThresh],[HighFreqPercent HighFreqPercent],'LineStyle','-','Color','r','LineWidth',1)
    t_string = ['low thresh = ',num2str(LowThresh,'%4.3f'),', high thresh =',num2str(HighThresh,'%4.3f')];
    title(t_string,'FontSize',14)
    print ('-djpeg95','-r300',figname);
    close all
end
end
