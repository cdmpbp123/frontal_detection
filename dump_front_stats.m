function dump_front_stats(varargin)
% dump front detection statistic information to file
%
%dumping file type: 'MAT' or 'netcdf'
dump_type = varargin{1};
% output filename (with full path)
fn = varargin{2};
% 2D variable (array)
[bw_line, bw_area, temp_zl] = varargin{3:5};
% struct variable
[grd, tfrontline, tfrontarea, front_parameter ] = varargin{6:9};
% front detection parameter (array)
[thresh_out, skip, flen_crit ] = varargin{10:12};
% front detection parameter (string)
[datatype, smooth_type, fntype] = varargin{13:15};
%
[nx,ny] = size(temp_zl);
lon = grd.lon_rho;
lat = grd.lat_rho;
mask = grd.mask_rho;
low_thresh = thresh_out(1);
high_thresh = thresh_out(2);
length_thresh = thresh_out(3);
[tgrad, tangle] = get_front_variable(temp_zl,grd);
date_num = grd.time;

if strcmp(dump_type,'MAT')
    % easy and temporary way, need change to netCDF later
    dtime_str = datestr(grd.time,'yyyymmdd');
    save(fn, ...
        'bw_line', 'bw_area', 'temp_zl', ...
        'grd', 'tfrontline', 'tfrontarea', 'front_parameter', ...
        'thresh_out', 'skip', 'flen_crit', ...
        'datatype', 'smooth_type', 'fntype');
elseif strcmp(dump_type,'netcdf')
    low_freq = 0.8;
    high_freq = 0.9;
    length_freq = 0.7;
    temp_zl(mask == 0) = NaN;
    tgrad(mask == 0) = NaN;
    tangle(mask == 0) = NaN;
    bw_line(mask == 0) = NaN;
    bw_area(mask == 0) = NaN;
    fnum = length(front_parameter);
    for ifr = 1:fnum
        flen(ifr) = front_parameter{ifr}.length;
        line_tgrad_mean(ifr) = front_parameter{ifr}.line_tgrad_mean;
        mid_lat(ifr) = front_parameter{ifr}.line_mid_lat;
        mid_lon(ifr) = front_parameter{ifr}.line_mid_lon;
        area(ifr) = front_parameter{ifr}.area;
        mean_width(ifr) = front_parameter{ifr}.mean_width;
        max_width(ifr) = front_parameter{ifr}.max_width;
        equivalent_width(ifr) = front_parameter{ifr}.equivalent_width;
        area_tgrad_mean(ifr) = front_parameter{ifr}.area_tgrad_mean;
    end
    delete(fn)
    % create variable with defined dimension
    % variable with 2-dimenson [nx,ny]
    nccreate(fn,'lon','Dimensions' ,{'nx' nx 'ny' ny},'datatype','double','format','classic')
    nccreate(fn,'lat','Dimensions' ,{'nx' nx 'ny' ny},'datatype','double','format','classic')
    nccreate(fn,'mask','Dimensions',{'nx' nx 'ny' ny},'datatype','double','format','classic')
    nccreate(fn,'temp_zl','Dimensions',{'nx' nx 'ny' ny},'datatype','double','format','classic')
    nccreate(fn,'tgrad','Dimensions',{'nx' nx 'ny' ny},'datatype','double','format','classic')
    nccreate(fn,'tangle','Dimensions',{'nx' nx 'ny' ny},'datatype','double','format','classic')
    nccreate(fn,'bw_line','Dimensions',{'nx' nx 'ny' ny},'datatype','double','format','classic')
    nccreate(fn,'bw_area','Dimensions',{'nx' nx 'ny' ny},'datatype','double','format','classic')
    % variable with 1-dimension fnum
    nccreate(fn,'flen','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'line_tgrad_mean','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'mid_lat','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'mid_lon','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'area','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'mean_width','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'max_width','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'equivalent_width','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    nccreate(fn,'area_tgrad_mean','Dimensions' ,{'fnum' fnum},'datatype','double','format','classic')
    % variable of constant value
    nccreate(fn,'date_num','Dimensions' ,{'one' 1},'datatype','double','format','classic')
    nccreate(fn,'low_thresh','Dimensions' ,{'one' 1},'datatype','double','format','classic')
    nccreate(fn,'high_thresh','Dimensions' ,{'one' 1},'datatype','double','format','classic')
    nccreate(fn,'length_thresh','Dimensions' ,{'one' 1},'datatype','double','format','classic')
    nccreate(fn,'low_freq','Dimensions' ,{'one' 1},'datatype','double','format','classic')
    nccreate(fn,'high_freq','Dimensions' ,{'one' 1},'datatype','double','format','classic')
    nccreate(fn,'length_freq','Dimensions' ,{'one' 1},'datatype','double','format','classic')
    %
    % write variable into files
    ncwrite(fn,'lon',lon)
    ncwrite(fn,'lat',lat)
    ncwrite(fn,'mask',mask)
    ncwrite(fn,'temp_zl',temp_zl)
    ncwrite(fn,'tgrad',tgrad)
    ncwrite(fn,'tangle',tangle)
    ncwrite(fn,'bw_line',bw_line)
    ncwrite(fn,'bw_area',bw_area)
    % variable with 1-dimension fnum
    ncwrite(fn,'flen',flen)
    ncwrite(fn,'line_tgrad_mean',line_tgrad_mean)
    ncwrite(fn,'mid_lat',mid_lat)
    ncwrite(fn,'mid_lon',mid_lon)
    ncwrite(fn,'area',area)
    ncwrite(fn,'mean_width',mean_width)
    ncwrite(fn,'max_width',max_width)
    ncwrite(fn,'equivalent_width',equivalent_width)
    ncwrite(fn,'area_tgrad_mean',area_tgrad_mean)
    % variable of constant value
    ncwrite(fn,'date_num',date_num)
    ncwrite(fn,'low_thresh',low_thresh)
    ncwrite(fn,'high_thresh',high_thresh)
    ncwrite(fn,'length_thresh',length_thresh)
    ncwrite(fn,'low_freq',low_freq)
    ncwrite(fn,'high_freq',high_freq)
    ncwrite(fn,'length_freq',length_freq)
    %
    % write file global attribute
    ncwriteatt(fn,'/','creation_date',datestr(now))
    ncwriteatt(fn,'/','data_source',[datatype,' ',fntype])
    ncwriteatt(fn,'/','description','NetCDF daily output of front detection result')
    ncwriteatt(fn,'/','grid skip number',num2str(skip))
    ncwriteatt(fn,'/','smooth_type',smooth_type)
end

end