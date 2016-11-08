function [ displacement ] = getDisplacement( strokeSize, centers )
%This function finds displacement between strokes
%   Detailed explanation goes here

    displacement = zeros (strokeSize, strokeSize,2);
    for i = 1 : strokeSize
        for j = 1 : strokeSize
            if ((i ~= j))   
                displacement(i,j,1) = centers (j,1) - centers(i,1);
                displacement(i,j,2) = centers (j,2) - centers(i,2);
            end
        end
    end
end

