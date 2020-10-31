% 2017/12/1
% cscbme/张明
% 利用短时能量进行端点检测 
function [voiceseg,vsl,time_rt,xx_rt,ft,amp_rt,T1,T2,fn_rt,err] = energy_selfdevice(array1D,fs,Neuro_sign, wlen, inc)

xx=array1D;
xx=xx-mean(xx);
xx=xx/max(abs(xx));                     % 幅度归一化
N=length(xx);                           % 取信号长度
time=(0:N-1)/fs;                        % 计算时间刻度
if Neuro_sign
    IS=0.2;
    wlen=30;
    inc=14;
else
    IS=0.5;
    wlen=40;
    inc=20;    
end
% overlap=wlen-inc;              % 设置前导无话段长度
NIS=fix((IS*fs-wlen)/inc +1);           % 计算前导无话段帧数
xx_rt=xx(IS*fs+1:end);
time_rt=time(1:end-IS*fs);
y=enframe(xx,wlen,inc)';                 % 分帧
fn=size(y,2);                           % 帧数
fn_rt=fn-NIS;
amp=sum(y.^2);                          % 求取短时平均能量
amp = multimidfilter(amp,10);           % 中值滤波平滑处理  
ampm=amp/max(amp);                 % 能量幅值归一化
amp_rt=ampm(NIS+1:end);
amp_rt(1)=amp_rt(2);
% ampth=mean(ampm(1:NIS));                % 计算初始无话段区间能量 
% amp2=1*ampth; amp1=1*ampth;         % 设置能量阈值
% T1 = amp1;T2 = amp2;T3 = zcr2;
% s = mean(abs(ampm(NIS+1:end)))/mean(abs(ampm(2:NIS)));
% T1 = amp1*s*0.8;  
% T2 = amp2*s*1.4; 
frameTime=frame2time(fn, wlen, inc, fs);% 计算各帧对应的时间
ft=frameTime(1:end-NIS);
T1 = mean(abs(amp_rt))*1.2;
T2 = mean(abs(amp_rt))*1.6;
[voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(amp_rt,T1,T2,Neuro_sign);% 端点检测
