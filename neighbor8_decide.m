function [logic_neighbor]=neighbor8_decide(row1,col1,row2,col2)
%
%
if (abs(row1-row2)>1 || abs(col1-col2)>1 )
    logic_neighbor=0;
elseif (row1==row2) && (col1==col2)
    logic_neighbor=0;
else
    logic_neighbor=1;
end

end