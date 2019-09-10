function [bw_loc,blob_loc,row_g,col_g] = index_local_to_global(bw_g,r0,c0,gapsize)
% dealing with blob in boundary and return global bw index for blob 
%  
% Input:      
%   bw_g : global binary image derived 
%   r0,c0 : row and column index of endpoint
%   gapsize: same as main function
%
% Ouput:      
%   bw_loc : local bw in the blob
%   blob_loc: blob extent after processing boundary
%   row_g, col_g : global row and col index
% ==============================================
[rows, cols] = size(bw_g);
blob_size = 2*gapsize + 1;
% deal with boundary
rr = [max(1,(r0-gapsize)) : min(rows , (r0+gapsize))];
cc = [max(1,(c0-gapsize)) : min(cols , (c0+gapsize))];
bw_loc = bw_g(rr,cc);
blob_loc = circularstruct(gapsize); 
row_g = zeros(blob_size);
col_g = zeros(blob_size);
% set global row & col index for blob
for i = 1:gapsize
    row_g(gapsize+1-i , :) = r0 - i ;
    row_g(gapsize+1+i , :) = r0 +i;
    row_g(gapsize+1 , :) = r0;
    col_g(: , gapsize+1-i) = c0 - i ;
    col_g(: , gapsize+1+i) = c0 +i;
    col_g(: , gapsize+1) = c0;
end
nan_row = row_g(:,1) < 1 | row_g(:,1) > rows;
nan_col = col_g(1,:) < 1 | col_g(1,:) > cols;
row_g(:,nan_col) = []; row_g(nan_row,:) = [];
col_g(:,nan_col) = []; col_g(nan_row,:) = [];
blob_loc(:,nan_col) = []; blob_loc(nan_row,:) = [];
end % end function index_local_to_global