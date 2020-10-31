function [voiceseg,vsl,T1,T2,T3,SF,NF]=vad_param2D(alg,dst1,dst2,T1,T2,T3,T4)

fn=length(dst1);                       % 取帧数
maxsilence = 12;                        % 初始化  
minlen  = 10;    
status  = 0;
count   = 0;
silence = 0;
s1 = mean(abs(dst1(65:end)))/mean(abs(dst1(2:6)));
s2 = mean(abs(dst2(65:end)))/mean(abs(dst2(2:6)));
T1 = T1*s1*1.0;  
T2 = T2*s1*1.6;
T3 = T3*s2*1.0;
%开始端点检测
xn=1;x1=0;x2=0;
for n=1:fn
   switch status
   case {0,1}                           % 0 = 静音, 1 = 可能开始
      if dst1(n) > T2  ||  ...           % 确信进入语音段
         ( nargin==7 && dst2(n) > T4 ) 
         x1(xn) = max(n-count(xn)-1,1);
         status  = 2;
         silence(xn) = 0;
         count(xn)   = count(xn) + 1;
      elseif dst1(n) > T1 || ...        % 可能处于语音段
             dst2(n) > T3
         status = 1;
         count(xn)  = count(xn) + 1;
      else                              % 静音状态
         status  = 0;
         count(xn)   = 0;
         x1(xn)=0;
         x2(xn)=0;
      end
   case 2,                              % 2 = 语音段
      if dst1(n) > T1 || ...             % 保持在语音段
         dst2(n) >  T3 
         count(xn) = count(xn) + 1;
      else                              % 语音将结束
         silence(xn) = silence(xn)+1;
         if silence(xn) < maxsilence    % 静音还不够长，尚未结束
            count(xn)  = count(xn) + 1;
         elseif count(xn) < minlen      % 语音长度太短，认为是噪声
            status  = 0;
            silence(xn) = 0;
            count(xn)   = 0;
         else                           % 语音结束
            status  = 3;
            x2(xn)=x1(xn)+count(xn);
         end
      end
   case 3,                              % 语音结束，为下一个语音准备
        status  = 0;          
        xn=xn+1; 
        count(xn)   = 0;
        silence(xn)=0;
        x1(xn)=0;
        x2(xn)=0;
   end
end   

el=length(x1);
if x1(el)==0, el=el-1; end              % 获得x1的实际长度
if x2(el)==0                            % 如果x2最后一个值为0，对它设置为fn
    fprintf('Error: Not find endding point!\n');
    x2(el)=fn;
end
SF=zeros(1,fn);                         % 按x1和x2，对SF和NF赋值
NF=ones(1,fn);
for i=1 : el
    SF(x1(i):x2(i))=1;
    NF(x1(i):x2(i))=0;
end
speechIndex=find(SF==1);                % 计算voiceseg
voiceseg=findSegment(speechIndex);
vsl=length(voiceseg);

