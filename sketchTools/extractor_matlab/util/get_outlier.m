function dist = get_outlier(coords)

    centroid = get_centroid(coords);   
    
    if length(centroid) == 1
        %rep1 = repmat(centroid, 1, length(coords))
        diff = coords - repmat(centroid,1,length(coords));
        
    else
        %rep2 = repmat(centroid, length(coords), 1)
        diff = coords - repmat(centroid, length(coords), 1);
        
    end
%     coords
%     centroid
%     length(coords)
    
    dist= max(sqrt(sum(diff.*diff,2)));
    
end