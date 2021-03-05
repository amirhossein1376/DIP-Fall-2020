clear all;

imgRead = imread('img1.jpg');
imgGrayScale = rgb2gray(imgRead);
mainFig = figure(1);set(mainFig , 'visible' , 'off');
imshow(imgGrayScale);

dpi = int2str(input('Please Enter Dpi value : '));
print('-f1',strcat('temporary_processedImage' , dpi),'-djpeg' , strcat('-r' , dpi));

processedImgName = strcat('temporary_processedImage' , dpi , '.jpg');
processedImgRead = imread(processedImgName);
processedImgGrayScale = rgb2gray(processedImgRead);

delete(processedImgName);

figure(2);

subplot(121)
imshow(imgGrayScale);
title('Main Image');

subplot(122)
imshow(processedImgGrayScale);
title(strcat(dpi , ' DPI'));