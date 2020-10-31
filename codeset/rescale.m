function [zm, fewpart, mostpart] = rescale(leftlen, rightlen, len)
% 计算伸缩因子,segment最高对齐后，等长处理中或多或少要舍弃一部分数据数据
fewpart = fix(1/4*len)-1;
mostpart = len - fewpart;

% 计算伸缩因子
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