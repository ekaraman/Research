function [ featDist ] = idmDistance(strokeSize, feat, featVectorSize)
%This function finds euclidean distance between stroke pairs
%   Detailed explanation goes here
    featDist = ones(strokeSize, strokeSize) * -1;
    for i = 1 : strokeSize
        for j = i+1 : strokeSize
                featDist(i,j) = sqrt(sum(((feat(i,:) - feat(j,:)).^2),2));
        end
    end
end

