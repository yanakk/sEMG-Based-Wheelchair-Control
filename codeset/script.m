clear all; clc;
fs=1000;
IS=0.5; wlen=40;inc=20;
lvm_dir = strcat(dpath,'\');                %lvm data file
lvm_list = dir([ lvm_dir, '*data.lvm']);    %list of all sub folders
mkdir(strcat(dpath,'\mat'));                % new mat folder
mat_dir = [dpath,'\mat','\'];               % mat path

[a1,a2,a3,a4,a5,a6] = textread(strcat(lvm_dir,'FILdata.lvm'),'%s%s%s%s%s%s');
%%
% clear all;clc;
a1=str2double(a1(30:end,1));
a2=str2double(a2(30:end,1));
a3=str2double(a3(30:end,1));
a4=str2double(a4(30:end,1));
a5=str2double(a5(30:end,1));
a6=str2double(a6(30:end,1));
%%
dpath = '.';

rc=[a1,a2,a3,a4,a5,a6];

for f=1:length(rc(1,:))
    %y = fir_hpf(rc(:,f),fs,40,5,1);
    %yy = fir_lpf(y,fs,350,300);
    y = rc(:,f);
    yy = y;
    d = fdesign.comb('notch','L,BW,GBW,Nsh',20,4,-3,6,fs);
    Hd=design(d);
    ttf(:,f)=filter(Hd,yy);
end

mkdir(strcat(dpath,'\smps'));                 % new samps folder
smps_dir = [dpath,'\smps','\'];               % samples path
cnt = 1;
tmp = cnt*2*fs;
tps = 10;
for j=1:1%length(mat_list)                    %segement from the whole data file
    for k=1:tps
      dt = ttf((k-1)*tmp+1:k*tmp,:);    
      save([smps_dir, num2str(k), '.mat'],'dt'); 
    end
end

smps_list = dir([ smps_dir, '*.mat']);
mkdir(strcat(dpath,'\seg'));                 % new seg folder
seg_dir = [dpath,'\seg','\'];                % seg path
mkdir(strcat(dpath,'\png'));                 % new png folder
png_dir = [dpath,'\png','\'];                % png path
  
prelen = 2000;
da=([smps_dir, smps_list(1).name]);
load(da); 
noise = dt(end-499:end,:);                   %pre-input noise 
for m=1:length(smps_list)                    %signal activity detection
    current = smps_list(m).name;
    current_cell = strsplit(current,current(length(current)-3));
    label = current_cell{1};   
    da=([smps_dir, smps_list(m).name]);
    load(da); 
    count = length(dt(:,1))/prelen;
    for s = 1:count
        tt = dt((s-1)*prelen+1:s*prelen,:);
        raw = [noise;tt];
        raw = raw';
        dataAdd = sum(raw);  
        v1 = max(abs(dataAdd(1:500)));                
        v2 = max(abs(dataAdd(501:end)));              
        %
        [voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn,err] = rum_selfdevice(dataAdd,fs,IS,wlen,inc);
        f3 = {voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn,err};
        %
        [voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn,err] = bandvar_selfdevice(dataAdd,fs,IS,wlen,inc);
        f4 = {voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn,err};
        %
        [voiceseg,vsl,time,x,frameTime,ampm,T1,T2,fn,err] = energy_selfdevice(dataAdd,fs,IS,wlen,inc);
        f7 = {voiceseg,vsl,time,x,frameTime,ampm,T1,T2,fn,err};
        if v2>6*v1
            f3{10}=1;f4{10}=1;f7{10}=1;
        end
        figname = strcat(label,'_',num2str(s));
        [ind1,ind2] = plotfinal(f3,f4,f7,figname,png_dir);   

        data = tt';
        if m==1            
            ind1 = 1/fs; ind2 = 2;
            save([seg_dir, figname, '.mat'],'data','label','ind1','ind2');
        elseif ind1>0 && ind2>ind1
            save([seg_dir, figname, '.mat'],'data','label','ind1','ind2');
        end
    end
end

seg_list = dir([ seg_dir, '*.mat']);
if (~isempty(seg_list))    
    features=0;
    mkdir(strcat(dpath,'\feature'));                 % new seg folder
    feature_dir = [dpath,'\feature','\'];            % seg path
    for ind = 1:length(seg_list)

        da=([seg_dir, seg_list(ind).name]);
        load(da); 
        segdata = data(:,ind1*fs:ind2*fs);
        redata = imresize(segdata, [6 1000], 'bilinear'); 
        wn = multimidfilter(redata,6);
        pn = redata-wn;
        yf = enframe(sum(wn),wlen,inc)';             % ?????
        fnf = size(yf,2);                                  % ???????
        frameTimef = frame2time(fnf, wlen, inc, fs);       % ????????????????????
        countf = frameTimef*fs;
        for jj = 1:length(data(:,1))  
            for i = 1:length(countf)              
                ch=wn(jj,inc*(i-1)+1:inc*(i-1)+wlen);
                ch2=pn(jj,inc*(i-1)+1:inc*(i-1)+wlen);
                z2=pickzero(ch2);
                features(5*(i-1)+1+length(countf)*5*(jj-1),ind) = mean(ch);
                features(5*(i-1)+2+length(countf)*5*(jj-1),ind) = sum(ch.^2);
                features(5*(i-1)+3+length(countf)*5*(jj-1),ind) = sum(ch2.^2);
                features(5*(i-1)+4+length(countf)*5*(jj-1),ind) = length(z2);
                features(5*(i-1)+5+length(countf)*5*(jj-1),ind) = mean(abs(ch2));
                %features(6+21*(jj-1):21*jj,ind) = get_wave_new(ch,4);
            end
%             features(246+261*(jj-1):261*jj,ind) = get_wave_new(ch,4);
        end
        lab(1,ind)=str2num(label);
%         Matrix(ind,1) = str2num(label); Matrix(ind,2:fnf*5*4+1) = features(:,ind)';
    end
    save([lvm_dir,'feature' ],'features','lab');
    save([feature_dir,'feature' ],'features','lab');
%     dlmwrite(strcat('feature','.csv'),Matrix,'-append', 'newline','pc');

    feature_list = dir([ feature_dir, '*.mat']);
    for n=1:length(feature_list)                  % build model of RF
        da=([feature_dir, feature_list(n).name]);
        load(da); 
        Y_trn = lab';
        X_trn = (features');
        model = classRF_train(X_trn,Y_trn);
        save([strcat(dpath,'\'),'model' ],'model');
    end

    save([strcat(dpath,'\'),'noise' ],'noise');

    trainEnd = 'Training complete!';
else
    trainEnd = 'Training failed, no data!';
end
