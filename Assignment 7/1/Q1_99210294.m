clear all;
close all;

rgbImage = imread("strawberries.tif");% read rgb image    

D1 = input("Please enter parameter 'D1' : ");%input D1
D2 = input("Please enter parameter 'D2' : ");%input D2

safeColorRGB = partA(rgbImage);%convert to safe color
partB(rgbImage , safeColorRGB , D1 , D2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function converts colors of given image to safe colors                                                                %%%
%%% input(s) : {rgbImage : given rgb image}                                                                                    %%%  
%%% output(s) : {safeColorRGB : rgb image with safe colors}                                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function safeColorRGB = partA(rgbImage)
    safeColorRGB = floor(rgbImage ./ 51) .* 51; %find correponding safe colors for each pixel on each plate
    
    figure;
    subplot(241);
    imshow(rgbImage , []);%show image with safe colors    
    title("The original image")
    subplot(242);
    imshow(safeColorRGB , []);%show image with safe colors
    title("The safe color image")
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function find regions and show them                                                                                   %%%
%%% input(s) : {mainImaeg : orignial image , safeColorImage : image with safe colors , D1 , D2}                                %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function partB(mainImage , safeColorImage , D1 , D2)
    colorFrequency = getColorFrequency(safeColorImage);% find how many times each color apeared in the image
    dominatingColor = findDominatingColor(colorFrequency);% find color that apeard in the image more than other colors

    [regionMap , regionColors] = findRegions(safeColorImage , dominatingColor ,D1 , D2);%find regions
    defaultColors = [46 150 93;72 187 209;237 177 1;226 28 28];%deafult colors for displaying regions
    showRegions(mainImage , regionMap , regionColors , defaultColors);%display regions
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getColorFrequency %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function caculates how many times each gray level apeared in the image                                                %%%
%%% input(s) : {safeColorImage : imag that pixels color are from safe colors}                                                  %%%  
%%% output(s) : {colorFreq : 256*1 array that each element show how many times corresponding gray level apeared in the image}  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function colorFreq = getColorFrequency(safeColorImage)
    colorFreq = zeros(6,6,6);
    for i = 1:size(safeColorImage,1)
        for j = 1:size(safeColorImage,2)
            color = safeColorImage(i,j,:);
            rgb = floor(color(: , : , :)/51);
            r = rgb(1);g = rgb(2);b = rgb(3);
            colorFreq(r+1,g+1,b+1) = colorFreq(r+1,g+1,b+1) + 1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% findDominatingColor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function finds color that is dominated acoording to color frequencies calcualted                                      %%%
%%% input(s) : {colorFreq : color frequncies}                                                                                  %%%  
%%% output(s) : {dominatingColor : 3*1 array , contains r , g , b value of dominating color}                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dominatingColor = findDominatingColor(colorFreq)
    [~,idx] = max(colorFreq(:));%find max index in color frequencies
    [i,j,k] = ind2sub(size(colorFreq),idx);% find index of max value
    dominatingColor = [i*51-51;j*51-51;k*51-51];%convert to 3*1 matrix
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% findRegions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates regions according to question                                                             %%%
%%% input(s) : {image : safe color image , givenColor : dominating color , D1 , D2 }                                   %%%  
%%% output(s) : {regionMap : a map(pixel -> region) , regionColors : most domintaing color in each region}             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [regionMap , regionColors] = findRegions(image , givenColor ,D1 , D2)
    regionMap = ones(size(image,1) , size(image,2)) .* 4; % set 4 as default region of each pixel
    regionColors = zeros(4,3);
    regionColors(1,:) = givenColor;%set dominating color of first region
    
    %Region 1
    for i = 1:size(image,1)
        for j = 1:size(image,2)
            currentColor = reshape(image(i,j,:) , [3,1]);%convert color of current pixel to 3*1 vector
            if min(currentColor == givenColor) == 1 %check if currentColor == givenColor
                regionMap(i,j) = 1;
            end
        end
    end

    %Region 2 & 3
    distances = [0 ; D1 ; D2 ; 0];%distances used as measurement criteria in each region
    for currentRegion = 2:3
        colors = zeros(6,6,6);
        for i = 1:size(image,1)
            for j = 1:size(image,2)
                if regionMap(i,j) == 4 % if this pixel not assigned to any region
                    currentColor = reshape(image(i,j,:) , [3,1]);%convert color of current pixel to 3*1 vector
                    lastRegionColor = reshape(regionColors(currentRegion-1,:) , [3,1]);%find previous region color
                    if distance(currentColor , lastRegionColor) < distances(currentRegion) %check if this pixel is in the current region
                        regionMap(i,j) = currentRegion;%initialize region of current pixel
                        
                        %find how many times each color appeared in the region
                        rgb = floor(currentColor./51);
                        r = rgb(1);g = rgb(2);b = rgb(3);
                        colors(r+1,g+1,b+1) = colors(r+1,g+1,b+1) + 1;
                    end
                end
            end
        end
        %set color of region as dominatng color in the region
        [~,idx] = max(colors(:));
        [i,j,k] = ind2sub(size(colors),idx);
        regionColors(currentRegion,:) = [i*51-51;j*51-51;k*51-51];
    end
    
    %Region 4
    colors = zeros(6,6,6);
    for i = 1:size(image,1)
        for j = 1:size(image,2)
            if regionMap(i,j) == 4 % if this pixel not assigned to any region
                currentColor = reshape(image(i,j,:) , [3,1]);%convert color of current pixel to 3*1 vector

                %find how many times each color appeared in the region
                rgb = floor(currentColor./51);
                r = rgb(1);g = rgb(2);b = rgb(3);
                colors(r+1,g+1,b+1) = colors(r+1,g+1,b+1) + 1;
            end
        end
    end
    
    %set color of region as dominatng color in the region
    [~,idx] = max(colors(:));
    [i,j,k] = ind2sub(size(colors),idx);
    regionColors(4,:) = [i*51-51;j*51-51;k*51-51];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% showRegions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function displays regions with different colors                                                               %%%
%%% input(s) : {inputImage : the original image , regionMap : (pixel -> region) , regionColors : most dominated        %%% 
%%%  color in each region , defaultColors : default color to use as color of those region}                             %%%  
%%% output(s) : {}                                                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showRegions(inputImage , regionMap , regionColors , defaultColors)
    image = uint8(zeros(size(inputImage)));%image that each region shown in its dominating color value
    region1 = inputImage;%image of first region
    region2 = inputImage;%image of second region
    region3 = inputImage;%image of third region
    region4 = inputImage;%image of fourth region
    regionsTogether = inputImage;%image that each region shown in its prefered color value
    
    for i = 1:size(image,1)
        for j = 1:size(image,2)
            curerntRegion = regionMap(i,j);% region of current pixel
            image(i,j,:) = regionColors(curerntRegion,:);
            regionsTogether(i,j,:) = defaultColors(curerntRegion,:);
            if curerntRegion == 1
                region1(i,j,:) = defaultColors(1,:)';
            elseif curerntRegion == 2
                region2(i,j,:) = defaultColors(2,:)';
            elseif curerntRegion == 3
                region3(i,j,:) = defaultColors(3,:)';
            elseif curerntRegion == 4
                region4(i,j,:) = defaultColors(4,:)';
            end
        end
    end
    subplot(243);
    imshow(region1);
    title("Region 1");
    subplot(244);
    imshow(region2);
    title("Region 2");
    subplot(245);
    imshow(region3);
    title("Region 3");
    subplot(246);
    imshow(region4);
    title("Region 4");
    subplot(247);
    imshow(regionsTogether);
    title("Regions Together");
    subplot(248);
    imshow(image);
    title("Segmented Image");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates Euclidian distance between two points                                                     %%%
%%% input(s) : {point1 : first point , point2 : second points}                                                         %%% 
%%% output(s) : {dist : distance of this two points}                                                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dist = distance(point1 , point2)
    point1 = double(point1);
    point2 = double(point2);
    dist = sqrt(sum(sum( (point1 - point2).^2 )));
end