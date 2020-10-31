% main.m�������ļ�,����Ϊ�ӳ���
% 2018.1.6 ����
clc;
clear;
close all;

% Ԥ������������
len = 500;                                      % resize����
wlen=30;                                        % ֡��
wnd=hamming(wlen);                              % ���ô�����
inc=15;                                         % ֡��
fs = 1000;                                      % ������
PredictResult = zeros(1,1);                     % ������ս��

char1 = {'bicubic','bilinear','nearest'};       % ���ֲ�ֵ����
char2 = {'Norm','Withoutnorm'};                 % �Ƿ�����˹�һ��
char3 = {'Align','Noalign'};                    % �Ƿ���߶���
char4 = {'PCA','LDA','NoReduce'};               % ��άѡ����PCA��LDA�Լ�����ά
  
autoseg_dir = '..\autoseg\';                    % �и������ļ�·��
mkdir(strcat('..\','png'))                      % �½�ͼƬ�ļ���
png_dir = '..\png\';                            % ͼƬ�ļ���·��
mkdir(strcat('..\','resizedseg'))               % �½������ļ���
resizedseg_dir = '..\resizedseg\';              % �����ļ���·��
mkdir(strcat('..\','feature'))                  % �½������ļ���
feature_dir = '..\feature\';                    % �����ļ���·��
mkdir(strcat('..\','merge'))                    % �½������ļ���
merge_dir = '..\merge\';                        % �����ļ���·��
mkdir(strcat('..\','result'))                   % �½��������ļ���
result_dir = '..\result\';                      % �������ļ���·��

mkdir(strcat(feature_dir,'PCA'))                % �½�PCA��ά�����ļ���
PCA_dir = strcat(feature_dir,'PCA','\');        % �ļ���·��
mkdir(strcat(feature_dir,'LDA'))                % �½�LDA��ά�����ļ���
LDA_dir = strcat(feature_dir,'LDA','\');        % �ļ���·��
mkdir(strcat(feature_dir,'NoReduce'))           % �½�No reduce�ļ���
NOR_dir = strcat(feature_dir,'NoReduce','\');   % �ļ���·��
ReduceD_dir = {PCA_dir, LDA_dir, NOR_dir}; 

%%%%% ����Ϊ�������ݵĵȳ������롢��һ������ %%%%
autoseg_list = dir([autoseg_dir, 'LVM_*']);         % �и������б�
if 1
for i = 1:length(autoseg_list)                  % ����ȫ�µ������ļ���
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
        % �������ݣ��������ļ��У��Ѳ�ͬ������õ����ݴ��ڶ�Ӧ���ļ�����
        for k = 1:length(char1)
%             a = Norm_Align(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir);          % �ȳ������롢  ��һ��
%             b = Norm_Noalign(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir);        % �ȳ��������롢��һ��
%             c = Withoutnorm_Align(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir);   % �ȳ������롢  ����һ��
            d = Withoutnorm_Noalign(char1{k}, p1, len, current_name, data, label, char2, char3, resizedseg_dir,autoseg_list(i).name);   % �ȳ��������롢����һ��
        end 
    end    
end
end
if 1
%%%% ����Ϊ������ȡ %%%%
resizedseg_list = dir([resizedseg_dir, '*_*']);              % ���������������б�
for m = 1:length(resizedseg_list)                            % ���������ļ���
    sub2_dir = ([resizedseg_dir, resizedseg_list(m).name]);
    FolderName = resizedseg_list(m).name;    
    % ��ȡ����
    for k = 3:3
        a = New_Feature_Extract(char4(k), sub2_dir, ReduceD_dir, FolderName,wlen, wnd, inc, fs);        
    end
end
end
%%%%% ����Ϊ�ϲ�ͬһlabel����������������֤ 
if 1
feature_list = dir([feature_dir, '.']);                      % ��ͬ��ά������õ���������
for p = 3:length(feature_list)
    subfeature_dir = ([feature_dir, feature_list(p).name]);  % ��������ļ���
    subfoldername = feature_list(p).name;
    method_dir = strcat(subfeature_dir,'\');                 % �����ڲ��ļ���
    method_list = dir([method_dir, '*_*']);
    for k = 1:length(method_list)
        sample_dir = ([method_dir, method_list(k).name]);
        mergename = strcat(subfoldername,'_',method_list(k).name);
        a = MergeSampls(sample_dir, mergename, merge_dir);
    end
end
end
%%%%% ����Ϊ�������ɭ��Ԥ����� %%%%
merge_list = dir([merge_dir, '*_*']);                        % ��ͬ������õļ����б�
for q = 1:length(merge_list)
    current = merge_list(q).name;
    current_cell = strsplit(current,current(length(current)-3));
    dataname = current_cell{1};
    % ��result�ļ����ﱣ���mat�ǲ�ͬRF�����µĽ����Ӧ��ÿһ��matȡƽ����PredictResult�м�Ϊƽ��ֵ
    PredictResult(q) = Cross_Predict(merge_dir, current, result_dir, dataname); 
end
save([result_dir,'PredictResult'],'PredictResult');
