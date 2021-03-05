%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% createNoisyImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds salt and papper noise with given percentage to given image             %%%
%%% input(s) : {inputImage : given image, perc : percentage of noise}                         %%%  
%%% output(s) : {noisyImage : noisyImage}                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = createNoisyImage(inputImage,perc)
    noisyImage = uint8(inputImage);% convert image to 8-bit unsigned int image
    height = size(inputImage,1);% image height
    width = size(inputImage,2);% image width
    count = int32(height * width * perc);% number of pixels that we want to change
    
    %generate random points for adding noise to them
    x = int32(randi([1,height], [1, count]));% 'count' points between 1 and height
    y = int32(randi([1,width], [1, count]));% 'count' points between 1 and width
    for i = 1:count
        Xi = x(1,i);% x of i'th point for adding noise
        Yi = y(1,i);% y of i'th point for adding noise
        noiseValue = uint8(randi([0, 1], [1, 1])) * 255;% noise value (0 or 255)
        noisyImage(Xi,Yi) = noiseValue;% change image (i,j) gray level to noise value
    end
end