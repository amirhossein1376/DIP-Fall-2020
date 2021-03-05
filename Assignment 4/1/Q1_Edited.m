main

function main()
    % part a , b
    image = imread("image.tif");
    [resultImage1 ,resizedImage1] = sizeResuctionAndInterpolation(image);
    
    % Part c , d
    bluredImage = applyFilterOnImage(image, ones(3,3)/9);%blur image before size reduction
    [resultImage2 ,resizedImage2] = sizeResuctionAndInterpolation(bluredImage);
    
    subplot(231);
    imshow(image);
    title("input image")

    subplot(232);
    imshow(resultImage1);
    title("result Of size reduction")

    subplot(233);
    imshow(resizedImage1 , []);
    title("result Of interpolation")

    subplot(234);
    imshow(bluredImage);
    title("blured image")
    
    subplot(235);
    imshow(resultImage2);
    title("result Of size reduction")

    subplot(236);
    imshow(resizedImage2 , []);
    title("result Of interpolation")

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sizeResuctionAndInterpolation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function reduce size of image by row and column deletion and also interpolate reduced image    %%%
%%% input(s) : {inputImage : given image}                                                               %%%  
%%% output(s) : {outputImage : result of size reduction , resizedImageRow : interpolated image}         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputImage ,resizedImageRow] = sizeResuctionAndInterpolation(inputImage)
    imageHeight = size(inputImage ,1);% height of image
    imageWidth = size(inputImage ,2);% width of image
    
    % part a
    allRows = 1:imageHeight;
    allColumns = 1:imageWidth;
    selectedRows = floor(1:sqrt(2):imageHeight);% select retaining rows
    selectedColumns =  floor(1:sqrt(2):imageWidth);% select retaining columns

    outputImage = inputImage;
    outputImage(setdiff(allRows , selectedRows), :) = [];
    outputImage(:, setdiff(allColumns , selectedColumns)) = [];
    
    resizedImageRow = bilinearInterpolation(double(outputImage) , size(inputImage));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% bilinearInterpolation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calcualtes linear interpolation of image                                              %%%
%%% input(s) : {inputImage : given image , outputImageSize : size of output image}                      %%%  
%%% output(s) : {outputImage : result of interpolation}                                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outputImage = bilinearInterpolation(inputImage , outputImageSize)
    outputImage = uint8(zeros(outputImageSize));
    mI = size(inputImage, 1);
    nI = size(inputImage, 2);
    mO = size(outputImage, 1);
    nO = size(outputImage, 2);
    for i = 1:mO
        for j = 1:nO
            x = i / mO * mI;
            y = j / nO * nI;
            cx = ceil(x);
            fx = max(floor(x) , 1);
            cy = ceil(y);
            fy = max(floor(y) , 1);
            
            A = [fx,fy,fx*fy,1;fx,cy,fx*cy,1;cx,fy,cx*fy,1;cx,cy,cx*cy,1];
            B = [inputImage(fx , fy);inputImage(fx , cy);inputImage(cx , fy);inputImage(cx , cy)];
            v = pinv(A)*B;            
            outputImage(i,j) = v(1) * x + v(2) * y + v(3) * x * y + v(4);
        end
    end
end