function [ featMean, featStd, featVar, jMean ] = initJigsawMean( featVectorSize, feat, j1D )
%This function initialize jigsaw matrix elements to a random value from
%a Normal distribution.

    %Initialize jigsaw mean
    jSize = [j1D, j1D, featVectorSize];  
    jMean = zeros(jSize) - 1;
    featMean = zeros (1,featVectorSize);
    featStd = zeros (1,featVectorSize);
    featVar = zeros (1,featVectorSize);

    for i = 1 : featVectorSize
        featMean (1,i) = mean2(feat(:,i));
        featStd (1,i) = std2 (feat(:,i));
        featVar (1,i)= featStd (1,i) ^ 2;
    end

    for i =  1 : j1D
        for j =  1 : j1D
            for k = 1 : featVectorSize
                done = false;
                while (~done)
                    jMean(i,j,k) = random('norm', featMean(1,k), featStd(1,k));
                    if (jMean(i,j,k) >= 0)
                        done = true;
                    end
                end
            end
        end
    end
end