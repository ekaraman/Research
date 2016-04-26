function [ groupCluster ] = getGroups( connection )
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
groupSize = 0;
groupCluster = [];

while(~isempty(connection))
    [r] = find(connection(:,1) == connection(1,1) & connection(:,2) == connection(1,2));
    group = zeros(1,1);
    group(1,1) = connection (1,1);
    group(1,2) = connection (1,2);
    groupClusterTmp = [];
    for i = 1 : size(r)
        group = [group; connection(r(i),3) connection(r(i),4)];
        connection(r(i),9) = -1;
    end
    
    for i = 1 : size(connection,1)
        for j = 1 : size(group,1)
            %check first two column (i,j)
            if (group(j,1) == connection(i,1) && group(j,2) == connection(i,2) && connection(i,9) == 0)
                flag = 0;
                for k = 1 : size(group,1)
                    if (group(k,1) == connection(i,3) && group(k,2) == connection(i,4))
                        connection(i,9) = -1;
                        flag = 1;   
                        break
                    end
                end
                if (flag == 0)
                    group = [group; connection(i,3) connection(i,4)];
                    connection(i,9) = -1;
                end
            end
            
            %check next two columns(m,n)
            if (group(j,1) == connection(i,3) && group(j,2) == connection(i,4) && connection(i,9) == 0)
                flag = 0;
                for k = 1 : size(group,1)
                    if (group(k,1) == connection(i,1) && group(k,2) == connection(i,2))
                         connection(i,9) = -1;
                         flag = 1;   
                         break
                    end
                end
                if (flag == 0)
                    group = [group; connection(i,1) connection(i,2)];
                    connection(i,9) = -1;
                end
            end
        end
    end
    
    sizeUpdated = size(find (connection(:,9) == -1),1);
    
    for i = 1 : sizeUpdated
        [r1] = find (connection(:,9) == -1);
        connection(r1(1),:) = [];
    end
    
    groupSize = groupSize + 1;
    for i = 1 : size(group,1)
        groupClusterTmp(i,1) = group(i,1);
        groupClusterTmp(i,2) = group(i,2);
        groupClusterTmp(i,3) = groupSize;
    end
    
    groupCluster = [groupCluster;groupClusterTmp];
end

end

