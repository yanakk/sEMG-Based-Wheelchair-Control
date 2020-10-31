% 2017/12/1
% cscbme/����
% ���ö�ʱ�������ж˵��� 
function [voiceseg,vsl,time_rt,xx_rt,ft,amp_rt,T1,T2,fn_rt,err] = energy_selfdevice(array1D,fs,Neuro_sign, wlen, inc)

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
    IS=0.5;
    wlen=40;
    inc=20;    
end
% overlap=wlen-inc;              % ����ǰ���޻��γ���
NIS=fix((IS*fs-wlen)/inc +1);           % ����ǰ���޻���֡��
xx_rt=xx(IS*fs+1:end);
time_rt=time(1:end-IS*fs);
y=enframe(xx,wlen,inc)';                 % ��֡
fn=size(y,2);                           % ֡��
fn_rt=fn-NIS;
amp=sum(y.^2);                          % ��ȡ��ʱƽ������
amp = multimidfilter(amp,10);           % ��ֵ�˲�ƽ������  
ampm=amp/max(amp);                 % ������ֵ��һ��
amp_rt=ampm(NIS+1:end);
amp_rt(1)=amp_rt(2);
% ampth=mean(ampm(1:NIS));                % �����ʼ�޻����������� 
% amp2=1*ampth; amp1=1*ampth;         % ����������ֵ
% T1 = amp1;T2 = amp2;T3 = zcr2;
% s = mean(abs(ampm(NIS+1:end)))/mean(abs(ampm(2:NIS)));
% T1 = amp1*s*0.8;  
% T2 = amp2*s*1.4; 
frameTime=frame2time(fn, wlen, inc, fs);% �����֡��Ӧ��ʱ��
ft=frameTime(1:end-NIS);
T1 = mean(abs(amp_rt))*1.2;
T2 = mean(abs(amp_rt))*1.6;
[voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(amp_rt,T1,T2,Neuro_sign);% �˵���
