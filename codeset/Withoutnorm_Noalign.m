function a = Withoutnorm_Noalign(method, array, reLen, name, data, label, char2, char3, resizedseg_dir, subname)
% 等长不对齐不归一化
foldername = strcat(method,'_',char2{2},'_',char3{2});
if ~exist(strcat(resizedseg_dir,foldername),'file')  
    mkdir(strcat(resizedseg_dir,foldername))                %新建文件夹存放该方法下的分割数据
end
segpath = strcat(resizedseg_dir,foldername,'\');
p1 = array;
% [maximum, index] = max(abs(p1));
% leftlen = index;                                          % 最大值左边长度
% rightlen = length(p1) - index;                            % 最大值右边长度       
% [zm, len1, len2] = rescale(leftlen, rightlen, reLen);     % zm为缩放因子
redata = imresize(data, [4 reLen], method);                 % 'nearest', 'bilinear', 'bicubic'
p2 = sum(redata)/max(abs(sum(redata))); 
% maxindex =round(index*zm);
% savedata = redata(:,abs(maxindex-len1)+1:maxindex+len2);
savedata = redata;
% savedata = mapminmax(savedata,-1,1);                      % 按行对幅值归一化
if ~exist(strcat(segpath,subname),'file')  
    mkdir(strcat(segpath,subname))                            %新建文件夹存放样本数据
end
savepath = strcat(segpath,subname,'\');
save([savepath, name],'savedata','label');                  % 保存数据
a = 'Complete Method: Withoutnorm_Noalign';