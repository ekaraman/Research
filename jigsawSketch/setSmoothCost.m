function [ grid, centers ] = setSmoothCost( groupCluster, connection, grid, centers, displacement )
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

checkUpdate=zeros(size(centers,1),1);

groupSize = max(groupCluster(:,3));

smoothness = 100;

for i = 1 : groupSize
    tmpDisp = [];
    [r] = find (groupCluster(:,3) == i);
    for j = 1 : size(r,1)
        tmpDisp = [tmpDisp; displacement(groupCluster(r(j),1),groupCluster(r(j),2),:)];
    end
    meanVarX = floor(sum(tmpDisp(:,:,1))/size(r,1));
    meanVarY = floor(sum(tmpDisp(:,:,2))/size(r,1));
    
    flag = 0;
    for j = 1 : size(r,1)
        if (checkUpdate(groupCluster(r(j),2)) == 1) || (checkUpdate(groupCluster(r(j),1)) == 1)
           flag = flag + 1;
           if (flag == 1)
            %updatedNode = groupCluster(r(j),2);
            meanVarX = floor(centers(groupCluster(r(j),2),1) - centers(groupCluster(r(j),1),1));
            meanVarY = floor(centers(groupCluster(r(j),2),2) - centers(groupCluster(r(j),1),2));;
           end
        end
    end
    
    for j = 1 : size(r,1)
        if (flag == 0)
            centers(groupCluster(r(j),2),1) = centers(groupCluster(r(j),1),1) + meanVarX;
            centers(groupCluster(r(j),2),2) = centers(groupCluster(r(j),1),2) + meanVarY;
            checkUpdate(groupCluster(r(j),1)) = 1;
            checkUpdate(groupCluster(r(j),2)) = 1;
            if (groupCluster(r(j),1) > groupCluster(r(j),2))
                grid(groupCluster(r(j),2),groupCluster(r(j),1)) = smoothness;
            elseif (groupCluster(r(j),1) < groupCluster(r(j),2))
                grid(groupCluster(r(j),1),groupCluster(r(j),2)) = smoothness;
            end
        elseif (flag == 1)
            centers(groupCluster(r(j),2),1) = centers(groupCluster(r(j),1),1) + meanVarX;
            centers(groupCluster(r(j),2),2) = centers(groupCluster(r(j),1),2) + meanVarY; 
            if (groupCluster(r(j),1) > groupCluster(r(j),2))
                grid(groupCluster(r(j),2),groupCluster(r(j),1)) = smoothness;
            elseif (groupCluster(r(j),1) < groupCluster(r(j),2))
                grid(groupCluster(r(j),1),groupCluster(r(j),2)) = smoothness;
            end
        end
    end
end



end

