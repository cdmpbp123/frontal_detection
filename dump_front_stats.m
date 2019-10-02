function dump_front_stats(varargin)
% dump front detection statistic information to file
%

%dumping file type: 'MAT' or 'netCDF'
dump_type = varargin{1}; 
% output filename (full path)
fn = varargin{2}; 
% sst variable (array)
[bw, temp_zl] = varargin{3:4};
% struct variable
[grd, tfrontline, tfrontarea, info_area ] = varargin{5:8};
% front detection parameter (array)
[thresh_out, skip, flen_crit ] = varargin{9:11};
% front detection parameter (string)
[datatype, smooth_type, fntype] = varargin{12:14};

if strcmp(dump_type,'MAT')
    % easy and temporary way, need change to netCDF later
    dtime_str = datestr(grd.time,'yyyymmdd');
    save(fn, 'bw', 'temp_zl', ...
        'grd', 'tfrontline', 'tfrontarea', 'info_area', ...
        'thresh_out', 'skip', 'flen_crit', ...
        'datatype', 'smooth_type', 'fntype');
elseif strcmp(dump_type,'netCDF')
    % TBD: the data structure is complex
end

end