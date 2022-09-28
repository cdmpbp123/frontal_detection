function [front_depth] = get_front_depth(temp_3d,grd,bw_area,thresh,depth_level)
    % get front depth from each pixel of front area

    [m,n,k] = size(temp_3d);
    tgrad_3d = zeros(size(temp_3d));
    for zz=1:k
        mask_z = zeros(m,n);
        t_z = squeeze(temp_3d(:,:,zz));
        mask_z(~isnan(t_z))=1;
        [txgrad,tygrad] = grad_sobel(t_z,grd.pm,grd.pn,mask_z);
        tgrad = sqrt(txgrad .^ 2 + tygrad .^ 2);        
        tgrad_3d(:,:,zz) = tgrad;
        clear mask_z t_z
        clear txgrad tygrad tgrad
    end

    front_depth = zeros(m,n);
    for i=1:m
        for j=1:n
            if bw_area(i,j) == 1
                tgrad_z = squeeze(tgrad_3d(i,j,:));
                kz = find(tgrad_z>thresh,1,'last');
                if isnan(tgrad_z(kz+1))
                    front_depth(i,j) = depth_level(kz);
                elseif tgrad_z(kz+1)<thresh & tgrad_z(kz)>thresh
                    front_depth(i,j) = interp1(tgrad_z(kz:kz+1),depth_level(kz:kz+1),thresh);
                else
                    
                end
            end
        end
    end
    


end