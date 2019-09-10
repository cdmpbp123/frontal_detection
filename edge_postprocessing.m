% postprocessing
function [M_final,bw_final] = edge_postprocessing(M_merge,bw_merge,grd,flen_crit,logic_morph,min_length_pixel)
%去除长度（像素点）小于min_length_pixel
if nargin<8
    min_length_pixel = 3;
end
bw_flen=zeros(size(bw_merge));
bw_final=zeros(size(bw_merge));
fnum = 0;
for ifr=1:length(M_merge)
    row = M_merge{ifr}.row;
    col = M_merge{ifr}.col;
    flen = M_merge{ifr}.flen;
    if length(row) >= min_length_pixel && flen > flen_crit
        fnum = fnum +1;
        M_final{fnum}=M_merge{ifr};
        for ip = 1:length(row)
            bw_flen(row(ip),col(ip))=1;
        end       
    end
end
if logic_morph
    % deal with morphology operator to connect neighbor segment
    %bw2=bwmorph(bw1,'close',Inf);  
    % close操作会将非锋面点改为锋面点，在后续操作会报错， 
end
bw_final = bw_flen;
end