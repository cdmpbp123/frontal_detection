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

if strcmp(dump_type,'MAT')
    % easy and temporary way, need change to netCDF later
    dtime_str = datestr(grd.time,'yyyymmdd');
    save(fn, ...
        'bw_line', 'bw_area', 'temp_zl', ...
        'grd', 'tfrontline', 'tfrontarea', 'front_parameter', ...
        'thresh_out', 'skip', 'flen_crit', ...
        'datatype', 'smooth_type', 'fntype');
elseif strcmp(dump_type,'netCDF')
    % TBD: the data structure is complex
end

end