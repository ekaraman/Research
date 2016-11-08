function convertToCSV( groups, displacement )
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
%   Jigsaw_161109.pptx sunumu slide 8'deki tabloyu elde eder.
%   Patternlerin displacment ve varyans degerlerini verir.
    mymatrix = zeros(size(groups,1),12);
    for i = 1 : size(groups,1)
        mymatrix(i,1)=i;
        mymatrix(i,2)=groups(i,1);
        mymatrix(i,3)=groups(i,2);
        mymatrix(i,4)=displacement(groups(i,1),groups(i,2),1);
        mymatrix(i,5)=displacement(groups(i,1),groups(i,2),2);
        mymatrix(i,6)=groups(i,3);
        mymatrix(i,7)=groups(i,4);
        mymatrix(i,8)=displacement(groups(i,3),groups(i,4),1);
        mymatrix(i,9)=displacement(groups(i,3),groups(i,4),2);
        disp1 = displacement(groups(i,1),groups(i,2),:);
        disp2 = displacement(groups(i,3),groups(i,4),:);
        tmpVar = var([disp1; disp2]);
        meanTmpVar = sum(tmpVar,3)/2;
        mymatrix(i,10)=tmpVar(1);
        mymatrix(i,11)=tmpVar(2);
        mymatrix(i,12)=meanTmpVar;
    end
    csvwrite('mymatrix.csv',mymatrix);
end

