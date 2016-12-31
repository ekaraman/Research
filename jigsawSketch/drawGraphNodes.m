function [ figNo ] = drawGraphNodes( graphMatrix,updatedCenters, sketchXml, figNo, onCenter)
%UNTÝTLED3 Summary of this function goes here
%   Detailed explanation goes here
if (onCenter == 1)
    set(gca,'visible','off')
    hFig = figure(figNo);
    figNo = figNo + 1;
    set(hFig,'Position',[0, 0, 700, 1300]);
    axis([0 1300 -700 0]);
    figure(hFig);
    hold on;
    G = graph(graphMatrix);
    h = plot(G,'XData',updatedCenters(:,1),'YData',-1*updatedCenters(:,2));
    highlight(h,G,'NodeColor','g','EdgeColor','r','LineWidth',3,'MarkerSize',15);
    nl = h.NodeLabel;
    h.NodeLabel = '';
    xd = get(h, 'XData');
    yd = get(h, 'YData');
    text(xd, yd, nl, 'FontSize',15, 'FontWeight','bold');
    %Draw strokes on nodes
%     for i = 1 : size(sketchXml,2)
%         plot(sketchXml(1,i).coords(:,1), -sketchXml(1,i).coords(:,2),'LineWidth',3);
%     end
    hold off;
elseif (onCenter == 0)
    hFig = figure(figNo);
    figNo = figNo + 1;
    figure(hFig);
    hold on;
    G = graph(graphMatrix);
    h = plot(G);
    highlight(h,G,'NodeColor','g','EdgeColor','k','LineWidth',3,'MarkerSize',15);
    nl = h.NodeLabel;
    h.NodeLabel = '';
    xd = get(h, 'XData');
    yd = get(h, 'YData');
    text(xd, yd, nl, 'FontSize',15, 'FontWeight','bold');
    hold off;
end
    
end

