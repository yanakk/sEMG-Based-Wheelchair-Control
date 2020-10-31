% 2017/12/1
% cscbme/����
% ���þ����Ӵ�����Ƶ��������ж˵��� 
function [voiceseg,vsl,time,x,frameTime,Dvarm,T1,T2,fn] = subbandvar(array1D,fs,alg) 

IS=0.2;
wlen=30;
inc=20;
xx=array1D;
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

Y=fft(y);                               % FFT�任
N2=wlen/2+1;                            % ȡ��Ƶ�ʲ���
n2=1:N2;
Y_abs=abs(Y(n2,:));                     % ȡ��ֵ
M=fix(N2/4);                            % �����Ӵ���
for k=1 : fn
    for i=1 : M                         % ÿ���Ӵ�����4������
        j=(i-1)*4+1;
        SY(i,k)=Y_abs(j,k)+Y_abs(j+1,k)+Y_abs(j+2,k)+Y_abs(j+3,k);
    end
    Dvar(k)=var(SY(:,k));               % ����ÿ֡�Ӵ������Ƶ������
end
Dvarm=multimidfilter(Dvar,10);          % ƽ������
dth=mean(Dvarm(1:(NIS)));               % ��ֵ����
T1=1*dth;
T2=1*dth;
[voiceseg,vsl,SF,NF,T1,T2]=vad_param1D(Dvarm,T1,T2,alg);% ˫���޵Ķ˵���
% ��ͼ
% figure(1)
% clf
% subplot 211; plot(time,x,'k');
% title('�źŲ���');
% ylabel('��ֵ'); axis([0 max(time) -1 1]);
% % subplot 312; plot(time,x,'k');
% % title('���벨��');
% % ylabel('��ֵ'); axis([0 max(time) -1 1]);
% subplot 212; plot(frameTime,Dvar,'k');
% title('��ʱƵ����׼��'); grid; ylim([0 1.2*max(Dvar)]);
% xlabel('ʱ��/s'); ylabel('��ֵ'); 
% line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
% line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
% for k=1 : vsl                           % ��������˵�
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
%     subplot 211; 
%     line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');  
%     subplot 212; 
%     line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Dvar)],'color','b','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Dvar)],'color','b','LineStyle','--');
% end

