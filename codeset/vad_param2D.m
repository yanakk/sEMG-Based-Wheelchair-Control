function [voiceseg,vsl,T1,T2,T3,SF,NF]=vad_param2D(alg,dst1,dst2,T1,T2,T3,T4)

fn=length(dst1);                       % ȡ֡��
maxsilence = 12;                        % ��ʼ��  
minlen  = 10;    
status  = 0;
count   = 0;
silence = 0;
s1 = mean(abs(dst1(65:end)))/mean(abs(dst1(2:6)));
s2 = mean(abs(dst2(65:end)))/mean(abs(dst2(2:6)));
T1 = T1*s1*1.0;  
T2 = T2*s1*1.6;
T3 = T3*s2*1.0;
%��ʼ�˵���
xn=1;x1=0;x2=0;
for n=1:fn
   switch status
   case {0,1}                           % 0 = ����, 1 = ���ܿ�ʼ
      if dst1(n) > T2  ||  ...           % ȷ�Ž���������
         ( nargin==7 && dst2(n) > T4 ) 
         x1(xn) = max(n-count(xn)-1,1);
         status  = 2;
         silence(xn) = 0;
         count(xn)   = count(xn) + 1;
      elseif dst1(n) > T1 || ...        % ���ܴ���������
             dst2(n) > T3
         status = 1;
         count(xn)  = count(xn) + 1;
      else                              % ����״̬
         status  = 0;
         count(xn)   = 0;
         x1(xn)=0;
         x2(xn)=0;
      end
   case 2,                              % 2 = ������
      if dst1(n) > T1 || ...             % ������������
         dst2(n) >  T3 
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

