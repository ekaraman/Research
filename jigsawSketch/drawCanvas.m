function [figNo] = drawCanvas( sketchXml, centers, figNo )
%Draw strokes on canvas
%   Detailed explanation goes here

    %Plot coordinates
    %axis off;
    set(gca,'visible','off')
    hFig = figure(figNo);
    figNo = figNo + 1;
    set(hFig,'Position',[0, 0, 700, 1300]);
    axis([0 1300 -700 0]);
    figure(hFig);
    hold on;
    for i = 1 : size(sketchXml,2)
        plot(sketchXml(1,i).coords(:,1), -sketchXml(1,i).coords(:,2),'LineWidth',3);
        txt1 = int2str(i);
        text((centers(i,1)+15),-centers(i,2)-5,txt1,'FontSize',11,'FontWeight','bold');
    end
    hold off;
    %close(hFig);
    %Draw strokes
    pwdDir = pwd;
    cd('strokes');
    delete('*.jpg');
    for i = 1 : size(sketchXml,2)
       set(gca,'visible','off')
       hFig = figure(figNo);
       set(hFig,'Position',[0, 0, 700, 1300]);
       axis([0 1300 -700 0]);
       figure(hFig);
       hold on;
       plot(sketchXml(1,i).coords(:,1), -sketchXml(1,i).coords(:,2),'LineWidth',3);
       txt1 = int2str(i);
       text((centers(i,1)+15),-centers(i,2)-5,txt1,'FontSize',11,'FontWeight','bold');
       plotName = ['Stroke ',int2str(i),'.jpg'];
       plotTitle = ['Stroke ',int2str(i)];
       title(plotTitle);
       saveas(gcf,plotName);
       hold off;
       close(hFig);
    end
    figNo = figNo + 1;
    cd(pwdDir);
end

