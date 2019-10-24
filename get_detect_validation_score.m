function [varargout] = get_detect_validation_score(temp_zl,grd,flen_crit,thresh_in,logic_morph,front_type)
% get validation scores for daily temp_zl
% to test the sensitivity of length threshold to detection results
if strcmp(front_type,'frontline')
    % use edge localization result as frontline true value
    [tgrad, tangle] = get_front_variable(temp_zl, grd);
    [bw_line_true, ~] = edge_localization(temp_zl, tgrad, tangle, thresh_in);
    % detected frontline
    [tfrontline, bw_line_detect, thresh_out, tgrad, tangle] = front_line(temp_zl, thresh_in, grd, flen_crit, logic_morph);
    fnum = length(tfrontline);
    [frontline_bias, frontline_TS, frontline_FAR, frontline_MR, frontline_FA, frontline_DR] = front_skill_score(bw_line_detect, bw_line_true);
    % front number and mean length
    frontNumber = 0;
    frontLength_sum = 0;
    for ifr = 1:fnum
        fr_length = tfrontline{ifr}.flen;
        if fr_length > flen_crit
            frontLength_sum = frontLength_sum + tfrontline{ifr}.flen;
            frontNumber = frontNumber + 1;
        end
    end
    frontLength_mean = frontLength_sum / frontNumber;
    skill_score =  [frontline_bias, frontline_TS, frontline_FAR, frontline_MR, frontline_FA, frontline_DR];
    for k = 1:6
        varargout{k} =skill_score(k);
    end
    varargout{7} = frontLength_mean*1e-3;
    varargout{8} = frontNumber;
elseif strcmp(front_type,'frontarea')
    % frontarea validation
    % "true" value of frontarea:  pixel with tgrad value greater than high thresh_in
    % "detected" value of frontarea: frontarea patch extracted from detected result
    [tfrontline, ~, thresh_out, tgrad, tangle] = front_line(temp_zl, thresh_in, grd, flen_crit, logic_morph); % get frontline  first
    low_thresh = thresh_out(1);
    high_thresh = thresh_out(2);
    % then get  frontarea
    [~,bw_area_detect] = front_area(tfrontline, tgrad, tangle, grd, thresh_out);
    [tgrad, ~] = get_front_variable(temp_zl, grd);
    % true value
    bw_area_true = zeros(size(temp_zl));
    bw_area_true(tgrad > high_thresh) = 1;
    [frontarea_bias, frontarea_TS, frontarea_FAR, frontarea_MR, frontarea_FA, frontarea_DR] = front_skill_score(bw_area_detect, bw_area_true);
    skill_score = [frontarea_bias, frontarea_TS, frontarea_FAR, frontarea_MR, frontarea_FA, frontarea_DR];
    for k = 1:6
        varargout{k} =skill_score(k);
    end
end


end