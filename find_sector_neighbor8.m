function [neigh_prow,neigh_pcol] = find_sector_neighbor8(p_sector,prow,pcol,type)
% find_sector_neighbor8: Searching neighbor pixels of center pixel 
%       according to gradient direction (p_sector)
%  this function provide two search direction: along-front direction 
%       and across-front direction
% Input:
%   p_sector - gradient direction index based on sector_dividing8.m
%   prow -  row index for frontal center line pixel 
%   pcol - column index for frontal center line pixel
%   type - searching type: along-front or across-front
% Ouput:
%   neigh_prow - row index for neighbor pixel 
%   neigh_pcol - column index for neighbor pixel
if strcmp(type,'along')
    % searching two neighbor pixels in along-front direction
    % NOTICE: the output neighbor pixel have order - [left right] when stand face towards the gradient direction
    if p_sector == 1
        neigh_prow = [prow,prow];
        neigh_pcol = [pcol+1,pcol-1];
    elseif p_sector == 2
        neigh_prow = [prow-1,prow+1];
        neigh_pcol = [pcol+1,pcol-1];
    elseif p_sector == 3
        neigh_prow = [prow-1,prow+1];
        neigh_pcol = [pcol,pcol];
    elseif p_sector == 4
        neigh_prow = [prow-1,prow+1];
        neigh_pcol = [pcol-1,pcol+1];
    elseif p_sector == 5
        neigh_prow = [prow,prow];
        neigh_pcol = [pcol-1,pcol+1];
    elseif p_sector == 6
        neigh_prow = [prow+1,prow-1];
        neigh_pcol = [pcol-1,pcol+1];
    elseif p_sector == 7
        neigh_prow = [prow+1,prow-1];
        neigh_pcol = [pcol,pcol];
    elseif p_sector == 8
        neigh_prow = [prow+1,prow-1];
        neigh_pcol = [pcol+1,pcol-1];
    else
        neigh_prow = [];
        neigh_pcol = [];
    end
elseif strcmp(type,'across')
    % searching two neighbor pixels in across-front direction
    % NOTICE: the output neighbor pixel have order - [back front] when stand face towards gradient direction
    if p_sector == 1
        neigh_prow = [prow-1,prow+1];
        neigh_pcol = [pcol,pcol];
    elseif p_sector == 2
        neigh_prow=[prow-1,prow+1];
        neigh_pcol=[pcol-1,pcol+1];
    elseif p_sector == 3
        neigh_prow = [prow,prow];
        neigh_pcol = [pcol-1,pcol+1];
    elseif p_sector == 4
        neigh_prow = [prow+1,prow-1];
        neigh_pcol = [pcol-1,pcol+1];
    elseif p_sector == 5
        neigh_prow=[prow+1,prow-1];
        neigh_pcol=[pcol,pcol];
    elseif p_sector == 6
        neigh_prow = [prow+1,prow-1];
        neigh_pcol = [pcol+1,pcol-1];
    elseif p_sector == 7
        neigh_prow = [prow,prow];
        neigh_pcol = [pcol+1,pcol-1];
    elseif p_sector == 8
        neigh_prow = [prow-1,prow+1];
        neigh_pcol = [pcol+1,pcol-1];
    else
        neigh_prow = [];
        neigh_pcol = [];
    end
end