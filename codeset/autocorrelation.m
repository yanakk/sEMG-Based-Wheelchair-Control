% 2017/12/1
% cscbme/����
% ��������غ������ж˵��� 
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
xx=xx-mean(xx);                         % ����ֱ������
x=xx/max(abs(xx));                      % ��ֵ��һ��
N=length(x);                            % ȡ�źų���
time=(0:N-1)/fs;                        % ����ʱ��

wnd=hamming(wlen);                      % ���ô�����
overlap=wlen-inc;                       % ���ص�������
NIS=fix((IS*fs-wlen)/inc +1);           % ��ǰ���޻���֡��

y=enframe(x,wnd,inc)';                  % ��֡
fn=size(y,2);                           % ��֡��
frameTime=frame2time(fn, wlen, inc, fs);% �����֡��Ӧ��ʱ��

for k=2 : fn                            % ��������غ���
    u=y(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end
Rum=multimidfilter(Ru,10);              % ƽ������
Rum=Rum/max(Rum);                       % ��һ��
thredth=max(Rum(1:NIS));                % ������ֵ
T1=1*thredth;
T2=1*thredth;
[voiceseg,vsl,SF,NF,T1,T2]=vad_param1D(Rum,T1,T2,alg,Neuro_sign);% ����غ����Ķ˵���
% ��ͼ
% figure(1)
% clf
% subplot 211; 
% plot(time,x,'k');
% for k=1 : vsl                           % ��������˵�
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
% %     subplot 211; 
%     line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
% end
% title('�źŲ���');
% ylabel('��ֵ'); axis([0 max(time) -1 1]);
% % subplot 312; plot(time,x,'k');
% % title(['������������(�����' num2str(SNR) 'dB)']);
% ylabel('��ֵ'); axis([0 max(time) -1 1]);
% subplot 212; plot(frameTime,Rum,'k');
% title('��ʱ����غ���'); axis([0 max(time) 0 1.2]);
% xlabel('ʱ��/s'); ylabel('��ֵ'); 
% line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
% line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
% for k=1 : vsl                           % ��������˵�
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
% %     subplot 211; 
%     line([frameTime(nx1-2) frameTime(nx1-2)],[-1 1],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
% end



