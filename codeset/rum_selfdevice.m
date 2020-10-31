% 2017/12/1
% cscbme/张明
% 利用自相关函数进行端点检测 
function [voiceseg,vsl,time_rt,x_rt,ft,Rum_rt,T1,T2,fn_rt,err] = rum_selfdevice(array1D,fs,Neuro_sign, wlen, inc) 

xx=array1D;
if Neuro_sign
    IS=0.2;
    wlen=30;
    inc=14;
else
    IS=0.5;
    wlen=40;
    inc=20;    
end
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
x_rt=x(IS*fs+1:end);
N=length(x);                            % 取信号长度
time=(0:N-1)/fs;                        % 设置时间
time_rt=time(1:end-IS*fs);
wnd=hamming(wlen);                      % 设置窗函数
overlap=wlen-inc;                       % 求重叠区长度
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

y=enframe(x,wnd,inc)';                  % 分帧
fn=size(y,2);                           % 求帧数
fn_rt=fn-NIS;
frameTime=frame2time(fn, wlen, inc, fs);% 计算各帧对应的时间
ft=frameTime(1:end-NIS);
for k=2 : fn                            % 计算自相关函数
    u=y(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end
Rum=multimidfilter(Ru,10);              % 平滑处理
Rum=Rum/max(Rum);                       % 归一化
Rum_rt=Rum(NIS+1:end);
Rum_rt(1)=Rum_rt(2);
% thredth=max(Rum(1:NIS));                % 计算阈值
% T1=1*thredth;
% T2=1*thredth;
% s = mean(abs(Rum_rt))/mean(abs(Rum(2:NIS)));
% T1 = T1*s*0.45;  
% T2 = T2*s*0.8;

T1 = mean(abs(Rum_rt))*1.2;
T2 = mean(abs(Rum_rt))*1.6;

[voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(Rum_rt,T1,T2,Neuro_sign);% 自相关函数的端点检测




