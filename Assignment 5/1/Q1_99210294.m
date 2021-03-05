clear all;
main;

function main()

    image = double(imread("image.tif"));% given image

    %filter params
    lambdaH = 2;
    lambdaL = 0.25;
    D0 = 80;
    c = 1;
    
    filter = homomorphicFilter(image , lambdaL , lambdaH , c , D0);% design filter

    %apply filter
    zeropaddedImage = zeropad(image);% zero pad image
    loggedImage = log(zeropaddedImage + 1);% get ln of image
    centeredImage = concentrateSpectrum(loggedImage);% concentrate spectrum in center by multipying image to (-1)^(x+y)
    fftImage = fft2(centeredImage);% dft of image

    applyResult =  fftImage .* filter;% apply filter on image 

    result = exp(concentrateSpectrum(ifft2(applyResult)))-1;% back to spatial domain
    result = result(1:size(image,1) , 1:size(image,2));% cut zero pads
    result = abs(result);% spectrum of result image

    figure;
    subplot(121);
    imshow(image , []);
    title("Main Image")
    subplot(122);
    imshow(result , []);
    title({"Result of Applying filter", strcat(" lambdaH  = ", num2str(lambdaH) , " , lambdaL = " , num2str(lambdaL))})
    saveas(gcf,'Barchart.png')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% homomorphicFilter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This designs a homomorphic filter according to eq.4-9-29 of text book                               %%%
%%% input(s) : {image : given image , lambdaL;lambdaH;c;D0 : parameters of homomorphic filter}          %%%  
%%% output(s) : {filter : a homomorphic filter}                                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filter = homomorphicFilter(image , lambdaL , lambdaH  , c , D0)
    filter = zeros(2 * size(image));
    M = size(filter ,1);
    N = size(filter ,2);
    D = zeros(2 * size(image));% distance of pixels from center
    for i = 1:M
        for j = 1:N
            D(i,j) = sqrt((i-M/2)^2+(j-N/2).^2);
        end
    end
    filter = (lambdaH - lambdaL) * (1 - exp(-c * (D .^2 ./ D0.^2))) + lambdaL;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% zeropad %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function add zero padding to given image                                             %%%
%%% input(s) : {inputImage : given image}                                                     %%%  
%%% output(s) : {outputImage : zero padded image}                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outputImage = zeropad(inputImage)
    imageHeight = size(inputImage ,1);
    imageWidth = size(inputImage ,2);
    outputImage = zeros(2 * size(inputImage));
    outputImage(1:imageHeight,1:imageWidth) = inputImage;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% concentrateSpectrum %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function mutiplies image to -1^(x+y)                                                 %%%
%%% input(s) : {inputImage : given image}                                                     %%%  
%%% output(s) : {resultImage : result of multiplication}                                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultImage = concentrateSpectrum(inputImage)
    resultImage = inputImage;
    for i = 1:size(resultImage,1)
        for j =1:size(resultImage,2)
            resultImage(i,j) = resultImage(i,j) * (-1)^(i+j);
        end
    end
end