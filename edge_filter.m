function [M_filter,bw_filter] = edge_filter(M,bw,filter_pixel_length)
% edge_filter
%
fr_num_filter = 1;
bw_filter = zeros(size(bw));
for ifr = 1:length(M)
    if length(M{ifr}.row) > filter_pixel_length
        r=M{ifr}.row;
        c=M{ifr}.col;
        for ip=1:length(r)
            bw_filter(r(ip),c(ip))=1;
        end
        M_filter{fr_num_filter} = M{ifr};
        fr_num_filter = fr_num_filter +1;
    end
end

end  % end function 