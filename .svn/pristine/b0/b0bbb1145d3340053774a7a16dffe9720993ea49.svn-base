function [neighbor_info,neigh_num]=find_neighbor_info(bw,row,col)
%
%
% narginchk(1,3)
if (nargin == 1)
    row=[];
    col=[];
    [m,n]=size(bw);
    neighbor_num=zeros(m,n);
    for im=2:m-1
        for in=2:n-1
            if bw(im,in)==1
            bw_neighbor =[bw(im-1,in-1), bw(im-1,in), bw(im-1,in+1);
               bw(im,in-1),    bw(im,in),   bw(im,in+1);
               bw(im+1,in-1), bw(im+1,in), bw(im+1,in+1)];
            tmp=find(bw_neighbor==1);
            neighbor_num(im,in)=length(tmp)-1;
            else
            end
        end
    end
    neighbor_info.num=neighbor_num;
elseif (nargin ==3)
    if length(row)~=length(col)
         error(message('dimension of row and column not equal'))
    end
    for i=1:length(row)
        r=row(i);
        c=col(i);
        bw_neighbor_row=[r-1:r+1,r-1:r+1,r-1:r+1];
        bw_neighbor_col=[(c-1)*ones(1,3),(c)*ones(1,3),(c+1)*ones(1,3)];
        bw_neighbor=bw(r-1:r+1,c-1:c+1);
        bw_neighbor_row(5)=[];
        bw_neighbor_col(5)=[];
        bw_neighbor(5)=[];
        tmp=find(bw_neighbor==1);
        neighbor_info{i}.row=bw_neighbor_row(tmp);
        neighbor_info{i}.col=bw_neighbor_col(tmp);
        neigh_num(i)=length(tmp); 
        neighbor_info{i}.num=length(tmp);  
    end
end


end
