function [length_thresh] = length_auto_thresold(tfrontline, freq, figname)
% calculate length threshold automatically based on daily detected result
if nargin < 3
    figname = [];
end
fnum = length(tfrontline);
front_length = zeros(fnum,1);
for ifr = 1:fnum
    front_length(ifr) = tfrontline{ifr}.flen;
end
[b,x]=hist(front_length,100);
cum_freq=cumsum(b/fnum);
c0 = find(cum_freq<freq,1,'last');
c1 = find(cum_freq>freq,1,'first');
length_thresh = interp1(cum_freq(c0:c1),x(c0:c1),freq);
if isempty(figname)~=1
    ymin = 50;
    ymax = 100;
    FreqPercent = freq*100;
    figure;
    plot(x,cum_freq*100,'LineWidth',2)
    set(gca,'YLim',[ymin ymax])
    xlabel('length(km)','FontSize',12)
    ylabel('Percent','FontSize',12)
    hold on
    plot([length_thresh length_thresh],[ymin FreqPercent],'LineStyle','-','Color','k','LineWidth',1)
    plot([0 length_thresh],[FreqPercent FreqPercent],'LineStyle','-','Color','k','LineWidth',1)
    t_string = ['length thresh = ',num2str(length_thresh,'%4.3f'),' km'];
    title(t_string,'FontSize',14)
    print ('-djpeg95','-r300',figname);
    close all
end

end
