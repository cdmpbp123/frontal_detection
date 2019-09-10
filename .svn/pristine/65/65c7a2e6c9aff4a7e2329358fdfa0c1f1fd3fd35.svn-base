function [tgrad, tangle] = get_front_variable(temp_zl,grd)
% variable direction
%------> y
% |   6 5 4
% |   7 X 3
% x  8 1 2
[txgrad,tygrad] = grad_sobel(temp_zl,grd.pm,grd.pn,grd.mask_rho);
tgrad = sqrt(txgrad .^ 2 + tygrad .^ 2);
tangle = atan2d(tygrad,txgrad); % across-front direction
mk = find( tangle < 0 );
tangle(mk) = tangle(mk) + 360 ;
end