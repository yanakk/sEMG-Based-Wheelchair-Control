% 2017/12/1
% cscbme/张明
% 利用短时能量和过零率进行端点检测 
function [voiceseg,vsl,time,xx,frameTime,ampm,zcrm,T1,T2,T3,fn] = energy_zcr(array1D,fs,alg)

xx=array1D;
xx=xx/max(abs(xx));                     % 幅度归一化
N=length(xx);                           % 取信号长度
time=(0:N-1)/fs;                        % 计算时间刻度

wlen=30; inc=20;                       % 设置帧长和帧移
IS=0.20; 
% overlap=wlen-inc;              % 设置前导无话段长度
NIS=fix((IS*fs-wlen)/inc +1);           % 计算前导无话段帧数
y=enframe(xx,wlen,inc)';                 % 分帧
fn=size(y,2);                           % 帧数
amp=sum(y.^2);                          % 求取短时平均能量
zcr=zc2(y,fn);                          % 计算短时平均过零率  
ampm = multimidfilter(amp,10);           % 中值滤波平滑处理
zcrm = multimidfilter(zcr,10);         
ampth=mean(ampm(1:NIS));                % 计算初始无话段区间能量和过零率的平均值 
zcrth=mean(zcrm(1:NIS));
amp2=1*ampth; amp1=1*ampth;         % 设置能量和过零率的阈值
zcr2=1*zcrth;
% T1 = amp1;T2 = amp2;T3 = zcr2;
frameTime=frame2time(fn, wlen, inc, fs);% 计算各帧对应的时间
[voiceseg,vsl,T1,T2,T3,SF,NF]=vad_param2D(alg,amp,zcr,amp2,amp1,zcr2);% 端点检测
% 作图
% subplot 211; 
% plot(time,xx,'k');
% line([0 52],[amp2 amp2],'color','r','LineStyle','-');
% line([0 52],[amp1 amp1],'color','r','LineStyle','-');
% % title('信号波形');
% % ylabel('幅值'); axis([0 max(time) -1 1]); 
% % subplot 212; plot(time,xx,'k');
% % title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
% % ylabel('幅值'); axis([0 max(time) -1 1]);
% % xlabel('时间/s');
% for k=1 : vsl
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
% %     fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
% %     subplot 211;
%     line([frameTime(nx1) frameTime(nx1)],[-1.5 1.5],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1.5 1.5],'color','b','LineStyle','--');
% %     subplot 212; 
% %     line([frameTime(nx1) frameTime(nx1)],[-1.5 1.5],'color','b','LineStyle','-');
% %     line([frameTime(nx2) frameTime(nx2)],[-1.5 1.5],'color','b','LineStyle','--');    
% end
% output=[frameTime(nx1) frameTime(nx2) frameTime(nx2)-frameTime(nx1)];


