function succeed = plotfig2(voiceseg,vsl,time,x,frameTime,Rum,T1,T2,fn,raw,figname,pngpath)
if voiceseg(1).begin==0
    succeed=0;
    return;
end
figure(1)
clf
subplot 211; 
plot(time,x,'k');
hold on
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.25
        plot([frameTime(nx1-1) frameTime(nx1-1)],[-1 1],'color','b','LineStyle','-');
        hold on
        plot([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    end
end
if(length(raw(:,1))==8)  %如果有第8个通道，绘出图形          
    scale_indicator = (max(raw(8,:))-min(raw(8,:)))/2;
    hold on
    plot(time,raw(8,:)/scale_indicator,'r')
    hold off
end            
axis([0 max(time) -1 1]);
subplot 212; 
plot(frameTime,Rum,'k');
hold on
title('algorithm'); 
% axis([0 max(time) 0 1.2]);
xlim([0 max(time)]);
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.25
        plot([frameTime(nx1-1) frameTime(nx1-1)],[0 max(Rum)*1.2],'color','b','LineStyle','-');
        hold on
        plot([frameTime(nx2) frameTime(nx2)],[0 max(Rum)*1.2],'color','b','LineStyle','--');
        hold on
    end
end
plot([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
hold on
plot([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
hold off
% saveas(1,[pngpath, figname, '.fig'],'fig');     
% saveas(1,[pngpath, figname, '.png'],'png'); 
succeed = 1;