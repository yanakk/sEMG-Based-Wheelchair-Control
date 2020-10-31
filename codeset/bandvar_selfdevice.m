% 2017/12/1
% cscbme/张明
% 利用频带标准差进行端点检测 
function [voiceseg,vsl,time_rt,x_rt,ft,Dvar_rt,T1,T2,fn_rt,err] = bandvar_selfdevice(array1D,fs,Neuro_sign, wlen, inc) 

if Neuro_sign
    IS=0.2;
    wlen=30;
    inc=14;
else
    IS=0.5;
    wlen=40;
    inc=20;    
end
xx=array1D;
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
Y=fft(y);                               % FFT变换
N2=wlen/2+1;                            % 取正频率部分
n2=1:N2;
Y_abs=abs(Y(n2,:));                     % 取幅值

for k=1:fn                              % 计算每帧的频带方差
    DDvar(k)=var(Y_abs(:,k));
end
% Dvar=maf(DDvar,10);
Dvar=multimidfilter(DDvar,10); 
Dvar=Dvar/max(Dvar);                       % 归一化
Dvar_rt=Dvar(NIS+1:end);
Dvar_rt(1)=Dvar_rt(2);
% % Dvar=Dvar';
% dth=mean(Dvar(2:NIS+1));                  % 求取阈值
% T1=1*dth;
% T2=1*dth;
% s = mean(abs(Dvar(NIS+1:end)))/mean(abs(Dvar(2:NIS)));
% T1 = T1*s*1;  
% T2 = T2*s*1.5;
T1 = mean(abs(Dvar_rt))*1.2;
T2 = mean(abs(Dvar_rt))*1.6;
[voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(Dvar_rt,T1,T2,Neuro_sign);% 频域方差双门限的端点检测

