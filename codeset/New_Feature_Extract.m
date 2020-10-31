function a = New_Feature_Extract(method, segment_dir, ReduceD_dir, foldername, wlen, wnd, inc, fs)

sub_list = dir([ segment_dir, '.']);  %list of all sub folders
for k = 3: length(sub_list )
    sub_dir = ([segment_dir, '\',sub_list(k).name]);  % 内层数据文件夹
    subname = strcat('wave_',sub_list(k).name);    
    list = dir([ strcat(sub_dir,'\'), '\*_*']);  %show list of all files
    lab = zeros(1,length(list));
    wave = zeros(1,1);

    for ind = 1:length(list)

        load([strcat(sub_dir,'\'), list(ind).name]);     % savedata label
        y = enframe(sum(savedata),wnd,inc)';             % 分帧
        fn = size(y,2);                                  % 求帧数
        frameTime = frame2time(fn, wlen, inc, fs);       % 计算各帧对应的时间
        count = frameTime*fs;
        % 把样本label由字符串改为数字
        if strcmp(label, '1') 
                num=1;
        elseif  strcmp(label, '2')
                num=2;
        elseif  strcmp(label, '3')
                num=3;
        elseif  strcmp(label, '4')
                num=4;
        elseif  strcmp(label, '5')
                num=5;
        elseif  strcmp(label, '6')
                num=6;
        elseif  strcmp(label, '7')
                num=7;
        elseif  strcmp(label, '8')
                num=8;
        end
        % 计算特征
        n = 5;
        for jj = 1:length(savedata(:,1))                   
            for i = 1:length(count)              
                ch=savedata(jj,inc*(i-1)+1:inc*(i-1)+wlen);
                chdiff = diff(ch);
                z1=pickzero(ch);
                z2=pickzero(chdiff);
                if 0
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = var(ch);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = length(z1);
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = mean(chdiff);
                    wave(n*(i-1)+7+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = var(chdiff);
                    wave(n*(i-1)+9+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+10+length(count)*n*(jj-1),ind) = length(z2);
                end
                if 0
                    %wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z1);
%                     wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = mean(chdiff);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = var(chdiff);
                    wave(n*(i-1)+7+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = length(z2);   
                end
                if 0
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    %wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z1);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    %wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = var(chdiff);
                    wave(n*(i-1)+7+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = length(z2);   
                end
                if 0
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    %wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z1);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    %wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = var(chdiff);
                    wave(n*(i-1)+7+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = length(z2);   
                end                 
                if 0
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = var(ch);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z1);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+7+length(count)*n*(jj-1),ind) = var(chdiff);
                    %wave(n*(i-1)+7+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = length(z2);   
                end                 
                if 0
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = var(ch);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = rms(ch);
                   % wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z1);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+7+length(count)*n*(jj-1),ind) = var(chdiff);
                    wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = rms(chdiff);
                    %wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = length(z2);   
                end 
                if 0
                    %wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                   % wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z1);
                    %wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = var(chdiff);
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = rms(chdiff);
                    %wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = length(z2);   
                end                 
                if 1
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = var(ch);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = length(z1);
                    %wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    %wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
%                     wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = var(chdiff);
%                     wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = rms(chdiff);
%                     wave(n*(i-1)+8+length(count)*n*(jj-1),ind) = length(z2);   
                end                
                if 0
                    %wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = length(z1);
                    %wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = var(chdiff);
                    %wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = length(z2);   
                end                
                if 0
                    %wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    %wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = var(ch);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = length(z1);
                    %wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    %wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = var(chdiff);
                    %wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z2);   
                end                
                if 0
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
%                     wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    %wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = length(z1);
                    wave(n*(i-1)+5+length(count)*n*(jj-1),ind) = mean(chdiff);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = var(chdiff);
                    %wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = rms(chdiff);
                    %wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z2);   
                end  
                if 0
%                     wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
%                     wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    %wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = length(z1);
%                     wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = mean(chdiff);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
%                     wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = var(chdiff);
                    wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = rms(chdiff);
                    %wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z2);   
                end                  
                if 0
%                     wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(ch);
                    %wave(n*(i-1)+1+length(count)*n*(jj-1),ind) = mean(abs(ch));
%                     wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = var(ch);
%                     wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = rms(ch);
                    wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = length(z1);
%                     wave(n*(i-1)+2+length(count)*n*(jj-1),ind) = mean(chdiff);
                    %wave(n*(i-1)+3+length(count)*n*(jj-1),ind) = mean(abs(chdiff));
%                     wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = var(chdiff);
%                     wave(n*(i-1)+6+length(count)*n*(jj-1),ind) = rms(chdiff);
                    wave(n*(i-1)+4+length(count)*n*(jj-1),ind) = length(z2);   
                end                     
                
%                 wave(4*(i-1)+1+length(count)*4*(jj-1),ind) = rms(ch);
%                 wave(10*(i-1)+2+length(count)*10*(jj-1),ind) = mean(ch);
%                 z=pickzero(ch);
%                 wave(10*(i-1)+3+length(count)*10*(jj-1),ind) = length(z);
%                 wave(10*(i-1)+4+length(count)*10*(jj-1),ind) = var(ch);
%                 wave(4*(i-1)+2+length(count)*4*(jj-1),ind) = sum(ch.^4)/sqrt(sum(ch.^2));
%                 wave(4*(i-1)+3+length(count)*4*(jj-1),ind) = mean(sqrt(abs(ch)))^2;
%                 wave(10*(i-1)+7+length(count)*10*(jj-1),ind) = max(ch)-min(ch);
%                 wave(10*(i-1)+8+length(count)*10*(jj-1),ind)= (max(ch)-min(ch))/rms(ch);
%                 wave(4*(i-1)+4+length(count)*4*(jj-1),ind) = mean(abs(ch));
%                 wave(10*(i-1)+10+length(count)*10*(jj-1),ind) = std(ch);

%                 [pxx1, f, MPF, MF]=iEMG_fd_para(ch,fs);       %计算median frequency
%                 wave(5*(i-1)+1+length(count)*5*(jj-1),ind) = rms(pxx1);
%                 wave(5*(i-1)+2+length(count)*5*(jj-1),ind) = rms(f); 
%                 wave(5*(i-1)+3+length(count)*5*(jj-1),ind) = MPF; 
%                 wave(5*(i-1)+4+length(count)*5*(jj-1),ind) = MF; 
%                 z=pickzero(ch);
%                 wave(5*(i-1)+5+length(count)*5*(jj-1),ind) = length(z); 
%                 [Lo_D,Hi_D] = wfilters('sym6','d');
%                 [A,D] = dwt(ch,Lo_D,Hi_D);
            end
        end
        lab(1,ind)=num;
    end
    
    if strcmp(method,'PCA')
        nwave = wave';
        wave = compute_mapping(nwave, 'PCA', 50);
        wave = wave';
        Dpath = char(strcat(ReduceD_dir(1),foldername));
        if ~exist(Dpath,'file')  
            mkdir(Dpath)              %新建文件夹存放该方法下的分割数据
        end
        featurepath = strcat(Dpath,'\');
    elseif strcmp(method,'LDA')
        nwave = [lab;wave];
        nwave = nwave';
        wave = compute_mapping(nwave, 'LDA', 50);
%         wave = nwave;
        Dpath = char(strcat(ReduceD_dir(2),foldername));
        if ~exist(Dpath,'file')  
            mkdir(Dpath)              %新建文件夹存放该方法下的分割数据
        end
        featurepath = strcat(Dpath,'\');        
    elseif strcmp(method,'NoReduce')   
%         wave = wave';
        Dpath = char(strcat(ReduceD_dir(3),foldername));
        if ~exist(Dpath,'file')  
            mkdir(Dpath)              %新建文件夹存放该方法下的分割数据
        end
        featurepath = strcat(Dpath,'\');        
    else
        error('The method of Reduce Dimention is wrong, please check it!');
    end   

    save([featurepath,subname ],'wave','lab');
end
a = 'Feature Extraction complete!';