clc;clear;

lvm_dir = '..\lvm\'; %position the direction of all data
list = dir([ lvm_dir, 'LVM_*']);  %list of all sub folders
mkdir(strcat('..\','mat'))                      % 新建mat文件夹
mat_dir = '..\mat\';                            % mat文件夹路径

for ind = 1:length(list)
    
    sublvm_dir = ([lvm_dir, list(ind).name]);  % 内层数据文件夹
    subfolder=list(ind).name;
    mkdir(strcat(mat_dir,subfolder))
    newpath=(strcat(mat_dir,subfolder,'\'));
    lvm_in=fullfile(sublvm_dir,'RAW*.lvm'); %进入内层文件夹
    lvm_list = dir([lvm_in]);  %文件列表
    
    for k = 1:length(lvm_list)
        dd=([strcat(sublvm_dir,'\'), lvm_list(k).name]);
        data = lvmread6chs (dd,30);
%         if ind<7    
%             data = lvmread5chs (dd,30);
%         else
%             data = lvmread4chs (dd,30);
%         end
        current = lvm_list(k).name;
        current_cell = strsplit(current,current(length(current)-3));
        current_name = current_cell{1};
        L = length(current_name);
        for i = 1:L
           if current_name(i) ==  '_';
                label_cell = strsplit(current_name,current_name(i));
                label = label_cell{2};  
                break;
           else label=0;
           end
        end        
        save([newpath, current_name, '.mat'],'data','label');  %save data to mat format
%         clf;
    end
end