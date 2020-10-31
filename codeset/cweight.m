function m=cweight(a,b,c)

if a==b || a==c
    m=a;
elseif b==c
    m=b;
else    
    x=(a+b+c)/3;
    [v,i]=max([abs(a-x),abs(b-x),abs(c-x)]);
    if i==1
        m=(b+c)/2;
    elseif i==2
        m=(a+c)/2;
    elseif i==3
        m=(a+b)/2;
    end
end
