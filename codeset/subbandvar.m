% 2017/12/1
% cscbme/张明
% 利用均匀子带分离频带方差进行端点检测 
function [voiceseg,vsl,time,x,frameTime,Dvarm,T1,T2,fn] = subbandvar(array1D,fs,alg) 

IS=0.2;
wlen=30;
inc=20;
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
M=fix(N2/4);                            % 计算子带数
for k=1 : fn
    for i=1 : M                         % 每个子带中有4条谱线
        j=(i-1)*4+1;
        SY(i,k)=Y_abs(j,k)+Y_abs(j+1,k)+Y_abs(j+2,k)+Y_abs(j+3,k);
    end
    Dvar(k)=var(SY(:,k));               % 计算每帧子带分离的频带方差
end
Dvarm=multimidfilter(Dvar,10);          % 平滑处理
dth=mean(Dvarm(1:(NIS)));               % 阈值计算
T1=1*dth;
T2=1*dth;
[voiceseg,vsl,SF,NF,T1,T2]=vad_param1D(Dvarm,T1,T2,alg);% 双门限的端点检测
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

