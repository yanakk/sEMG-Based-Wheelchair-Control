function [a1,a2] = duble2one(f3)
    voiceseg=f3{1};frameTime=f3{5};
    [xval,yval] = max(f3{6}); %计算数据最大值点和坐标，确保分割的数据包含最大值点
    a1=0;a2=0;
    for k=1:f3{2}
        nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
        
        %disp(nx1);disp(nx2);
        if nx1<0
            disp(k);disp(nx1);
            nx1 = 1;
        end
        
        if nx1<=yval && yval<=nx2
            if nx1>2
                a1 = frameTime(nx1-2);a2 = frameTime(nx2);
%             elseif nx1>2
%                 a1 = frameTime(nx1-2);a2 = frameTime(nx2);
            else
                a1 = frameTime(nx1);a2 = frameTime(nx2);
            end
        end
    end