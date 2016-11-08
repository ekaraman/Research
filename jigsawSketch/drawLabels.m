function [ figNo ] = drawLabels( label, j1D, figNo, sketchXml, centers  )
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here

%Draw labels
    %Draw jigsaw labels into this directory
    jigsawLabels = 'C:\Users\KARAMAN\Google Drive\RESEARCH\myResearch\jigsawLabels';
    cd(jigsawLabels);
    delete('*.jpg');

    uniqLabels = unique(label);
    subPlotNo = (j1D*j1D)+2;
    for i = 1: size(uniqLabels,1)
        tmpLabels = find (label == uniqLabels(i));
        hFig = figure(figNo);
        figNo = figNo + 1;
        set(hFig,'Position',[0, 0, 1300, 700]);
        set(gca,'visible','off')
        axis([0 1300 -700 0]);
        figure(hFig);
        hold on;
        for j = 1 : size(tmpLabels)
            plot(sketchXml(1,tmpLabels(j)).coords(:,1), -sketchXml(1,tmpLabels(j)).coords(:,2),'LineWidth',3);
            txt1 = int2str(tmpLabels(j));
            text((centers(tmpLabels(j),1)+15),-centers(tmpLabels(j),2)-5,txt1);
        end
        plotName = ['Label ',int2str(uniqLabels(i)),'.jpg'];
        plotTitle = ['Label ',int2str(uniqLabels(i))];
        title(plotTitle);
        saveas(gcf,plotName);
        hold off;
        close(hFig);
    end
end

