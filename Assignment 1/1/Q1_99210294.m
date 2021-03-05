clear all;

imgRead = imread('img1.jpg'); % read image from file

imgGrayScale = rgb2gray(imgRead); % convert to grayscale version
mainFig = figure(1);set(mainFig , 'visible' , 'off'); % open figure in invisible mode
imshow(imgGrayScale);% add image to invisible figure

dpi = int2str(input('Please Enter Dpi value : '));% get dpi value from input
print('-f1',strcat('temporary_processedImage' , dpi),'-djpeg' , strcat('-r' , dpi));% print figure 1 to 'temporary_processedImage.jpg' temporary file with given dpi

tempImgName = strcat('temporary_processedImage' , dpi , '.jpg');% temporary image name
tempImg = rgb2gray(imread(processedImgName));% read temporary image
delete(tempImgName); % remove temporary file after reading

figure(2);% draw figure for showing images

%show main grayscale image
subplot(121)
imshow(imgGrayScale);
title('Main Image');

subplot(122)
imshow(processedImgGrayScale);
title(strcat(dpi , ' DPI'));