% main.m是运行文件,其他为子程序
% 2018.1.6 张明
clc;
clear;
close all;

% 预定义参数或变量
len = 500;                                      % resize长度
wlen=30;                                        % 帧长
wnd=hamming(wlen);                              % 设置窗函数
inc=15;                                         % 帧移
fs = 1000;                                      % 采样率
PredictResult = zeros(1,1);                     % 存放最终结果

char1 = {'bicubic','bilinear','nearest'};       % 三种插值方法
char2 = {'Norm','Withoutnorm'};                 % 是否进行了归一化
char3 = {'Align','Noalign'};                    % 是否最高对齐
char4 = {'PCA','LDA','NoReduce'};               % 降维选择，有PCA、LDA以及不降维
  
autoseg_dir = '..\autoseg\';                    % 切割数据文件路径
mkdir(strcat('..\','png'))                      % 新建图片文件夹
png_dir = '..\png\';                            % 图片文件夹路径
mkdir(strcat('..\','resizedseg'))               % 新建数据文件夹
resizedseg_dir = '..\resizedseg\';              % 数据文件夹路径
mkdir(strcat('..\','feature'))                  % 新建特征文件夹
feature_dir = '..\feature\';                    % 特征文件夹路径
mkdir(strcat('..\','merge'))                    % 新建特征文件夹
merge_dir = '..\merge\';                        % 特征文件夹路径
mkdir(strcat('..\','result'))                   % 新建分类结果文件夹
result_dir = '..\result\';                      % 分类结果文件夹路径

mkdir(strcat(feature_dir,'PCA'))                % 新建PCA降维方法文件夹
PCA_dir = strcat(feature_dir,'PCA','\');        % 文件夹路径
mkdir(strcat(feature_dir,'LDA'))                % 新建LDA降维方法文件夹
LDA_dir = strcat(feature_dir,'LDA','\');        % 文件夹路径
mkdir(strcat(feature_dir,'NoReduce'))           % 新建No reduce文件夹
NOR_dir = strcat(feature_dir,'NoReduce','\');   % 文件夹路径
ReduceD_dir = {PCA_dir, LDA_dir, NOR_dir}; 

%%%%% 以下为样本数据的等长、对齐、归一化处理 %%%%
autoseg_list = dir([autoseg_dir, 'LVM_*']);         % 切割数据列表
if 1
for i = 1:length(autoseg_list)                  % 生成全新的数据文件夹
    sub_dir = ([autoseg_dir, autoseg_list(i).name]);                 
    word_list = dir([strcat(sub_dir,'\'), '\*_*']);         
    for j = 1:length(word_list)
        load([strcat(sub_dir,'\'), word_list(j).name]);     
        data = data(1:4,501:2500);
%         figure(1)
%         clf
%         plot(data')
        data = data(:,ind1*fs:ind2*fs);
        current = word_list(j).name;                                    
        current_cell = strsplit(current,current(length(current)-3));
        current_name = current_cell{1};  
        p1 = sum(data)/max(abs(sum(data)));      
        % 处理数据，并建立文件夹，把不同方法获得的数据存在对应的文件夹里
        for k = 1:length(char1)
%             a = Norm_Align(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir);          % 等长、对齐、  归一化
%             b = Norm_Noalign(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir);        % 等长、不对齐、归一化
%             c = Withoutnorm_Align(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir);   % 等长、对齐、  不归一化
            d = Withoutnorm_Noalign(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir,autoseg_list(i).name);   % 等长、不对齐、不归一化
        end 
    end    
end
end
if 1
%%%% 以下为特征提取 %%%%
resizedseg_list = dir([resizedseg_dir, '*_*']);              % 样本处理后的数据列表
for m = 1:length(resizedseg_list)                            % 遍历所有文件夹
    sub2_dir = ([resizedseg_dir, resizedseg_list(m).name]);
    FolderName = resizedseg_list(m).name;    
    % 提取特征
    for k = 3:3
        a = New_Feature_Extract(char4(k), sub2_dir, ReduceD_dir, FolderName,wlen, wnd, inc, fs);        
    end
end
end
%%%%% 以下为合并同一label样本，用作交叉验证 
if 1
feature_list = dir([feature_dir, '.']);                      % 不同降维方法获得的特征数据
for p = 3:length(feature_list)
    subfeature_dir = ([feature_dir, feature_list(p).name]);  % 进入外层文件夹
    subfoldername = feature_list(p).name;
    method_dir = strcat(subfeature_dir,'\');                 % 进入内层文件夹
    method_list = dir([method_dir, '*_*']);
    for k = 1:length(method_list)
        sample_dir = ([method_dir, method_list(k).name]);
        mergename = strcat(subfoldername,'_',method_list(k).name);
        a = MergeSampls(sample_dir, mergename, merge_dir);
    end
end
end
%%%%% 以下为利用随机森林预测分类 %%%%
merge_list = dir([merge_dir, '*_*']);                        % 不同方法获得的集合列表
for q = 1:length(merge_list)
    current = merge_list(q).name;
    current_cell = strsplit(current,current(length(current)-3));
    dataname = current_cell{1};
    % 在result文件夹里保存的mat是不同RF参数下的结果，应对每一个mat取平均，PredictResult中即为平均值
    PredictResult(q) = Cross_Predict(merge_dir, current, result_dir, dataname); 
end
save([result_dir,'PredictResult'],'PredictResult');
