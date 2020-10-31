function a = MergeSampls(featurepath, mergename, mergepath)
% 合并文件为一个，以进行交叉验证
feature_list = dir(strcat(featurepath, '\', 'wave_*'));
count = 0;
for i = 6:length(feature_list)
    load([featurepath, '\',feature_list(i).name]);
    count = count + length(lab);
end 
wave_total = zeros(size(wave,1),count);
lab_total = zeros(1,count);
current = 1;
for i = 6:length(feature_list)-1
    load([featurepath, '\',feature_list(i).name]);
    wave_total(:,current:current+length(lab)-1) = wave;
    lab_total(1,current:current+length(lab)-1) = lab;  
    current = current + length(lab);
end
wave = wave_total;
lab = lab_total;

save([mergepath,mergename],'wave','lab');
a = 'Merge complete!';