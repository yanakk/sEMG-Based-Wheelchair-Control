function [voiceseg,vsl,SF,NF,err]=vad_param1D_selfdevice(dst1,T1,T2,Neuro_sign)
status  = 0;
count   = 0;
silence = 0;
err=0;
fn=size(dst1,2);                       % 取得帧数

if Neuro_sign
    maxsilence = 15;                        % 初始化  
    minlen  = 10;    
else
    maxsilence = 5;                        % 初始化  
    minlen  = 5;    
end

[xindex,yindex] = max(dst1);
if mean(dst1(end-2:end))>T2    % 数据右边翘起，err=1
    err=1;
end
for ind=1:yindex               % 如果数据左边翘起，则查找从起始至最大点区间小于T1的点，从该点开始分割
    if dst1(ind)<T1
        err=0;
        break;
    else
        err=1;
    end
end

%开始端点检测
xn=1;x1=0;x2=0;
for n=2+ind-1:fn
   switch status
   case {0,1}                           % 0 = 静音, 1 = 可能开始
      if dst1(n) > T2                   % 确信进入语音段
         x1(xn) = max(n-count(xn)-1,1);
         status  = 2;
         silence(xn) = 0;
         count(xn)   = count(xn) + 1;
      elseif dst1(n) > T1               % 可能处于语音段
%             zcr(n) < zcr2
         status = 1;
         count(xn)  = count(xn) + 1;
      else                              % 静音状态
         status  = 0;
         count(xn)   = 0;
         x1(xn)=0;
         x2(xn)=0;
      end
   case 2,                              % 2 = 语音段
      if dst1(n) > T1                   % 保持在语音段
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
if el==0                                % 分割无结果，返回0
    voiceseg.begin=0;voiceseg.end=0;
    vsl=0;err=1;
    SF=0;NF=0;
    return; 
end
if x2(el)==0                            % 如果x2最后一个值为0，对它设置为fn
    fprintf('Error: Not find endding point!\n');
    err=1;
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

for i=1:vsl
    if voiceseg(i).begin<=2    
        err=1;
    end
end

if vsl==1  % 计算极小值，将分割结果外扩一个较小值坐标
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
if vsl>=2    % 如果分割成两段，满足条件时可合为一个
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