% 2017/12/1
% cscbme/����
% ��������غ������ж˵��� 
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
xx=xx-mean(xx);                         % ����ֱ������
x=xx/max(abs(xx));                      % ��ֵ��һ��
x_rt=x(IS*fs+1:end);
N=length(x);                            % ȡ�źų���
time=(0:N-1)/fs;                        % ����ʱ��
time_rt=time(1:end-IS*fs);
wnd=hamming(wlen);                      % ���ô�����
overlap=wlen-inc;                       % ���ص�������
NIS=fix((IS*fs-wlen)/inc +1);           % ��ǰ���޻���֡��

y=enframe(x,wnd,inc)';                  % ��֡
fn=size(y,2);                           % ��֡��
fn_rt=fn-NIS;
frameTime=frame2time(fn, wlen, inc, fs);% �����֡��Ӧ��ʱ��
ft=frameTime(1:end-NIS);
for k=2 : fn                            % ��������غ���
    u=y(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end
Rum=multimidfilter(Ru,10);              % ƽ������
Rum=Rum/max(Rum);                       % ��һ��
Rum_rt=Rum(NIS+1:end);
Rum_rt(1)=Rum_rt(2);
% thredth=max(Rum(1:NIS));                % ������ֵ
% T1=1*thredth;
% T2=1*thredth;
% s = mean(abs(Rum_rt))/mean(abs(Rum(2:NIS)));
% T1 = T1*s*0.45;  
% T2 = T2*s*0.8;

T1 = mean(abs(Rum_rt))*1.2;
T2 = mean(abs(Rum_rt))*1.6;

[voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(Rum_rt,T1,T2,Neuro_sign);% ����غ����Ķ˵���




