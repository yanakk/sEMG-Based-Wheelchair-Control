clc;clear;
mat_dir = '..\mat\';
mkdir(strcat('..\','png'))                      % �½�png�ļ���
png_dir = '..\png\';
mkdir(strcat('..\','autoseg'))                      % �½�seg�ļ���
seg_dir = '..\autoseg\';
list = dir([ mat_dir, 'LVM_*']);  %list of all sub data files
fs = 1000;
Neuro_sign = 0;
for i = 1:length(list)       
    matFolder  = ([mat_dir,list(i).name]);      %aquire data     
    dataname = list(i).name;
    mkdir(strcat(png_dir,dataname))           %�½��ļ���
    pngpath=(strcat(png_dir,dataname,'\'));   %��ǰpng��·��
    mkdir(strcat(seg_dir,dataname))           %�½��ļ���
    segpath=(strcat(seg_dir,dataname,'\'));   %��ǰseg��·��       
%     if i>28                                     
        matlist = dir([strcat(matFolder,'\'), 'RAWdata_*']);
        load([strcat(matFolder,'\'),'RAWdata.mat']);    
%     else
%         matlist = dir([strcat(matFolder,'\'), 'RAWb_*']);
%         load([strcat(matFolder,'\'),'RAWb.mat']);       
%     end
    noise = data(6001:6500,1:4);              %ǰ������ 
    for m = 1:length(matlist)        
        load([strcat(matFolder,'\'),matlist(m).name]);  
%         if i>28
%             removedata = data(1001:end,1:4);
%             prelen = 1000;                    %labviewһ������
%         else
            prelen = 2000; 
            removedata = data(2001:prelen*floor(length(data(:,1))/prelen),1:4);
                               %labviewһ������
%         end
        count = length(removedata(:,1))/prelen;
        for s = 1:count
            raw = [noise;removedata((s-1)*prelen+1:s*prelen,:)];
            raw = raw';
            dataAdd = sum(raw);        
%             for alg = 3 : 7
%                 switch alg
%                     case 1  %��ʱ�����͹����ʷ�
%                         [voiceseg,vsl,time,x,frameTime,ampm,zcrm,T1,T2,T3,fn] = energy_zcr(xx,fs,alg);
%                         figname = strcat('energyzcr','_',num2str(m));
%                         succeed = plotfig1(voiceseg,vsl,time,x,frameTime,ampm,zcrm,T1,T2,T3,fn,raw,figname,pngpath);
%                     case 2  %��ʱ�����͹����ʷ���ȽϷ�
%                         [voiceseg,vsl,time,x,frameTime,ampm,zcrm,T1,T2,T3,fn] = ez_revr(xx,fs,alg);
%                         figname = strcat('energyzcr_revr','_',num2str(m));
%                         succeed = plotfig1(voiceseg,vsl,time,x,frameTime,ampm,zcrm,T1,T2,T3,fn,raw,figname,pngpath);
%                     case 3  %��һ������غ�����
                        [voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn,err] = rum_selfdevice(dataAdd,fs,Neuro_sign);
                        f3 = {voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn,err};
%                         figname = strcat('rum','_',num2str(m),num2str(s));
%                         succeed = plot1D_selfdevice(voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn,raw,figname,pngpath,err);
%                     case 4  %Ƶ�����
                        [voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn,err] = bandvar_selfdevice(dataAdd,fs,Neuro_sign);
                        f4 = {voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn,err};
%                         figname = strcat('bandvar','_',num2str(m),num2str(s));
%                         succeed = plot1D_selfdevice(voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn,raw,figname,pngpath,err);
%                     case 5  %�����Ӵ�����Ƶ�����
%                         [voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn] = subbandvar(xx,fs,alg);
%                         figname = strcat('subbandvar','_',num2str(m));
%                         succeed = plot1D_selfdevice(voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn,raw,figname,pngpath);
%                     case 6  %�����׼����ͷ��
%                         [voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn] = basicspectral_var(xx,fs,alg);
%                         figname = strcat('spectralvar','_',num2str(m));
%                         succeed = plot1D_selfdevice(voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn,raw,figname,pngpath);
%                     case 7  %��ʱ����
                        [voiceseg,vsl,time,x,frameTime,ampm,T1,T2,fn,err] = energy_selfdevice(dataAdd,fs,Neuro_sign);
                        f7 = {voiceseg,vsl,time,x,frameTime,ampm,T1,T2,fn,err};
%                         figname = strcat('energy','_',num2str(m),num2str(s));
%                         succeed = plot1D_selfdevice(voiceseg,vsl,time,x,frameTime,ampm,T1,T2,fn,raw,figname,pngpath,err);
%                 end            
%             end
                        figname = strcat(label,'_',num2str(s));
                        [ind1,ind2] = plotfinal(f3,f4,f7,figname,pngpath);   %����ָ���ʼ��
                        
                        data = raw;
                        if ind1>0 && ind2>0
                            save([segpath, figname, '.mat'],'data','x','label','ind1','ind2');
                        else
                            figname = strcat('err','_',figname);
                            save([segpath, figname, '.mat'],'data','x','label','ind1','ind2');
                        end
        end
    end
end