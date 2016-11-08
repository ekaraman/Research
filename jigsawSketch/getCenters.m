function [ centers ] = getCenters( strokeSize, sketchXml )
%This functions find centers of strokes
%   Detailed explanation goes here
    centers = zeros(strokeSize,2);
    for i = 1 : strokeSize
        middlePoint1 = ceil(sketchXml(1,i).npts / 2);
        x1 = sketchXml(1,i).coords(middlePoint1,1);
        y1 = sketchXml(1,i).coords(middlePoint1,2);
        centers(i,1) = x1;
        centers(i,2) = y1;
 end

end

