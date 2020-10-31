function [voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(dst1,T1,T2,Neuro_sign)
status  = 0;
count   = 0;
silence = 0;
err=0;
fn=size(dst1,2);                       % ȡ��֡��

if Neuro_sign
    maxsilence = 15;                        % ��ʼ��  
    minlen  = 10;    
else
    maxsilence = 5;                        % ��ʼ��  
    minlen  = 5;    
end

[xindex,yindex] = max(dst1);
if mean(dst1(end-2:end))>T2    % �����ұ�����err=1
    err=1;
end
for ind=1:yindex               % ������������������Ҵ���ʼ����������С��T1�ĵ㣬�Ӹõ㿪ʼ�ָ�
    if dst1(ind)<T1
        err=0;
        break;
    else
        err=1;
    end
end

%��ʼ�˵���
xn=1;x1=0;x2=0;
for n=2+ind-1:fn
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
if el==0                                % �ָ��޽��������0
    voiceseg.begin=0;voiceseg.end=0;
    vsl=0;err=1;
    SF=0;NF=0;
    return; 
end
if x2(el)==0                            % ���x2���һ��ֵΪ0����������Ϊfn
    fprintf('Error: Not find endding point!\n');
    err=1;
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

for i=1:vsl
    if voiceseg(i).begin<=2    
        err=1;
    end
end

if vsl==1  % ���㼫Сֵ�����ָ�������һ����Сֵ����
    [Pks2, Locs2] = findpeaks(-dst1);
    p = find(Pks2<voiceseg(1).begin);
    q = find(Pks2>voiceseg(1).end);
    if(~isempty(p)) 
        p1=p(end);
        voiceseg(1).begin = Pks2(p1); 
    end
    if(~isempty(q)) 
        q1=q(1);
        voiceseg(1).end = Pks2(q1); 
    end    
    voiceseg(1).duration = voiceseg(1).end-voiceseg(1).begin+1;
end
if vsl>=2    % ����ָ�����Σ���������ʱ�ɺ�Ϊһ��
    for i=1:vsl
        st(i) = voiceseg(i).begin;
        ed(i) = voiceseg(i).end;
    end
    if voiceseg(2).begin-voiceseg(1).end<=100
        voiceseg(2) = [];
        voiceseg(1).begin = st(1);
        voiceseg(1).end = ed(2);
        vsl = 1;
    end
end