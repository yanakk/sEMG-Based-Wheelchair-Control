% 2017/12/1
% cscbme/张明
% 利用自相关函数进行端点检测 
function [voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn] = autocorrelation(array1D,fs,alg,Neuro_sign) 

xx=array1D;
if Neuro_sign
    IS=0.2;
    wlen=30;
    inc=14;
else
    IS=0.25;
    wlen=30;
    inc=20;    
end
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

for k=2 : fn                            % 计算自相关函数
    u=y(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end
Rum=multimidfilter(Ru,10);              % 平滑处理
Rum=Rum/max(Rum);                       % 归一化
thredth=max(Rum(1:NIS));                % 计算阈值
T1=1*thredth;
T2=1*thredth;
[voiceseg,vsl,SF,NF,T1,T2]=vad_param1D(Rum,T1,T2,alg,Neuro_sign);% 自相关函数的端点检测
% 作图
% figure(1)
% clf
% subplot 211; 
% plot(time,x,'k');
% for k=1 : vsl                           % 标出语音端点
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
% %     subplot 211; 
%     line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
% end
% title('信号波形');
% ylabel('幅值'); axis([0 max(time) -1 1]);
% % subplot 312; plot(time,x,'k');
% % title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
% ylabel('幅值'); axis([0 max(time) -1 1]);
% subplot 212; plot(frameTime,Rum,'k');
% title('短时自相关函数'); axis([0 max(time) 0 1.2]);
% xlabel('时间/s'); ylabel('幅值'); 
% line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
% line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
% for k=1 : vsl                           % 标出语音端点
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
% %     subplot 211; 
%     line([frameTime(nx1-2) frameTime(nx1-2)],[-1 1],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
% end



