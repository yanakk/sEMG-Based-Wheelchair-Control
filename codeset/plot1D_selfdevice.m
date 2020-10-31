function succeed = plot1D_selfdevice(voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn,raw,figname,pngpath,err)
L = length(figname);
for j = 1:L
   if figname(j) ==  '_';
        label_cell = strsplit(figname,figname(j));
        alg = label_cell{1};  
        break;
   end
end
if vsl==0 || err==1  % 数据分割无结果时，同样保存图片
    succeed=0;
    figure(1)
    clf
    subplot 211; 
    plot(time,x,'b');
    title('sEMG信号');
    ylabel('幅值');
    axis([0 max(time) -1 1]);
    subplot 212; 
    plot(frameTime,Rum,'b');
    hold on
    plot([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
    hold on
    plot([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
    hold off
    title(['分割算法-' alg]);
    ylabel('幅值'); 
    xlabel('时间/s');
    axis([0 max(time) 0 1.2]);
%     saveas(1,[pngpath, strcat('err','_',figname), '.fig'],'fig');     
    saveas(1,[pngpath, strcat('err','_',figname), '.png'],'png'); 
    return;
end

[xval,yval] = max(Rum); %计算数据最大值点和坐标，确保分割的数据包含最大值点

figure(1)
clf
subplot 211; 
plot(time,x,'b');
hold on
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     if frameTime(nx1)>0.25
    if nx1<=yval && yval<=nx2
        if nx1>2
            plot([frameTime(nx1-2) frameTime(nx1-2)],[-1 max(Rum)*1.2],'color','m','LineStyle','-');
        else
            plot([frameTime(nx1) frameTime(nx1)],[-1 max(Rum)*1.2],'color','m','LineStyle','-');           
        end
        hold on
        if nx2==fn
            plot([frameTime(nx2-1) frameTime(nx2-1)],[-1 max(Rum)*1.2],'color','m','LineStyle','--');
        else
            plot([frameTime(nx2) frameTime(nx2)],[-1 max(Rum)*1.2],'color','m','LineStyle','--');
        end
    end
%     end
end
if(length(raw(:,1))==8)  %如果有第8个通道，绘出图形          
    scale_indicator = (max(raw(8,:))-min(raw(8,:)))/2;
    hold on
    plot(time,raw(8,:)/scale_indicator,'r')
    hold off
end     
title('sEMG信号');
ylabel('幅值');
axis([0 max(time) -1 1]);
subplot 212; 
plot(frameTime,Rum,'b');
hold on
% axis([0 max(time) 0 1.2]);
% xlim([0 max(time)]);
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if nx1<=yval && yval<=nx2
        if nx1>2
            plot([frameTime(nx1-2) frameTime(nx1-2)],[0 max(Rum)*1.2],'color','m','LineStyle','-');
        else
            plot([frameTime(nx1) frameTime(nx1)],[0 max(Rum)*1.2],'color','m','LineStyle','-');           
        end
        hold on
        if nx2==fn
            plot([frameTime(nx2-1) frameTime(nx2-1)],[0 max(Rum)*1.2],'color','m','LineStyle','--');
        else
            plot([frameTime(nx2) frameTime(nx2)],[0 max(Rum)*1.2],'color','m','LineStyle','--');
        end
        hold on        
    end
%     end
end
plot([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
hold on
plot([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
hold off
title(['分割算法-' alg]);
ylabel('幅值'); 
xlabel('时间/s');
axis([0 max(time) 0 1.2]);
% saveas(1,[pngpath, figname, '.fig'],'fig');     
saveas(1,[pngpath, figname, '.png'],'png'); 
succeed = 1;