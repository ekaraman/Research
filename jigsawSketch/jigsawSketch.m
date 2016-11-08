function [D, S] = jigsawSketch (jSize, smoothCost, dataFeatCost, featDistThrs, dispVarThrs)

%clear all;

% Set image and log directories
date = datestr(now,30);
logFile = ['log_', date, '.txt'];
logDir = 'C:\Users\KARAMAN\Google Drive\RESEARCH\myResearch\jigsawLogs';

%Open log file
fileID = fopen([logDir,'\',logFile],'w');
fprintf(fileID,'%s\n',date);

%Sketch xml file is in this directory
%dataPath = 'C:\Users\KARAMAN\Google Drive\RESEARCH\myResearch\Research\jigsawSketch\testData';
dataPath = 'C:\Users\KARAMAN\Google Drive\RESEARCH\myResearch\Research\jigsawSketch\testData2';
%dataPath = 'C:\Users\KARAMAN\Google Drive\RESEARCH\myResearch\Research\jigsawSketch\testData3';
currentPath = pwd;
%Read stroke meta data from xml file
fileXml = [dataPath,'\*.xml'];
filedir = rdir(fileXml);
sketchXml = read_sketch(filedir(1,1).name);
[row, strokeSize] = size(sketchXml);
feat =zeros(strokeSize,720);

%Calculate idm features of each stroke 
for i = 1 : strokeSize
    feat(i,:)=idm(sketchXml(1,i),50,10,4);
end

featVectorSize =  size (feat,2);

%Set Jigsaw size
j1D = jSize;

%Initialize jMean
[ featMean, featStd, featVar, jMean ] = initJigsawMean( featVectorSize, feat, j1D );

%To allow elements of jigsaw unused, I keep the mean of idm features of 
%all strokes. If a jigsaw element is unused, I assign this value.
jMeanFirst = jMean;

%Get centers of strokes
centers = getCenters( strokeSize, sketchXml );

%Draw strokes on canvas
figNo = 1;
figNo = drawCanvas( sketchXml, centers, figNo );

%Get displacement between strokes
displacement = getDisplacement( strokeSize, centers );

%Find euclidean distance of IDM fetures of strokes
featDist = idmDistance(strokeSize, feat, featVectorSize);

%Set threshold for feature distance
tFeat = featDistThrs;
[row, col] = find(featDist <= tFeat & featDist >= 0);
simSize = size(row,1);

%Find displacement variance among similar strokes and set smooothness cost
%on grid.
groups = findSimStrokes( strokeSize, row, col, simSize, displacement, dispVarThrs );

%Update centers to enforce compatibility
updatedCenters = centers;
updatedDisplacement = displacement;
groupSize = size(groups,1);

%Define graph
graph = zeros(strokeSize,strokeSize);
circleGroup = [];

for i = 1 : groupSize
    
    %Get Positions
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
    
    %Get s4 position before update
    tmpX = updatedCenters(s4,1);
    tmpY = updatedCenters(s4,2);
    
    %Connect group elements
    %s1 ve s2yi burada birbirine ba�l�yorum ��nk� bunlarda connected
    %componnent hesaplerken g�z  �n�ne al�nmas� gerekiyor. Bunun nedeni 
    %s4'�n centerin� update ettikten sonra s4e ba�l� t�m connected
    %componnetleri ayn� displacement de�eri kadar kayd�r�yorum. E�er
    %bunlar� ba�lamazsam ve s1 ve s2den biri s4�n connected componenti ise
    %ve di�eri de�ilse connected component i�indeki node da displacement
    %kadar kayd�r�ld��� i�in s1,s2 ve s3,s4 displacement de�erinin e�itli�i
    %bozuluyor. Bu durumu �nlemek i�in ilk �nce burada ba�lant� i�ini
    %yap�yorum.
    graph(groups(i,1),groups(i,2)) = 1;
    graph(groups(i,2),groups(i,1)) = 1;
    %graphconncomp fonksiyonu sparse matrix kullan�yor.
    sgraph = sparse(graph);
    %Graphdaki connected componnetleri buluyorum.
    [S, C] = graphconncomp(sgraph);
    %s4�n connected komponentlerini buluyorum.
    compNu = C(s4);
    comps =  find(C==C(s4));
    %s3 connected komponentte var m�? Bu �ok �nemli. e�er varsa s3 �
    %hareket ettirmeden di�er component elemanlar�n�n hepsini kayd�rd���m
    %i�in s3 ile ba�l� olan nodelar�n displacement el�itlikleri bozuluyor.
    %E�er b�yle bir durum varsa displacement e�itli�ini sa�lamak m�mk�n
    %olmad���ndan bu benzer gruplar� dikkate elm�yorum. Yani ba�lam�yorum
    %birbirlerine.
    check1 = any (comps==s3);
    %Displacement de�erleri e�itmi ona bak�yorum. e�itse hi�bir�ey
    %yapm�yorum. E�it de�ilse merkez kayd�rma i�elemini yap�yorum.
    check2 = (disp1x == disp2x) && (disp1y == disp2y);
    
    %E�er s3 connected komponentte yoksa ve displacement de�erleri
    %farkl�ysa s4�n ve connected componentlerinin poziyon bilgilerini
    %displacement de�eri kadar update ediyorum.
    if ~((disp1x == disp2x) && (disp1y == disp2y)) && ~check1
        updatedCenters(s4,1) = updatedCenters(s3,1) + disp1x;
        updatedCenters(s4,2) = updatedCenters(s3,2) + disp1y;
        graph(groups(i,3),groups(i,4)) = 1;
        graph(groups(i,4),groups(i,3)) = 1;
        %Find delta of old and updated distance of s4
        deltaX = updatedCenters(s4,1) - tmpX;
        deltaY = updatedCenters(s4,2) - tmpY;
        for j = 1 : size(comps,2)
            if (comps(j) ~= s4)
                updatedCenters(comps(j),1) = updatedCenters(comps(j),1) + deltaX;
                updatedCenters(comps(j),2) = updatedCenters(comps(j),2) + deltaY;
            end
        end
    %E�er displacementlar e�itse bir�ey yapm�yorum, sadece s3 v s4�
    %ba�l�yorum. s1 ve s2yi yukar�da ba�lam��t�m zaten.
    elseif (disp1x == disp2x) && (disp1y == disp2y)
        graph(groups(i,3),groups(i,4)) = 1;
        graph(groups(i,4),groups(i,3)) = 1;
    end
    %E�er s3 ve s4 connected ise ba�lant�s�n� kesiyorum ve offset uygulama
    %i�lemi bittikten sonra bu sat�rdaki grouplar� ��karmak i�in sat�r
    %bilgilerini tutuyorum.
    if (check1) && ~(check2)
        graph(groups(i,1),groups(i,2)) = 0;
        graph(groups(i,2),groups(i,1)) = 0;
        circleGroup = [circleGroup i]; 
    end
    
    %Displacmentlar� update ediyorum.
    updatedDisplacement = getDisplacement( strokeSize, updatedCenters );
    
end

%s3 ve s4 ba�l� oldu�u i�in offset uygulayamad���m sat�rlar� siliyorum.
[groups,ps] = removerows(groups,'ind',circleGroup);
%Kontrol
flag = 0;
flag = checkUpdatedDisplacement(updatedDisplacement, groups);
if (flag == 1)
    disp('Cannot update displacement properly... Check the code...')
    return
end

%Set smoothCost
smthCost = smoothCost;
graph = graph * smthCost;

%Alpha expansion code uses sparse matrix
Sgrid = sparse(double(graph));

%Set Label offset matrix
labelSize = j1D * j1D;
offset = zeros(labelSize,2);

%set offset values for feat(1,1)
%Namely, finding offset values of assigning pixel(1,1) each jigsaw pixel.
%Offset degerler�n�n eks� olmas�n�n sebebi z=(s-label)mod|J|
%Label cikarildigi icin eksi olunca arti oluyor degeri.
index = 1; 
for i = 1 : j1D
    for j = 1 : j1D
        offset (index,1) = 1 - i;
        offset (index,2) = 1 - j;
        index = index + 1;
    end
end

%Initialize energy
E_old = 1;
E_new = 0;
em = 1;
flag = 1;

%Beginning of EM algorithm
while (flag)
    fprintf(fileID,'%s\n',['###############   EM iteration nu:   ',num2str(em),'    #################']);
    %Set data cost matrix
    fprintf(fileID,'%s\n','setting data cost matrix');
    dataCost = zeros (labelSize, strokeSize);
    for i = 1 : labelSize
        for j = 1 : strokeSize
            %Convert offset value to jigsaw index
            IX = updatedCenters(j,1);
            IY = updatedCenters(j,2);
            jX = mod ((IX - offset (i,1)),j1D);
            if (jX == 0) 
                jX = j1D;
            end
            jY = mod ((IY - offset (i,2)),j1D);
            if (jY == 0) 
                jY = j1D;
            end
            for k = 1 : featVectorSize   
                if (jX < 0 || jX > j1D || jY < 0 || jY > j1D)
                    fprintf(fileID,'%s\n','index error');
                end
                dataCost(i,j) = (feat(j,k) - jMean(jX,jY,k))^2 + dataCost(i,j);
            end
            dataCost(i,j) = int32(floor(dataCost(i,j)));
            dataCost(i,j) = int32(floor(dataCost(i,j))) * dataFeatCost;
        end
    end
    
    %Create graph cut handle
    fprintf(fileID,'%s\n','Create grap cut handle');
    h = GCO_Create(strokeSize,labelSize);
    
    %Set data cost matrix for alpha expansion graph cut
    fprintf(fileID,'%s\n','setting data cost matrix');
    GCO_SetDataCost(h,dataCost);
    
    %Setting Smoothcost
    %GCO_SetSmoothCost(h, smoothCost);
    
    %Setting Neighborhood relation
    fprintf(fileID,'%s\n','setting neighborhood relation matrix');
    GCO_SetNeighbors(h,Sgrid);
    
    %Start expanssion so as to assign labels
    fprintf(fileID,'%s\n','Expansion step begin');
    GCO_Expansion(h);
    %GCO_Swap(h);
    
    %Assign optimized label values for each pixel to label matrix (16384x1)
    fprintf(fileID,'%s\n','Set labels');
    label = GCO_GetLabeling(h);
    %Get optimized energy
    fprintf(fileID,'%s\n','Get optimized energy');
    [E_new D S] = GCO_ComputeEnergy(h);
    fprintf(fileID,'%s\n','Energy computed.');
    fprintf(fileID,'%s\n',['Total Energy = ', num2str(E_new)]);
    fprintf(fileID,'%s\n',['Data Cost Energy = ', num2str(D)]);
    fprintf(fileID,'%s\n',['Smooth Cost Energy = ', num2str(S)]);
    
    %Check While loop terminate case
    if (em == 1)
        E_old = E_new;
        E_new = 0;
    else
        if (E_new < E_old)
            E_old = E_new;
        else
            flag = 0;
            fprintf(fileID,'%s\n','#################################');
            fprintf(fileID,'%s\n','##########    CONVERGED      ##########');
            fprintf(fileID,'%s\n',['#######  EM = ', num2str(em), '   ########']);
        end
    end
    
    %Update Jigsaw mean
    fprintf(fileID,'%s\n','Updating jMean and jVar');
    jigsawLabel = zeros (j1D,j1D);
    jigsawAssignedFeat = zeros (j1D,j1D,featVectorSize);
    for i = 1 : strokeSize
        %Convert 1D pixel to image 2D index
        IX = updatedCenters(i,1);
        IY = updatedCenters(i,2);
        zX = mod((IX - offset(label(i),1)),j1D);
        if (zX == 0) 
            zX = j1D;
        end
        zY = mod((IY - offset(label(i),2)),j1D);
        if (zY == 0) 
            zY = j1D;
        end
        jigsawLabel(zX,zY) = jigsawLabel(zX,zY) + 1;
        for j = 1 : featVectorSize
            jigsawAssignedFeat(zX,zY,j) = jigsawAssignedFeat(zX,zY,j) + feat(i,j);
        end
    end
    
    %Update Jigsaw mean
    for i = 1 : j1D
        for j = 1 : j1D
            for k = 1 : featVectorSize
                if (jigsawLabel(i,j) > 0)
                    jMean(i,j,k) = ((jigsawAssignedFeat(i,j,k))) / (jigsawLabel(i,j));
                else
                    jMean(i,j,k) = jMeanFirst(i,j,k);
                    %jMean(i,j,k) = 0;
                end
            end
        end
    end
    
    fprintf(fileID,'%s\n','jMean is updated')
    
    fprintf(fileID,'%s\n',['###############   EM iteration nu:   ',num2str(em),'  finished #################']);
    
    em = em + 1;
    label
end

fprintf(fileID,'%s\n','Job completed, pls check reconstructed image.');
fclose(fileID);

%Draw strokes that are assigned to same label onto same figure
%figNo = drawLabels( label, j1D, figNo, sketchXml, centers );

%Draw jigsaw. Draw strokes that are assigned to jigsaw position.
cd(currentPath);
[figNo, jigsawPos] = drawJigsaw( figNo, strokeSize, updatedCenters, label, j1D, sketchXml, centers, offset );

%Reconstruction Phase
cd(currentPath);
[figNo, represent] = reconstruct( strokeSize, updatedCenters, label, offset, jMean, j1D, feat, featVectorSize, sketchXml, centers, figNo );

%Get summary of assigned labels and jigsaw positions
[ summaryMatrix, labelMatrix ] = getLabelandJigsawPos( groups, offset, label, jigsawPos, strokeSize, updatedCenters );

%Save all variables
save('jigsawsketch.mat');