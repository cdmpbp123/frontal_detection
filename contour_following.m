function C = contour_following(BW)
% CONTOUR_FOLLOWING takes a binary array and returns the sorted row and
% column coordinates of contour pixels.
%
% C = CONTOUR_FOLLOWING(BW) takes BW as an input. BW is a binary array
% containing the image of an object ('1': foreground, '0': background). It
% returns a circular list (N x 2, C(1,:)=C(end,:)) of the 
% (row,column)-coordinates of the object's contour, in the order of 
% appearence (This function was inspired from the freeman contour coding 
% algorithm).
%

[m,n]=size(BW);                                                            % getting the image height and width

Itemp=zeros(m+2,n+2);                                                      % we create a '0' frame around the image to avoid border problems
Itemp(2:(m+1),2:(n+1))=BW;
BW=Itemp;

BW = BW - imerode(BW,[0 1 0 ; 1 1 1 ; 0 1 0]);                             % gets the contour by substracting the erosion to the image
BW = bwmorph(BW,'thin',Inf);                                               % to be sure to have strictly 8-connected contour


[row,col]=find(BW,1);                                                    % takes the first encountered '1' pixel as the starting point of the contour

MAJ=[6 6 0 0 2 2 4 4];                                                     % variable initialization
C=[0 0 ; 0 0];
k = 0;
ended = 0;
isclosed = 0;
direction = 4;

while(ended==0),
    k = k + 1;
    found_next=0;  
    
    while(found_next==0),
        switch mod(direction,8),
            case 0,
                if (BW(row, col+1)==1)
                    row=row;
                    col=col+1;
                    C(k,:)=[row col];
                    found_next=1;
                end;
            case 1;
                if (BW(row+1, col+1)==1)
                    row=row+1;
                    col=col+1;
                    C(k,:)=[row col];
                    found_next=1;
                end;
            case 2;
                if (BW(row+1, col)==1) 
                    row=row+1;
                    col=col;
                    C(k,:)=[row col];
                    found_next=1;
                end;
            case 3;
                if (BW(row+1, col-1)==1) 
                    row=row+1;
                    col=col-1;
                    C(k,:)=[row col];
                    found_next=1;
                end;
            case 4;
                if (BW(row, col-1)==1) 
                    row=row;
                    col=col-1;
                    C(k,:)=[row col];
                    found_next=1;
                end;
            case 5;
                if (BW(row-1, col-1)==1) 
                    row=row-1;
                    col=col-1;
                    C(k,:)=[row col];
                    found_next=1;
                end;
            case 6;
                if (BW(row-1, col)==1) 
                    row=row-1;
                    col=col;
                    C(k,:)=[row col];
                    found_next=1;
                end;
            case 7;
                if (BW(row-1, col+1)==1) 
                    row=row-1;
                    col=col+1;
                    C(k,:)=[row col];
                    found_next=1;
                end;
                
        end

        if (found_next==0)
            direction = direction + 1;
            if direction > 12
                found_next = 1;
            end
        end;
        
    end
    
    if(((length(C) > 3) && (C(1,1) == C(end-1,1)) && (C(1,2) == C(end-1,2)) ...
            && (C(2,1) ==  C(end,1)) && (C(2,2) ==  C(end,2))))
        ended = 1;
        isclosed = 1;
    elseif (direction > 12)
        ended = 1; 
    end;
    
    direction = MAJ((mod(direction,8)+1));

end

if isclosed == 1
    C=C(1:(end-1),:);                                                          % the first and last points in the list are the same (circular list)
    C=C-1;
elseif (length(C) > 3)
    C=C(1:(end),:);                                                          % the first and last points in the list are the same (circular list)
    C=C-1;
else
    clear C
    C(1,1) = row - 1;
    C(1,2) = col - 1;
end