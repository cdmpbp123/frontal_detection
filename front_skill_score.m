function [bias, TS, FAR, MR, FA, DR] = front_skill_score(bw_detect, bw_true_value, doTest)
%{
calculate front detection algorithm detectability introducing skill scores from meterology
categorical charts of front detection:
    N11: detect yes; true value yes
    N10: detect yes; true value no
    N01: detect no; true value yes
    N00: detect no; true value no
Skill score variable:
    Bias: ratio of detect failure to frontal true valueï¼?(N01 + N10) / (N11 + N01);
    TS(Threat Score): ratio of correct detection to total detection and true value
    FAR(False Alarm Rate): ratio of false detected to total detected pixels
    MR(Miss Rate): ratios of miss detected to total true value pixels
    FA(Forecast Accuracy): ratio of correct detection to total detection
    DR(Detectability Rate): ratio of total detect pixels to total true value pixels
%}
if nargin == 3
    test = doTest;
else
    test = 0;
end
if length(bw_detect(:)) ~= length(bw_true_value(:))
    error('length of detected result and true value do not match!')
end
N11 = 0;
N10 = 0;
N01 = 0;
N00 = 0;
[nx,ny] = size(bw_detect);
if test
    forecast_mesh = ones(size(bw_detect))*NaN;
    for i=1:nx
        for j=1:ny
            if bw_detect(i,j) == 1 && bw_true_value(i,j) == 1
                forecast_mesh(i,j) = 1; % true forecast
            elseif bw_detect(i,j) == 1 && bw_true_value(i,j) == 0
                forecast_mesh(i,j) = 2; % false forecast
            elseif bw_detect(i,j) == 0 && bw_true_value(i,j) == 1
                forecast_mesh(i,j) = 3; % missing forecast
            elseif bw_detect(i,j) == 0 && bw_true_value(i,j) == 0
                forecast_mesh(i,j) = 0; % forecast and obs no front
            elseif bw_true_value(i,j) == -1
                forecast_mesh(i,j) = -1; % cloud mask
            end
        end
    end
    figure
    pcolor((forecast_mesh))
    h = colorbar;
    colormap(jet(5))
    set(h,'ticks',(-1:1:3),'fontsize',8,'ticklabels',{'Cloud','No front','True','False','Miss'});
end

for i = 1:length(bw_detect(:))
    
    if bw_detect(i) == 1 && bw_true_value(i) == 1
        N11 = N11 + 1;
    elseif bw_detect(i) == 1 && bw_true_value(i) == 0
        N10 = N10 + 1;
    elseif bw_detect(i) == 0 && bw_true_value(i) == 1
        N01 = N01 + 1;
    elseif bw_detect(i) ~= 1 && bw_true_value(i) ~= 1
        N00 = N00 + 1;
    end
    
end

bias = (N01 + N10) / (N11 + N01);
TS = N11 / (N11 + N01 + N10);
FAR = N10 / (N11 + N10);
MR = N01 / (N11 + N01);
FA = N11 / (N11 + N10);

num_true = length(find(bw_true_value(:) == 1));
num_detect = length(find(bw_detect(:) == 1));
% total detect rate
DR = num_detect / num_true;

end