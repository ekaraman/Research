function [flag ] = checkConnection( i, j, k, m, connection )
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
    flag = 0;
    [r1] = find(connection(:,3) == i & connection(:,4) == j);
    [r2] = find(connection(:,3) == k & connection(:,4) == m);
    
    for x = 1 : size(r1)
        for y = 1 : size(r2)
            if ( connection(r1(x),1) == connection(r2(y),1) && connection(r1(x),2) == connection(r2(y),2))
                 flag = 1;
                 break
            end
        end
        if(flag==1)
          break
        end
    end
end

