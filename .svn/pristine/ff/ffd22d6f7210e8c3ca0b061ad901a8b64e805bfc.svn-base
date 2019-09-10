function plot_binary_image_meshgrid(binary_image,fig_name,visible_switch)
% [bsize,bsize] = size(binary_image)
[bsize,~] = size(binary_image);
if visible_switch
    figure('visible','on')
else
    figure('visible','off')
end
imagesc(binary_image)
caxis([0 1])
colormap(flipud(gray(2)))
axis square
axis ij
grid off
xx = 0.5:1:bsize+0.5;
yy = 0.5:1:bsize+0.5;
blob_mg = meshgrid(xx,yy); %build meshgrid
hold on
plot(xx,blob_mg,'r'); %plot horizontal line
plot(blob_mg,yy,'r'); %plot vertical line
hold on
set(gca,'XTick', []);
set(gca,'YTick', []);
%     text(4,4,'X','FontSize',15)
export_fig(fig_name,'-png','-r300');

end