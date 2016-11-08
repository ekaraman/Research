function [ flag ] = checkUpdatedDisplacement( updatedDisplacement, groups )
%UNTÝTLED11 Summary of this function goes here
%   Detailed explanation goes here
    flag = 0;
    for i=1 : size(groups,1)
        s1 = groups(i,1);
        s2 = groups(i,2);
        s3 = groups(i,3);
        s4 = groups(i,4);
        
        %Find displacement (x and y) between s1 and s2
        disp1x = updatedDisplacement(s1,s2,1);
        disp1y = updatedDisplacement(s1,s2,2);
    
        %Find displacement (x and y) between s3 and s4
        disp2x = updatedDisplacement(s3,s4,1);
        disp2y = updatedDisplacement(s3,s4,2);
        
        if ~((disp1x == disp2x) && (disp1y == disp2y))
            flag = 1;
            i
            s1
            s2
            s3
            s4
            %return;
        end
    end


end

