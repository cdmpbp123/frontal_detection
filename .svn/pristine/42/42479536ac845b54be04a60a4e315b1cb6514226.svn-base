%
function [t_z] = roms3d_s2z(sc_r,Cs_r,Tcline,zeta,h,t_s,zl)
%
zlevel = squeeze(roms_vt2(sc_r,Cs_r,h,zeta,Tcline));

[x,y,z] = size(t_s);
for m = 1:x
    for n = 1:y
        if ~isnan(t_s(m,n,1))
            t_z(m,n) = interp1(squeeze(zlevel(m,n,:) - zlevel(m,n,end)) * -1,squeeze(t_s(m,n,:)),zl);
        else
            t_z(m,n) = NaN;
        end
    end
end
