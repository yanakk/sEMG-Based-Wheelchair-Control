function [pxx1, f, MPF, MF]=iEMG_fd_para(emg_signal,Fs)
   sig_len=length(emg_signal);                         %求功率谱密度
   cx1=xcorr(emg_signal,'unbiased');
   NFFT = 2^nextpow2(sig_len);
   cxk1= fft(cx1,NFFT)/sig_len;
   f = Fs/2*linspace(0,1,NFFT/2+1);
   px1=2*abs(cxk1(1:NFFT/2+1));
   pxx1=10*log10(px1);
   MPF=sum(f.*px1)/sum(px1);                           %求平均功率频率
   sum_f=0;num=1;                                      %求中值频率
   th_p=1/2*sum(px1);
   while sum_f<th_p
       sum_f=sum_f+px1(num);
       num=num+1;
   end
   MF=f(num);
end
