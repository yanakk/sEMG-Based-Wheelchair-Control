function a = Norm_Align(method, array, reLen, name, data, label, char2, char3, resizedseg_dir)
% �ȳ������һ��
foldername = strcat(method,'_',char2{1},'_',char3{1});
if ~exist(strcat(resizedseg_dir,foldername),'file')  
    mkdir(strcat(resizedseg_dir,foldername))              %�½��ļ��д�Ÿ÷����µķָ�����
end
segpath = strcat(resizedseg_dir,foldername,'\');
p1 = array;
[maximum, index] = max(abs(p1));
leftlen = index;                                          % ���ֵ��߳���
rightlen = length(p1) - index;                            % ���ֵ�ұ߳���       
[zm, len1, len2] = rescale(leftlen, rightlen, reLen);     % zmΪ��������
redata = imresize(data, [4 length(p1)*zm], method);       % 'nearest', 'bilinear', 'bicubic'
p2 = sum(redata)/max(abs(sum(redata))); 
maxindex =round(index*zm);
savedata = redata(:,abs(maxindex-len1)+1:maxindex+len2);
savedata = mapminmax(savedata,-1,1);                      % ���жԷ�ֵ��һ��
if ~exist(strcat(segpath,label),'file')  
    mkdir(strcat(segpath,label))                          %�½��ļ��д����������
end
savepath = strcat(segpath,label,'\');
save([savepath, name],'savedata','label');                % ��������
a = 'Complete Method: Norm_Align';