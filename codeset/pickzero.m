function zeroindex=pickzero(x) 
%pick the index of 0 or the nearest in a vector 
%找出数组的零值及过零点（正负相交处，可能偏离0！） 
m = length(x); 
x1=x(1:m-1); 
x2=x(2:m); 
indz = find(x==0); %zero point 
indzer = find(x1.*x2<0); %negative/positive 
n=length(indzer); 
for i=1:n 
    if abs(x(indzer(i)))>abs(x(indzer(i)+1)) 
        indzer(i)=indzer(i)+1; 
    end 
end 
zeroindex=sort([indz indzer],2,'ascend'); %2为对矩阵按行排序，ascend为升序