function [tmin,tmax,mm] = set_temp_limit(varargin)
% set max and min value of SST based on climatology data automatically
% Input
%   im: month index
%   temp_mean: climatology SST with size of (nx,ny,12)
% Ouput
%   tmin, tmax: max and min value of SST for colormap
%   mm: char of input 'im'
if nargin>2
    error('too many input parameter')
elseif nargin == 2
    im = varargin{1};
    temp_mean = varargin{2};
    temp_month = squeeze(temp_mean(:,:,im));
    tmin = floor(nanmin(temp_month(:)));
    tmax = ceil(nanmax(temp_month(:)));
    switch im
    case 1
        mm = 'Jan';
    case 2
        mm = 'Feb';
    case 3
        mm = 'Mar';
    case 4
        mm = 'Apr';
    case 5
        mm = 'May';
    case 6
        mm = 'Jun';
    case 7
        mm = 'Jul';
    case 8
        mm = 'Aug';
    case 9
        mm = 'Sep';
    case 10
        mm = 'Oct';
    case 11
        mm = 'Nov';
    case 12
        mm = 'Dec';
    end
    
elseif nargin == 1
    im = varargin{1};
    switch im
    case 1
        tmin =15;
        tmax =30;
        mm = 'Jan';
    case 2
        tmin =15;
        tmax =30;
        mm = 'Feb';
    case 3
        tmin =15;
        tmax =30;
        mm = 'Mar';
    case 4
        tmin =18;
        tmax =30;
        mm = 'Apr';
    case 5
        tmin =22;
        tmax =30;
        mm = 'May';
    case 6
        tmin =25;
        tmax =30;
        mm = 'Jun';
    case 7
        tmin =26;
        tmax =30;
        mm = 'Jul';
    case 8
        tmin =26;
        tmax =30;
        mm = 'Aug';
    case 9
        tmin =26;
        tmax =30;
        mm = 'Sep';
    case 10
        tmin =24;
        tmax =30;
        mm = 'Oct';
    case 11
        tmin =20;
        tmax =30;
        mm = 'Nov';
    case 12
        tmin =15;
        tmax =30;
        mm = 'Dec';
    end
    
else
    error('not enough input parameter')
end
