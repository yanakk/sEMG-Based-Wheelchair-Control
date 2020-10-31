function [startval, endval] = plotfinal(f3,f4,f7,figname,pngpath)
%f7 = {voiceseg,vsl,time,x,frameTime,ampm,T1,T2,fn,err};
err=0;
% L = length(figname);
% for j = 1:L
%    if figname(j) ==  '_';
%         label_cell = strsplit(figname,figname(j));
%         alg = label_cell{1};  
%         break;
%    end
% end

if f3{10}==1 && f4{10}==1 && f7{10}==1  %���������Ϸ�����������Ϊ�޷ָ���
    err=1;
elseif f3{10}==1 && f4{10}==1
    err=1;
elseif f4{10}==1 && f7{10}==1
    err=1;
elseif f3{10}==1 && f7{10}==1
    err=1;
end

if err==1  % ���ݷָ��޽��ʱ��ͬ������ͼƬ
%     succeed=0;
    figure(1)
    clf
    subplot 411; 
    plot(f3{3},f3{4},'b');
    title('sEMG�ź�');
    ylabel('��ֵ');
    axis([0 max(f3{3}) -1 1]);
    subplot 412; 
    plot(f3{5},f3{6},'b');
    title(['�ָ��㷨-rum']);
    ylabel('��ֵ'); 
    axis([0 max(f3{3}) 0 1.2]);
    subplot 413; 
    plot(f4{5},f4{6},'b');
    title(['�ָ��㷨-bandvar']);
    ylabel('��ֵ'); 
    axis([0 max(f4{3}) 0 1.2]);    
    subplot 414; 
    plot(f7{5},f7{6},'b');
    title(['�ָ��㷨-energy']);
    ylabel('��ֵ'); 
    axis([0 max(f7{3}) 0 1.2]);
    xlabel('ʱ��/s');
%     saveas(1,[pngpath, strcat('err','_',figname), '.fig'],'fig');     
    saveas(1,[pngpath, strcat('err','_',figname), '.png'],'png'); 
    startval=0; endval=0;
    return;
end

time = f3{3};x = f3{4};
if f3{2}>=1 && f4{2}>=1 && f7{2}>=1  % ȷ�����ָ�˵�
    [a1,a2] = duble2one(f3);
    [b1,b2] = duble2one(f4);
    [c1,c2] = duble2one(f7);
    startval=cweight(a1,b1,c1);
    endval=cweight(a2,b2,c2);
elseif f3{2}>=1 && f4{2}>=1 && f7{2}<1
    [a1,a2] = duble2one(f3);
    [b1,b2] = duble2one(f4); 
    if a2<=b1 || a1>=b2   % ȥ�����ַָ����������޽��������
        err=1;
    else
        if 0
        startval=(a1+b1)/2;
        endval=(a2+b2)/2;
        end
        if 1
        startval=min(a1,b1);
        endval=max(a2,b2);
        end
    end
elseif f3{2}<1 && f4{2}>=1 && f7{2}>=1
    [a1,a2] = duble2one(f7);
    [b1,b2] = duble2one(f4);  
    if a2<=b1 || a1>=b2   % ȥ�����ַָ����������޽��������
        err=1;
    else
        if 0
        startval=(a1+b1)/2;
        endval=(a2+b2)/2;
        end
        if 1
        startval=min(a1,b1);
        endval=max(a2,b2);
        end
    end
elseif f3{2}>=1 && f4{2}<1 && f7{2}>=1
    [a1,a2] = duble2one(f3);
    [b1,b2] = duble2one(f7);  
    if a2<=b1 || a1>=b2   % ȥ�����ַָ����������޽��������
        err=1;
    else
        if 0
        startval=(a1+b1)/2;
        endval=(a2+b2)/2;
        end
        if 1
        startval=min(a1,b1);
        endval=max(a2,b2);
        end
    end   
end

if err==1  % ���ݷָ��޽��ʱ��ͬ������ͼƬ
%     succeed=0;
    figure(1)
    clf
    subplot 411; 
    plot(f3{3},f3{4},'b');
    title('sEMG�ź�');
    ylabel('��ֵ');
    axis([0 max(f3{3}) -1 1]);
    subplot 412; 
    plot(f3{5},f3{6},'b');
    title(['�ָ��㷨-rum']);
    ylabel('��ֵ'); 
    axis([0 max(f3{3}) 0 1.2]);
    subplot 413; 
    plot(f4{5},f4{6},'b');
    title(['�ָ��㷨-bandvar']);
    ylabel('��ֵ'); 
    axis([0 max(f4{3}) 0 1.2]);    
    subplot 414; 
    plot(f7{5},f7{6},'b');
    title(['�ָ��㷨-energy']);
    ylabel('��ֵ'); 
    axis([0 max(f7{3}) 0 1.2]);
    xlabel('ʱ��/s');
%     saveas(1,[pngpath, strcat('err','_',figname), '.fig'],'fig');     
    saveas(1,[pngpath, strcat('err','_',figname), '.png'],'png'); 
    startval=0; endval=0;
    return;
end

figure(1)
clf
subplot 411; 
plot(time,x,'b');
hold on
plot([startval startval],[-1 1],'color','m','LineStyle','-');
hold on
if abs(endval-max(time))<=0.005
    plot([endval-0.01 endval-0.01],[-1 1],'color','m','LineStyle','--');
else
    plot([endval endval],[-1 1],'color','m','LineStyle','--');
end
hold off
title('sEMG�ź�');
ylabel('��ֵ');
axis([0 max(time) -1 1]);
subplot 412; 
if f3{2}>=1
    voiceseg=f3{1};vsl=f3{2};frameTime=f3{5};
    fn=f3{9};T1=f3{7};T2=f3{8};
    plot(f3{5},f3{6},'b');
    hold on
    for k=1:vsl
        nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
        
        if nx1<0
            disp(k);disp(nx1);
            nx1 = 1;
        end
        
        if nx1>2
            plot([frameTime(nx1-2) frameTime(nx1-2)],[0 1.2],'color','m','LineStyle','-');
        else
            plot([frameTime(nx1) frameTime(nx1)],[0 1.2],'color','m','LineStyle','-');           
        end
        hold on
%         plot([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','m','LineStyle','--');
        if nx2==fn
            plot([frameTime(nx2-1) frameTime(nx2-1)],[0 1.2],'color','m','LineStyle','--');
        else
            plot([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','m','LineStyle','--');
        end
        hold on
    end
    plot([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
    hold on
    plot([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
    hold off
    title('rum');
    ylabel('��ֵ');
    axis([0 max(time) 0 1.2]);
end   
subplot 413;
if f4{2}>=1
    voiceseg=f4{1};vsl=f4{2};frameTime=f4{5};
    fn=f4{9};T1=f4{7};T2=f3{8};
    plot(f4{5},f4{6},'b');
    hold on
    for k=1:vsl
        nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
     
        if nx1<0
            nx1 = 1;
        end
        
        if nx1>2
            plot([frameTime(nx1-2) frameTime(nx1-2)],[0 1.2],'color','m','LineStyle','-');
        else
            plot([frameTime(nx1) frameTime(nx1)],[0 1.2],'color','m','LineStyle','-');           
        end
        hold on
%         plot([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','m','LineStyle','--');
        if nx2==fn
            plot([frameTime(nx2-1) frameTime(nx2-1)],[0 1.2],'color','m','LineStyle','--');
        else
            plot([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','m','LineStyle','--');
        end        
        hold on
    end 
%     plot([frameTime(17-2) frameTime(17-2)],[0 1.2],'color','k','LineStyle','-');
%     hold on
%     plot([frameTime(33) frameTime(33)],[0 1.2],'color','k','LineStyle','--');
%     hold on
    plot([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
    hold on
    plot([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
    hold off
    title('bandvar');
    ylabel('��ֵ');
    axis([0 max(time) 0 1.2]);
end
subplot 414; 
if f7{2}>=1
    voiceseg=f7{1};vsl=f7{2};frameTime=f7{5};
    fn=f7{9};T1=f7{7};T2=f7{8};
    plot(f7{5},f7{6},'b');
    hold on
    for k=1:vsl
        nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
        
        if nx1<0
            nx1 = 1;
        end
        
        if nx1>2
            plot([frameTime(nx1-2) frameTime(nx1-2)],[0 1.2],'color','m','LineStyle','-');
        else
            plot([frameTime(nx1) frameTime(nx1)],[0 1.2],'color','m','LineStyle','-');           
        end
        hold on
%         plot([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','m','LineStyle','--');
        if nx2==fn
            plot([frameTime(nx2-1) frameTime(nx2-1)],[0 1.2],'color','m','LineStyle','--');
        else
            plot([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','m','LineStyle','--');
        end
        hold on
    end
    plot([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
    hold on
    plot([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
    hold off
    title('energy');
    ylabel('��ֵ');
    axis([0 max(time) 0 1.2]);
    xlabel('ʱ��/s');
end
% for k=1 : vsl                           % ����˵�
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
% %     if frameTime(nx1)>0.25
%     if nx1<=yval && yval<=nx2
%         if nx1>2
%             plot([frameTime(nx1-2) frameTime(nx1-2)],[-1 max(Rum)*1.2],'color','m','LineStyle','-');
%         else
%             plot([frameTime(nx1) frameTime(nx1)],[-1 max(Rum)*1.2],'color','m','LineStyle','-');           
%         end
%         hold on
%         if nx2==fn
%             plot([frameTime(nx2-1) frameTime(nx2-1)],[-1 max(Rum)*1.2],'color','m','LineStyle','--');
%         else
%             plot([frameTime(nx2) frameTime(nx2)],[-1 max(Rum)*1.2],'color','m','LineStyle','--');
%         end
%     end
% %     end
% end
% if(length(raw(:,1))==8)  %����е�8��ͨ�������ͼ��          
%     scale_indicator = (max(raw(8,:))-min(raw(8,:)))/2;
%     hold on
%     plot(time,raw(8,:)/scale_indicator,'r')
%     hold off
% end     
% title('sEMG�ź�');
% ylabel('��ֵ');
% xlabel('ʱ��/s');
% axis([0 max(time) -1 1]);
% subplot 212; 
% plot(frameTime,Rum,'b');
% hold on
% % axis([0 max(time) 0 1.2]);
% % xlim([0 max(time)]);
% for k=1 : vsl                           % ����˵�
%     nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
%     if nx1<=yval && yval<=nx2
%         if nx1>2
%             plot([frameTime(nx1-2) frameTime(nx1-2)],[0 max(Rum)*1.2],'color','m','LineStyle','-');
%         else
%             plot([frameTime(nx1) frameTime(nx1)],[0 max(Rum)*1.2],'color','m','LineStyle','-');           
%         end
%         hold on
%         if nx2==fn
%             plot([frameTime(nx2-1) frameTime(nx2-1)],[0 max(Rum)*1.2],'color','m','LineStyle','--');
%         else
%             plot([frameTime(nx2) frameTime(nx2)],[0 max(Rum)*1.2],'color','m','LineStyle','--');
%         end
%         hold on        
%     end
% %     end
% end
% plot([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
% hold on
% plot([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
% hold off
% title(['�ָ��㷨-' alg]);
% ylabel('��ֵ'); 
% xlabel('ʱ��/s');
% axis([0 max(time) 0 1.2]);
% saveas(1,[pngpath, figname, '.fig'],'fig');     
saveas(1,[pngpath, figname, '.png'],'png'); 
% succeed = 1;