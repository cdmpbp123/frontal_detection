function [neigh_prow,neigh_pcol]=find_sector_neighbor(p_sector,prow,pcol,type)
%横锋方向
%------> y
% |   2 1 4
% |   3 X 3
% x  4 1 2
%
if strcmp(type,'along')
%根据梯度方向，获取该点的沿梯度方向相邻两点的位置
    if p_sector==1
        neigh_prow=[prow,prow];
        neigh_pcol=[pcol+1,pcol-1];
    elseif p_sector==2
        neigh_prow=[prow+1,prow-1];
        neigh_pcol=[pcol-1,pcol+1];
    elseif p_sector==3
        neigh_prow=[prow+1,prow-1];
        neigh_pcol=[pcol,pcol];
    elseif p_sector==4
        neigh_prow=[prow+1,prow-1];
        neigh_pcol=[pcol+1,pcol-1];
    end
elseif strcmp(type,'across')
%根据梯度方向，获取该点的梯度方向相邻两点的位置
    if p_sector==1
        neigh_prow=[prow+1,prow-1];
        neigh_pcol=[pcol,pcol];
    elseif p_sector==2
        neigh_prow=[prow+1,prow-1];
        neigh_pcol=[pcol+1,pcol-1];
    elseif p_sector==3
        neigh_prow=[prow,prow];
        neigh_pcol=[pcol+1,pcol-1];
    elseif p_sector==4
        neigh_prow=[prow+1,prow-1];
        neigh_pcol=[pcol-1,pcol+1];
    end
end