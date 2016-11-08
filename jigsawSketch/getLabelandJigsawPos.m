function [ summaryMatrix, labelMatrix ] = getLabelandJigsawPos( groups, offset, label, jigsawPos, strokeSize, updatedCenters )
%UNTÝTLED4 Summary of this function goes here
%   Detailed explanation goes here

    summaryMatrix=[];
    labelMatrix = -10000 * ones(strokeSize,2);
    for i = 1 : size(groups,1)
	
        %Get pattern nodes
        s1 = groups(i,1);
        s2 = groups(i,2);
        s3 = groups(i,3);
        s4 = groups(i,4);

        %Get pattern Labels
        labelS1X = offset(label(s1),1);
        labelS1Y = offset(label(s1),2);
        labelS2X = offset(label(s2),1);
        labelS2Y = offset(label(s2),2);
        labelS3X = offset(label(s3),1);
        labelS3Y = offset(label(s3),2);
        labelS4X = offset(label(s4),1);
        labelS4Y = offset(label(s4),2);

        %Get Jigsaw Positions
        jigsawS1X = jigsawPos(s1,1);
        jigsawS1Y = jigsawPos(s1,2);
        jigsawS2X = jigsawPos(s2,1);
        jigsawS2Y = jigsawPos(s2,2);
        jigsawS3X = jigsawPos(s3,1);
        jigsawS3Y = jigsawPos(s3,2);
        jigsawS4X = jigsawPos(s4,1);
        jigsawS4Y = jigsawPos(s4,2);
        
        %Get updated Centers
        centerS1X = updatedCenters(s1,1);
        centerS1Y = updatedCenters(s1,2);
        centerS2X = updatedCenters(s2,1);
        centerS2Y = updatedCenters(s2,2);
        centerS3X = updatedCenters(s3,1);
        centerS3Y = updatedCenters(s3,2);
        centerS4X = updatedCenters(s4,1);
        centerS4Y = updatedCenters(s4,2);
        
        summaryMatrix=[summaryMatrix;s1 labelS1X labelS1Y centerS1X centerS1Y jigsawS1X jigsawS1Y s2 labelS2X labelS2Y centerS2X centerS2Y jigsawS2X jigsawS2Y s3 labelS3X labelS3Y centerS3X centerS3Y jigsawS3X jigsawS3Y s4 labelS4X labelS4Y centerS4X centerS4Y jigsawS4X jigsawS4Y];
    end

    %Get labels assigned to each stroke
    for i = 1 : strokeSize
       labelMatrix(i,1) = offset(label(i),1);
       labelMatrix(i,2) = offset(label(i),2);
    end
end

