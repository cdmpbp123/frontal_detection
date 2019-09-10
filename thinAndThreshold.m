function H = thinAndThreshold(E, dx, dy, magGrad, lowThresh, highThresh)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : thinAndThreshold
%
% Perform Non-Maximum Suppression Thining and Hysteresis Thresholding of Edge
% Strength
    
% We will accrue indices which specify ON pixels in strong edgemap
% The array e will become the weak edge map.
idxStrong = [];
for dir = 1:4
    idxLocalMax = cannyFindLocalMaxima(dir,dx,dy,magGrad);
    idxWeak = idxLocalMax(magGrad(idxLocalMax) > lowThresh);
    E(idxWeak)=1;
    idxStrong = [idxStrong; idxWeak(magGrad(idxWeak) > highThresh)]; %
end

[m,n] = size(E);

if ~isempty(idxStrong) % result is all zeros if idxStrong is empty
    rstrong = rem(idxStrong-1, m)+1;
    cstrong = floor((idxStrong-1)/m)+1;
    H = bwselect(E, cstrong, rstrong, 8);
else
    H = zeros(m, n);
end