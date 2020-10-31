% 2017/12/1
% cscbme/����
% ����Ƶ����׼����ж˵��� 
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
Y=fft(y);                               % FFT�任
N2=wlen/2+1;                            % ȡ��Ƶ�ʲ���
n2=1:N2;
Y_abs=abs(Y(n2,:));                     % ȡ��ֵ

for k=1:fn                              % ����ÿ֡��Ƶ������
    DDvar(k)=var(Y_abs(:,k));
end
% Dvar=maf(DDvar,10);
Dvar=multimidfilter(DDvar,10); 
Dvar=Dvar/max(Dvar);                       % ��һ��
Dvar_rt=Dvar(NIS+1:end);
Dvar_rt(1)=Dvar_rt(2);
% % Dvar=Dvar';
% dth=mean(Dvar(2:NIS+1));                  % ��ȡ��ֵ
% T1=1*dth;
% T2=1*dth;
% s = mean(abs(Dvar(NIS+1:end)))/mean(abs(Dvar(2:NIS)));
% T1 = T1*s*1;  
% T2 = T2*s*1.5;
T1 = mean(abs(Dvar_rt))*1.2;
T2 = mean(abs(Dvar_rt))*1.6;
[voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(Dvar_rt,T1,T2,Neuro_sign);% Ƶ�򷽲�˫���޵Ķ˵���

