% 2017/12/1
% cscbme/张明
% 利用频带标准差进行端点检测 
function [voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn] = bandvar(array1D,fs,alg,Neuro_sign) 

if Neuro_sign
    IS=0.2;
    wlen=30;
    inc=14;
else
    IS=0.25;
    wlen=30;
    inc=20;    
end
xx=array1D;
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
N=length(x);                            % 取信号长度
time=(0:N-1)/fs;                        % 设置时间

wnd=hamming(wlen);                      % 设置窗函数
overlap=wlen-inc;                       % 求重叠区长度
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

y=enframe(x,wnd,inc)';                  % 分帧
fn=size(y,2);                           % 求帧数
frameTime=frame2time(fn, wlen, inc, fs);% 计算各帧对应的时间

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
% % Dvar=Dvar';
dth=mean(Dvar(2:NIS+1));                  % 求取阈值
T1=1*dth;
T2=1*dth;
[voiceseg,vsl,SF,NF,T1,T2]=vad_param1D(Dvar,T1,T2,alg,Neuro_sign);% 频域方差双门限的端点检测
% 作图
% figure(1)
% clf
% subplot 211; plot(time,x,'k');
% title('信号波形');
% ylabel('幅值'); axis([0 max(time) -1 1]);
% % subplot 312; plot(time,x,'k');
% % title('加噪波形');
% % ylabel('幅值'); axis([0 max(time) -1 1]);
% subplot 212; plot(frameTime,Dvar,'k');
% title('短时频带标准差'); grid; ylim([0 1.2*max(Dvar)]);
% xlabel('时间/s'); ylabel('幅值'); 
% line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
% line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
% for k=1 : vsl                           % 标出语音端点
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
%     subplot 211; 
%     line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');  
%     subplot 212; 
%     line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Dvar)],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Dvar)],'color','b','LineStyle','--');
% end

