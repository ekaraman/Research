function [ groups ] = findSimStrokes( strokeSize, row, col, simSize, displacement, dispVarThrs )
%This function find mean of displacements of similar strokes
%and set smoothness cost between strokes that have similar displacement.
    %Set grid
    %grid = int32(zeros(strokeSize,strokeSize));

    %Set smoothCost
    %smthCost = 5;

    %Set threshold for displacement variance
    tDisp = dispVarThrs;
    tmp = 0;
    groups = zeros(1,4);
    
    for i = 1 : simSize
        for j = i + 1 : simSize 
        
            s1 = row(i,1);
            s2 = col(i,1);
            s3 = row(j,1);
            s4 = col(j,1);
        
            if ((s1 ~= s3) && (s2 ~= s4))
                disp1 = displacement(s1,s3,:);
                disp2 = displacement(s2,s4,:);
                tmpVar = var([disp1; disp2]);
                meanTmpVar = sum(tmpVar,3)/2;
            if (meanTmpVar < tDisp)
                tmp = tmp + 1;
                %grid(s1,s3) = smthCost;
                %grid(s2,s4) = smthCost;
                if (tmp == 1)
                    groups = [s1 s3 s2 s4];
                else
                    groups = [groups ; s1 s3 s2 s4];
                end
            end
        end
        
        if ((s1 ~= s4) && (s2 ~= s3))
            disp3 = displacement(s1,s4,:);
            disp4 = displacement(s2,s3,:);
            tmpVar = var([disp3; disp4]);
            meanTmpVar = sum(tmpVar,3)/2;
            if (meanTmpVar < tDisp)
                tmp = tmp + 1;
                %grid(s1,s4) = smthCost;
                %grid(s2,s3) = smthCost;
                if (tmp == 1)
                    groups = [s1 s4 s2 s3];
                else
                    groups = [groups ; s1 s4 s2 s3];
                end
            end
        end
        end    
    end        
end

