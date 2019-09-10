function [var_smooth]=variable_preprocess(var,smooth_type,fill_value,sigma,N)
% variable preprocess - extra_interpolation and smooth with operator
%
% Input:
%   var - chosen variable 
%   smooth_type - smooth scheme ('average', 'gaussian', 'no_smooth')
%   fill_value - filled value of 'var'
%   sigma - gaussian smooth parameter
%   N - gaussian smooth parameter
%
% Output:
%   var_smooth - output variable
%
%%
if nargin < 4
    sigma = 2;
    if nargin < 5
        N = 2;
    end
end
if ndims(var)~=2
    error(message('variable dimension must be equal to 2'))
end
[m,n]=size(var);
mask=ones(m,n);
% create mask for var
mask(var==fill_value | isnan(var)==1)=0;
var1=var;
% need to mask land as NaN for extrapolation
var1(mask==0)=NaN;
% the time of extrapolate equals to filter window
for nt=1:2*N+1
    nan_number=length(find(isnan(var1(:))==1));
    if nan_number~=0
        [var1]=extra_interp_2d(var1);    
    else
        break
    end
end
if strcmp(smooth_type,'average')
    var_smooth=filter2(fspecial('average',2*N+1),var1);
elseif strcmp(smooth_type,'gaussian')
    N_row = 2*N+1;
    gausFilter = fspecial('gaussian',[N_row N_row],sigma);
    var_smooth = imfilter(var1,gausFilter,'conv');
elseif strcmp(smooth_type,'no_smooth') 
    var_smooth=var1;
end
    %replace  boundary value with old variable
    var_smooth(1:N,:)=var1(1:N,:);
    var_smooth(end-N+1:end,:)=var1(end-N+1:end,:);
    var_smooth(:,1:N)=var1(:,1:N);
    var_smooth(:,end-N+1:end)=var1(:,end-N+1:end);