function [voiceseg,vsl,SF,NF,T1,T2]=vad_param1D(dst1,T1,T2,alg,Neuro_sign)
status  = 0;
count   = 0;
silence = 0;
fn=size(dst1,2);                       % ȡ��֡��
if Neuro_sign
    maxsilence = 15;                        % ��ʼ��  
    minlen  = 10;    
    s = mean(abs(dst1(65:end)))/mean(abs(dst1(2:6)));
    if alg==3 || alg==4
        T1 = T1*s*1;  
        T2 = T2*s*1.5;
    elseif alg==5 || alg==6
        T1 = T1*s*1;  %alg==5,6
        T2 = T2*s*1.5;
    elseif alg==7
        T1 = T1*s*1;  
        T2 = T2*s*1.5;    
    end
else
    maxsilence = 15;                        % ��ʼ��  
    minlen  = 15;    
    s = mean(abs(dst1(2:end)))/mean(abs(dst1(2:6)));
    if alg==3
        T1 = T1*s*0.6;  
        T2 = T2*s*1;
    elseif alg==4
        T1 = T1*s*1;  
        T2 = T2*s*1.5;
    elseif alg==7
        T1 = T1*s*0.8;  
        T2 = T2*s*1.6;     
    end
end

%��ʼ�˵���
xn=1;x1=0;x2=0;
for n=2:fn
   switch status
   case {0,1}                           % 0 = ����, 1 = ���ܿ�ʼ
      if dst1(n) > T2                   % ȷ�Ž���������
         x1(xn) = max(n-count(xn)-1,1);
         status  = 2;
         silence(xn) = 0;
         count(xn)   = count(xn) + 1;
      elseif dst1(n) > T1               % ���ܴ���������
%             zcr(n) < zcr2
         status = 1;
         count(xn)  = count(xn) + 1;
      else                              % ����״̬
         status  = 0;
         count(xn)   = 0;
         x1(xn)=0;
         x2(xn)=0;
      end
   case 2,                              % 2 = ������
      if dst1(n) > T1                   % ������������
         count(xn) = count(xn) + 1;
      else                              % ����������
         silence(xn) = silence(xn)+1;
         if silence(xn) < maxsilence    % ����������������δ����
            count(xn)  = count(xn) + 1;
         elseif count(xn) < minlen      % ��������̫�̣���Ϊ������
            status  = 0;
            silence(xn) = 0;
            count(xn)   = 0;
         else                           % ��������
            status  = 3;
            x2(xn)=x1(xn)+count(xn);
         end
      end
   case 3,                              % ����������Ϊ��һ������׼��
        status  = 0;          
        xn=xn+1; 
        count(xn)   = 0;
        silence(xn)=0;
        x1(xn)=0;
        x2(xn)=0;
   end
end   
el=length(x1);
if x1(el)==0, el=el-1; end              % ���x1��ʵ�ʳ���
if el==0  
    voiceseg.begin=0;voiceseg.end=0;
    vsl=0;
    SF=0;NF=0;
    return; 
end
if x2(el)==0                            % ���x2���һ��ֵΪ0����������Ϊfn
    fprintf('Error: Not find endding point!\n');
    x2(el)=fn;
end
SF=zeros(1,fn);                         % ��x1��x2����SF��NF��ֵ
NF=ones(1,fn);
for i=1 : el
    SF(x1(i):x2(i))=1;
    NF(x1(i):x2(i))=0;
end
speechIndex=find(SF==1);                % ����voiceseg
voiceseg=findSegment(speechIndex);
vsl=length(voiceseg);
