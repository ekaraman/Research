function [figNo, represent] = reconstruct( strokeSize, updatedCenters, label, offset, jMean, j1D, feat, featVectorSize, sketchXml, centers, figNo )
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

%find the best stroke that represent the the jigsaw from the strokes that
%are assigned to same jigsaw position.
    
    represent = zeros(j1D,j1D);

    %Get assigned jigsaw 
    jigsawPos = zeros(strokeSize,2);
    for i = 1 : strokeSize
        jigsawPos(i,1) = mod ((updatedCenters(i,1) - offset (label(i),1)),j1D);
        if (jigsawPos(i,1) == 0)
            jigsawPos(i,1) = j1D;
        end 
        jigsawPos(i,2) = mod ((updatedCenters(i,2) - offset (label(i),2)),j1D);
        if (jigsawPos(i,2) == 0)
            jigsawPos(i,2) = j1D;
        end
    end
    
    %
    for i = 1 : j1D
        for j = 1 : j1D
            %[strokes,col] = find (jigsawPos(:,1) == mod(i,j1D) & jigsawPos(:,2) == mod(j,j1D));
            %Find strokes assigned to same jigsaw position i,j
            strokes = find(jigsawPos(:,1) == i & jigsawPos(:,2) == j);
            if (size(strokes,1) ~= 0)
                min = 100000;
                for k = 1 : size(strokes,1)
                    dist = 0;
                    %Find euclidean distance between jigsaw and stroke feature
                    for m = 1 : featVectorSize
                        dist = sqrt((feat(strokes(k),m) - jMean(i,j,m))^2) + dist;
                    end
                    if (dist <= min) 
                        min = dist;
                        represent(i,j) = strokes(k);
                    end
                end
            end
        end
    end
    
    %Reconstruct from reprentiing matrix
     updatedSketchXml = sketchXml;
     for i = 1 : strokeSize
         representedBy = represent( jigsawPos(i,1) , jigsawPos(i,2));
         centerDispX = centers(i,1) - centers(representedBy,1);
         centerDispY = centers(i,2) - centers(representedBy,2);
         updatedSketchXml(1,i).coords = [];
         for j = 1 : size(sketchXml(1,representedBy).coords,1)
            updatedSketchXml(1,i).coords(j,1) = sketchXml(1,representedBy).coords(j,1) + centerDispX;
            updatedSketchXml(1,i).coords(j,2) = sketchXml(1,representedBy).coords(j,2) + centerDispY;
         end
     end
     
     updatedCenters = getCenters( strokeSize, updatedSketchXml );
     
     figNo = drawCanvas( updatedSketchXml, updatedCenters, figNo );

    
end

