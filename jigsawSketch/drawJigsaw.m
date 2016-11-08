function [ figNo, jigsawPos ] = drawJigsaw( figNo, strokeSize, updatedCenters, label, j1D, sketchXml, centers, offset )
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

    %Draw Jigsaw image into this directory
    jigsawImage = 'C:\Users\KARAMAN\Google Drive\RESEARCH\myResearch\jigsawImage';

    %Get assigned jigsaw 
    jigsawPos = zeros(strokeSize,2);
    for i = 1 : strokeSize
        jigsawPos(i,1) = mod ((updatedCenters(i,1) - offset (label(i),1)),j1D);
        jigsawPos(i,2) = mod ((updatedCenters(i,2) - offset (label(i),2)),j1D);
    end

    %Draw jigsaw
    cd(jigsawImage);
    delete('*.jpg');
    for i = 1: j1D
        for j = 1: j1D
            [row,col] = find (jigsawPos(:,1) == mod(i,j1D) & jigsawPos(:,2) == mod(j,j1D));
            if (size(row,1) > 0)
                set(gca,'visible','off')
                hFig = figure(figNo);
                figNo = figNo + 1;
                set(hFig,'Position',[0, 0, 700, 1300]);
                axis([0 1300 -700 0]);
                figure(hFig);
                hold on;
            for k = 1 : size(row,1)
                plot(sketchXml(1,row(k)).coords(:,1), -sketchXml(1,row(k)).coords(:,2),'LineWidth',3);
                txt1 = int2str(row(k));
                text((centers(row(k),1)+15),-centers(row(k),2)-5,txt1,'FontSize',11,'FontWeight','bold');
            end
            plotName = ['Jigsaw ',int2str(i),' ',int2str(j),'.jpg'];
            plotTitle = ['Jigsaw ',int2str(i),' ',int2str(j)];
            title(plotTitle);
            saveas(gcf,plotName);
            hold off;
            close(hFig);
        end
    end
end

end

