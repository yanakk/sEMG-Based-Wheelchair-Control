function h2=butterfilter(h1,Fs)
%������˹�˲���

%Fs;����Ƶ��
Wc=2*20/Fs;%��ֹƵ��20Hz
[b,a]=butter(4,Wc,'high');
h2=filter(b,a,h1);
% h = fdesign.highpass('n,20',8,1/600);
%butter(h);

%plot(h1,'-r');
%hold on
%plot(h2,'-b');