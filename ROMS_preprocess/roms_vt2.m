function [zlevel] = roms_vt2(sc_r,Cs_r,h,zeta,hc)
%Vertical coordinate transformation
%
[x,y] = size(h);
for m = 1:x
    for n = 1:y
        S = (hc * sc_r + h(m,n) * Cs_r) ./ (hc + h(m,n));
        zlevel(m,n,:) = zeta(m,n) + (zeta(m,n) + h(m,n)) * S;
    end
end
      
