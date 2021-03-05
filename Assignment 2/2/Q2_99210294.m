clear all;
main();

function main
    %read image
    imgRead = imread("Fig03164.tif");
    imgHeight = size(imgRead , 1);
    imgWidth = size(imgRead , 2);

    %my own histogram equalization
    imgResult = histogramEqualization(imgRead);

    %matlab histogram equalization
    imgMatlabHistogramEqualiztion = histeq(imgRead);

    %calcualte differences
    imgDifference = uint8(imabsdiff(imgResult,imgMatlabHistogramEqualiztion));

    %show results
    figure();

    subplot(2, 2 ,1);
    imshow(imgRead);
    title('Main Image');

    subplot(2, 2, 2);
    imshow(imgResult);
    title('My Hist. Equ.');

    subplot(2, 2 ,3);
    imshow(imgMatlabHistogramEqualiztion);
    title('Matlab Hist. Equ.');

    subplot(2, 2 ,4);
    imshow(imgDifference);
    title({"Difference",strcat("Total : " , int2str(sum(sum(imgDifference))),strcat(" , Mean : " , int2str(sum(sum(imgDifference))/ imgWidth / imgHeight)))});
end