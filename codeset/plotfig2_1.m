function succeed = plotfig2_1(f3,f4,f7,figname,raw,pngpath)
% voiceseg,vsl,time,x,frameTime,Dvar,T1,T2,fn
figure(1)
clf
% subplot 211; 
time = f3{3};z = f3{4};
% plot3(time(1251:2501),ones(1251,1)*5,z(1251:2501))
% hold on
% z = ones(1251,1)*z(1251:2501);
% [x,y]=meshgrid(time(1251:2501));
% mesh(x,y,z);

p(1)=plot(time,z,'k');
hold on
voiceseg = f3{1};
vsl = f3{2};
frameTime = f3{5};
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.2%5 && frameTime(nx2)<10
       p(2)= plot([frameTime(nx1-1) frameTime(nx1-1)],[-1 1],'color','b','LineStyle','-','LineWidth',1.5);
        hold on
       p(3)= plot([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--','LineWidth',1.5);
        hold on
    end
end
voiceseg = f4{1};
vsl = f4{2};
frameTime = f4{5};
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.20
       p(4)= plot([frameTime(nx1-1) frameTime(nx1-1)],[-1+0.2 1+0.2],'color','c','LineStyle','-','LineWidth',1.5);
        hold on
       p(5)= plot([frameTime(nx2) frameTime(nx2)],[-1+0.2 1+0.2],'color','c','LineStyle','--','LineWidth',1.5);
        hold on
    end
end
voiceseg = f7{1};
vsl = f7{2};
frameTime = f7{5};
for k=1 : vsl                           % 标出端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    if frameTime(nx1)>0.20
       p(6)= plot([frameTime(nx1-1) frameTime(nx1-1)],[-1+0.4 1+0.4],'color','m','LineStyle','-','LineWidth',1.5);
        hold on
       p(7)= plot([frameTime(nx2) frameTime(nx2)],[-1+0.4 1+0.4],'color','m','LineStyle','--','LineWidth',1.5);
        hold on
    end
end

if(length(raw(:,1))==8)  %如果有第8个通道，绘出图形          
    scale_indicator = (max(raw(8,:))-min(raw(8,:)))/2;
   p(8)= plot(time,raw(8,:)/scale_indicator/4,'r');
%    ylim([-0.4 0.4]);
    hold off
end          
% axis([8.8 18.8 -1 1]);
axis([0 max(time) -1 1]);
if strcmp(figname,'de_4')
else
legend(p,'wave','rum','rum','bandvar','bandvar','energy','energy','sign');
end
% subplot 212; 
% plot(frameTime,Rum,'k');
% title('algorithm'); 
% % axis([0 max(time) 0 1.2]);
% xlim([0 max(time)]);
% for k=1 : vsl                           % 标出端点
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     if frameTime(nx1)>0.2
%         line([frameTime(nx1-1) frameTime(nx1-1)],[0 max(Rum)*1.2],'color','b','LineStyle','-');
%         line([frameTime(nx2) frameTime(nx2)],[0 max(Rum)*1.2],'color','b','LineStyle','--');
%     end
% end
% line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
% line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');

saveas(1,[pngpath, figname, '.fig'],'fig');     
saveas(1,[pngpath, figname, '.png'],'png'); 
succeed = 1;