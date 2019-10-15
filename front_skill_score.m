function [bias, FTS, FFAR, FPO, FFA] = front_skill_score(bw_detect, bw_true_value)
%{
calculate front detection algorithm skill score
detectability
N11: detect yes; true value yes
N10: detect yes; true value no
N01: detect no; true value yes
N00: detect no; true value no
Skill score variable:
Bias: ratio that detect failure to frontal true value
FTS(Frontal Threat Score): ratio that right detection to total detection
FFAR(Frontal false alarm ratio)
FPO(frontal false positive)
FFA(frontal detect accuracy)

%}
if length(bw_detect(:)) ~= length(bw_true_value(:))
    error('length of detected result and true value do not match!')
end
N11 = 0;
N10 = 0;
N01 = 0;
N00 = 0;

for i = 1:length(bw_detect(:))
    
    if bw_detect(i) == 1 && bw_true_value(i) == 1
        N11 = N11 + 1;
    elseif bw_detect(i) == 1 && bw_true_value(i) ~= 1
        N10 = N10 + 1;
    elseif bw_detect(i) ~= 1 && bw_true_value(i) == 1
        N01 = N01 + 1;
    elseif bw_detect(i) ~= 1 && bw_true_value(i) ~= 1
        N00 = N00 + 1;
    end
    
end

bias = (N01 + N10) / (N11 + N01);
FTS = N11 / (N11 + N01 + N10);
FFAR = N10 / (N11 + N10);
FPO = N01 / (N11 + N01);
FFA = N11 / (N11 + N10);


end