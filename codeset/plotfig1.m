function succeed = plotfig1(voiceseg,vsl,time,x,frameTime,ampm,zcrm,T1,T2,T3,fn,raw,figname,pngpath)
figure(1)
clf
subplot 311; 
plot(time,x,'k');
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.2
        line([frameTime(nx1-1) frameTime(nx1-1)],[-1 1],'color','b','LineStyle','-');
        line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    end
end
if(length(raw(:,1))==8)  %如果有第8个通道，绘出图形          
    scale_indicator = (max(raw(8,:))-min(raw(8,:)))/2;
    hold on
    plot(time,raw(8,:)/scale_indicator,'r')
end            
axis([0 max(time) -1 1]);
subplot 312; 
plot(frameTime,ampm,'k');
title('algorithm'); 
% xlim([0 max(time)]);
axis([0 max(time) 0 max(ampm)]);
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.2
        line([frameTime(nx1-1) frameTime(nx1-1)],[0 max(ampm)],'color','b','LineStyle','-');
        line([frameTime(nx2) frameTime(nx2)],[0 max(ampm)],'color','b','LineStyle','--');
    end
end
line([0,frameTime(fn)], [T1 T1], 'color','r','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','r','LineStyle','-');

subplot 313; 
plot(frameTime,zcrm,'k');
title('algorithm'); 
% xlim([0 max(time)]);
axis([0 max(time) 0 max(zcrm)]);
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.2
        line([frameTime(nx1-1) frameTime(nx1-1)],[0 max(zcrm)],'color','b','LineStyle','-');
        line([frameTime(nx2) frameTime(nx2)],[0 max(zcrm)],'color','b','LineStyle','--');
    end
end
line([0,frameTime(fn)], [T3 T3], 'color','r','LineStyle','-');

% saveas(1,[pngpath, figname, '.fig'],'fig');     
% saveas(1,[pngpath, figname, '.png'],'png'); 
succeed = 1;

