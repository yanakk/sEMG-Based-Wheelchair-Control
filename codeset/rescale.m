function [zm, fewpart, mostpart] = rescale(leftlen, rightlen, len)
% ������������,segment��߶���󣬵ȳ������л�����Ҫ����һ������������
fewpart = fix(1/4*len)-1;
mostpart = len - fewpart;

% ������������
if leftlen<fewpart && rightlen<mostpart
    zm = max(fewpart/leftlen, mostpart/rightlen);
elseif leftlen<fewpart && rightlen>=mostpart
    zm = fewpart/leftlen;
elseif leftlen>=fewpart && rightlen<mostpart
    zm = mostpart/rightlen;
elseif leftlen>fewpart && rightlen>mostpart
    zm = max(fewpart/leftlen, mostpart/rightlen);
elseif leftlen>fewpart && rightlen==mostpart
    zm = 1;%fewpart/leftlen;
elseif leftlen==fewpart && rightlen>mostpart
    zm = 1;%mostpart/rightlen;
elseif leftlen == fewpart && rightlen == mostpart
    zm =1;
end