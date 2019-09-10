function [sector]=sector_dividing(tangle)
% sector：将锋面梯度方向（横锋方向）分为4个区域，具体如下
    %------> y
    % |   2 1 4
    % |   3 X 3
    % x  4 1 2      
    [m,n]=size(tangle);
    s2=find((tangle>=22.5 & tangle<67.5) | ...
                 (tangle>=22.5-180 & tangle<67.5-180));
    s3=find((tangle>=67.5 & tangle<112.5) | ...
                (tangle>=67.5-180 & tangle<112.5-180));
    s4=find((tangle>=112.5 & tangle<157.5) | ... 
                 (tangle>=112.5-180 & tangle<157.5-180));
    s1=find((tangle>=-22.5 & tangle<=22.5) | ... 
                   (tangle>=157.5 & tangle <180) | ...
                   (tangle>=-180 & tangle < 22.5-180));
    s0=find(isnan(tangle));
    
    sector=zeros(m,n);
    sector(s1)=1;
    sector(s2)=2;
    sector(s3)=3;
    sector(s4)=4;
    sector(s0)=0;
end