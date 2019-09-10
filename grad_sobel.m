function [xgrad,ygrad] = grad_sobel(var,pm,pn,mask)
% Caculate gradient with Sobel method
% Input:
% var: variable for calculating (all NaN value need to interpolate)
% pm: 1/dx, along longitude dimension
% pn: 1/dy, along latitude dimension
% mask: land/ocean mask suitable for var
% Output:
% xgrad: gradient in X direction (longitude)
% ygrad: gradient in Y direction (latitude)

%%
% cff =  [1 0 -1; 2 0 -2; 1 0 -1];
% cff =  [-1 0 1; -2 0 2; -1 0 1];
cff = fspecial('sobel');
xgrad = conv2(var,cff,'same') / 8;
ygrad = conv2(var,cff','same') / 8;
xgrad = xgrad .* pm * 1000;
ygrad = ygrad .* pn * 1000;
xgrad(:,1)=NaN;xgrad(:,end)=NaN;
xgrad(1,:)=NaN;xgrad(end,:)=NaN;
ygrad(:,1)=NaN;ygrad(:,end)=NaN;
ygrad(1,:)=NaN;ygrad(end,:)=NaN;
xgrad(mask==0)=NaN;
ygrad(mask==0)=NaN;
end