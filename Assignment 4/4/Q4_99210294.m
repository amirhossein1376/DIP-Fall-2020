clear all;
main();
function main()
    mainImage = imread("f0441.tif");% main image
    mainZeropadImage = concentrateSpectrum(zeropad(mainImage));% zero padded and centered image
    mainImageFFT = fft2(mainZeropadImage);% fft of image
    powerSpectrum = abs(mainImageFFT).^2;% power spectrum of image
    powerSpectrumSum = sum(sum(powerSpectrum));% sum of all power spectrums of all pixels

    M = size(mainZeropadImage,1);% height of padded image
    N = size(mainZeropadImage,2);% width of padded image

    D = zeros(size(mainZeropadImage));%distance of all pixels from center pixel
    for i = 1:M
        for j = 1:N
            D(i,j) = sqrt((i-M/2)^2+(j-N/2).^2);
        end
    end

    retains = [0.8,0.9,0.95];% values of retain given in the question
    for p = 1:length(retains)
        retain = retains(p);% the percent of spectrum we want to retain

        D0 = 0;%variable for saving D0 after filding it
        for DL = 1:min(M/2 , N/2) % find D0 according to page 270 of text book
            if sum(sum(powerSpectrum(D <= DL)))/powerSpectrumSum <= retain
                D0 = DL;
                continue
            end
            break;
        end

        [ideal , gaussian , butterworth] = filters(size(mainZeropadImage), D0 , 2);
        idealFilterResult = concentrateSpectrum(real(ifft2(ideal .* mainImageFFT)));% result of applying ideal filter
        gaussianFilterResult = concentrateSpectrum(real(ifft2(gaussian .* mainImageFFT)));% result of applying gaussian filter
        butterworthFilterResult = concentrateSpectrum(real(ifft2(butterworth .* mainImageFFT)));% result of applying butterworth filter

        idealFilterResult = idealFilterResult(1:size(mainImage,1) , 1:size(mainImage,2));% remove zero pads of ideal filter
        gaussianFilterResult = gaussianFilterResult(1:size(mainImage,1) , 1:size(mainImage,2));% remove zero pads of gaussian filter
        butterworthFilterResult = butterworthFilterResult(1:size(mainImage,1) , 1:size(mainImage,2));% remove zero pads of butterworth filter


        figure('Name' , strcat('D0 : ' , int2str(D0) , ' order : ' , int2str(1)));

        subplot(332);
        imshow(mainImage);
        title("main image")
        subplot(334);
        imshow(idealFilterResult , []);
        title("ideal filter")
        subplot(335);
        imshow(gaussianFilterResult , []);
        title("gaussian filter")
        subplot(336);
        imshow(butterworthFilterResult , []);
        title("butterworth filter")

        subplot(337);
        imshow(imabsdiff(double(mainImage),idealFilterResult) , []);
        title("ideal difference")
        subplot(338);
        imshow(imabsdiff(double(mainImage),gaussianFilterResult) , []);
        title("gaussian difference")
        subplot(339);
        imshow(imabsdiff(double(mainImage),butterworthFilterResult) , []);
        title("butterworth difference")

    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% filters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% In this function I design filters                                                         %%%
%%% input(s) : {filterSize : size of filter , D0 : cut off freq , order : order of B.W}       %%%  
%%% output(s) : {ideal : ideal filter , gaussian : gaussian filter , butterworth : B.W filter}%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ideal , gaussian , butterworth] = filters(filterSize , D0 , order)    
    M = filterSize(1);
    N = filterSize(2);
    D = zeros(filterSize);% distance of pixels from center
    for i = 1:M
        for j = 1:N
            D(i,j) = sqrt((i-M/2)^2+(j-N/2).^2);
        end
    end
    
    ideal = size(filterSize);% ideal filter
    for i = 1:M
        for j = 1:N
            if D(i,j) <= D0
                ideal(i,j) = 1;
            else
                ideal(i,j) = 0;
            end
        end
    end
    
    gaussian = exp(-D.^2./(2*D0).^2);% gaussian filter

    butterworth = ones(size(D)) ./ (1 + (D / D0).^ 2*order);% butterworth filter
    
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalizeMatrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function scale matrix values to range [0 255]                                        %%%
%%% input(s) : {X : given matrix}                                                             %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X)
    X = X - min(min(X));
    result = 255 * X / max(max(X));
end