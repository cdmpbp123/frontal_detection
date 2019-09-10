function [sector] = sector_dividing8(tangle)
% sector_dividing8:  divide across front direction into 8 domain, the direction points from center point X
% to number 1-8, like:
%------> y
% |   6 5 4
% |   7 X 3
% x  8 1 2
[m,n] = size(tangle);
s1 = find((tangle>= 0 & tangle <= 22.5) | (tangle>22.5+45*7 & tangle < 360));
s2 = find(tangle>=22.5+45*0 & tangle<22.5+45*1);
s3 = find(tangle>=22.5+45*1 & tangle<22.5+45*2);
s4 = find(tangle>=22.5+45*2 & tangle<22.5+45*3);
s5 = find(tangle>=22.5+45*3 & tangle<22.5+45*4);
s6 = find(tangle>=22.5+45*4 & tangle<22.5+45*5);
s7 = find(tangle>=22.5+45*5 & tangle<22.5+45*6);
s8 = find(tangle>=22.5+45*6 & tangle<22.5+45*7);
s0=find(isnan(tangle));

sector=zeros(m,n);
sector(s1)=1;
sector(s2)=2;
sector(s3)=3;
sector(s4)=4;
sector(s5)=5;
sector(s6)=6;
sector(s7)=7;
sector(s8)=8;
sector(s0)=0;
end