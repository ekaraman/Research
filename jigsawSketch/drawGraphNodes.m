function [ figNo ] = drawGraphNodes( graphMatrix,updatedCenters, sketchXml, figNo)
%UNTÝTLED3 Summary of this function goes here
%   Detailed explanation goes here
    set(gca,'visible','off')
    hFig = figure(figNo);
    figNo = figNo + 1;
    set(hFig,'Position',[0, 0, 700, 1300]);
    axis([0 1300 -700 0]);
    figure(hFig);
    hold on;
    G = graph(graphMatrix);
    plot(G,'XData',updatedCenters(:,1),'YData',-1*updatedCenters(:,2))
    for i = 1 : size(sketchXml,2)
        plot(sketchXml(1,i).coords(:,1), -sketchXml(1,i).coords(:,2),'LineWidth',3);
    end
    hold off;
end

