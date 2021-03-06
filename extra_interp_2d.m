function var=extra_interp_2d(var)
% interpolate 2D variable, deal with boundary
var0=var;
[J I]=size(var);
for i=2:I-1
    for j=2:J-1
        if isnan(var0(j,i))
            tmpvar(1:3)=var0(j-1:j+1,i+1);
            tmpvar(4:6)=var0(j-1:j+1,i-1);
            tmpvar(7:9)=var0(j-1:j+1,i);
            var(j,i)=squeeze(nanmean(tmpvar'));
        end
    end
end
clear tmpvar
for j=2:J-1
    if isnan(var0(j,1))
        tmpvar(1:3)=var0(j-1:j+1,2);
        tmpvar(4:6)=var0(j-1:j+1,1);
        var(j,1)=nanmean(tmpvar');
    end
end
for j=2:J-1
    if isnan(var0(j,I))
        tmpvar(1:3)=var0(j-1:j+1,I-1);
        tmpvar(4:6)=var0(j-1:j+1,I);
        var(j,I)=nanmean(tmpvar');
    end
end
for i=2:I-1
    if isnan(var0(1,i))
        tmpvar(1:3)=var0(2,i-1:i+1);
        tmpvar(4:6)=var0(1,i-1:i+1);
        var(1,i)=nanmean(tmpvar');
    end
end
for i=2:I-1
    if isnan(var0(J,i))
        tmpvar(1:3)=var0(J-1,i-1:i+1);
        tmpvar(4:6)=var0(J,i-1:i+1);
        var(J,i)=nanmean(tmpvar');
    end
end
clear tmpvar
if isnan(var0(1,1))
    tmpvar(1:2)=var0(1:2,2);
    tmpvar(3)=var0(2,1);
    var(1,1)=nanmean(tmpvar');
end
if isnan(var0(J,1))
    tmpvar(1:2)=var0(J-1:J,2);
    tmpvar(3)=var0(J-1,1);
    var(J,1)=nanmean(tmpvar');
end
if isnan(var0(1,I))
    tmpvar(1:2)=var0(2,I-1:I);
    tmpvar(3)=var0(1,I-1);
    var(1,I)=nanmean(tmpvar');
end
if isnan(var0(J,I))
    tmpvar(1:2)=var0(J-1:J,I-1);
    tmpvar(3)=var0(J-1,I);
    var(J,I)=nanmean(tmpvar');
end
return