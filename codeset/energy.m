% 2017/12/1
% cscbme/����
% ���ö�ʱ�������ж˵��� 
function [voiceseg,vsl,time,xx,frameTime,amp,T1,T2,fn] = energy(array1D,fs,alg,Neuro_sign)

xx=array1D;
xx=xx-mean(xx);
xx=xx/max(abs(xx));                     % ���ȹ�һ��
N=length(xx);                           % ȡ�źų���
time=(0:N-1)/fs;                        % ����ʱ��̶�
if Neuro_sign
    IS=0.2;
    wlen=30;
    inc=14;
else
    IS=0.25;
    wlen=30;
    inc=20;    
end
% overlap=wlen-inc;              % ����ǰ���޻��γ���
NIS=fix((IS*fs-wlen)/inc +1);           % ����ǰ���޻���֡��
y=enframe(xx,wlen,inc)';                 % ��֡
fn=size(y,2);                           % ֡��
amp=sum(y.^2);                          % ��ȡ��ʱƽ������
amp=amp/max(amp);                 % ������ֵ��һ��
ampm = multimidfilter(amp,10);           % ��ֵ�˲�ƽ������      
ampth=mean(ampm(1:NIS));                % �����ʼ�޻����������� 
amp2=1*ampth; amp1=1*ampth;         % ����������ֵ
% T1 = amp1;T2 = amp2;T3 = zcr2;
frameTime=frame2time(fn, wlen, inc, fs);% �����֡��Ӧ��ʱ��
[voiceseg,vsl,SF,NF,T1,T2]=vad_param1D(amp,amp2,amp1,alg,Neuro_sign);% �˵���
% ��ͼ
% subplot 211; 
% plot(time,xx,'k');
% line([0 52],[amp2 amp2],'color','r','LineStyle','-');
% line([0 52],[amp1 amp1],'color','r','LineStyle','-');
% % title('�źŲ���');
% % ylabel('��ֵ'); axis([0 max(time) -1 1]); 
% % subplot 212; plot(time,xx,'k');
% % title(['������������(�����' num2str(SNR) 'dB)']);
% % ylabel('��ֵ'); axis([0 max(time) -1 1]);
% % xlabel('ʱ��/s');
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


