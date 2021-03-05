%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% localEqualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function move on the image and calculates local equalization         %%%       
%%% input(s) : {inputImage : given image, padding : half of given window size}%%%  
%%% output(s) : {myOutputImage : result of using my hist equalization         %%%
%%%            , matlabOutputImage : result of using matlab's equalization}   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [myOutputImage , matlabOutputImage]= localEqualization(inputImage , padding)
    
    addpath("../Q2_99210294/"); %adding my own equalization
    
    imageHeight = size(inputImage , 1);
    imageWidth = size(inputImage , 2);
    
    %do zero padding on image
    zeroPadImage = uint8(zeros(size(inputImage , 1) + 2 * padding , size(inputImage , 2) + 2 * padding));
    zeroPadImage(padding + 1:imageHeight + padding, padding + 1:imageWidth+ padding) = inputImage;

    myPaddedResult = uint8(zeros(size(zeroPadImage))); % variable for save padded result of computation with my equalization
    matlabPaddedResult = uint8(zeros(size(zeroPadImage))); % variable for save padded result of computation with matlab equalization 

    for i = padding + 1:imageHeight + padding
        for j = padding +1:imageWidth + padding
            currentSquare = zeroPadImage(i-padding:i+padding , j-padding:j+padding);
            mylocalResult = histogramEqualization(currentSquare);
            matlablocalResult = histeq(currentSquare);
            myPaddedResult(i,j) = mylocalResult(padding , padding); % set value for center of local square
            matlabPaddedResult(i ,j) = matlablocalResult(padding , padding); % set value for center of local square
        end
    end

    myOutputImage = myPaddedResult(padding + 1 : imageHeight + padding , padding + 1 : imageWidth + padding); % remove zero pads from input image
    matlabOutputImage = matlabPaddedResult(padding + 1 : imageHeight + padding , padding + 1 : imageWidth + padding);% remove zero pads from input image
end