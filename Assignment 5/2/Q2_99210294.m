clear all;
main
function main()
    %Part A
    image = im2double(imread("image2.tif"));% read image 
    noisyImage = addNoiseToImage(image);
    dftOfImage = fft2(concentrateSpectrum(noisyImage));% implementing discrete furier fransform on image
    spectrumOfImage = abs(dftOfImage);% spectrum of noisy image
    specImage = uint8(normalizeMatrix(log10(spectrumOfImage + 1) , 0 , 255));% normalized specrum of noisy image for easy saving

    subplot(231);
    imshow(image , []);
    title("Main Image")
    subplot(232);
    imshow(noisyImage , []);
    title("Noisy Image")
    subplot(233);
    imshow(specImage);
    title("Spectrum of Noisy Image")

    imwrite(specImage , "spectrumImage.tif")
    input("Please Edit The image 'spectrumImage.tif' manually and then press enter\n");
    
    %Part B
    editedSpectrumImage = double(imread("spectrumImage.tif"));
    editedSpectrum = 10 .^ normalizeMatrix(editedSpectrumImage , min(min(log10(spectrumOfImage+1))) , max(max(log10(spectrumOfImage+1))));% return values of spectrum to main range
    resultImage = concentrateSpectrum(ifft2(editedSpectrum .* exp(1i*angle(dftOfImage))));%mutiply phase of noisy image with edited spectrum

    subplot(246);
    imshow(editedSpectrumImage , []);
    title("Noise Removed Spectrum")

    subplot(247);
    imshow(real(resultImage) , []);
    title("Noise Removed Image")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% addNoiseToImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds periodic sine noise to image in spatial domain                         %%%
%%% input(s) : {image : given image}                                                          %%%  
%%% output(s) : {noisyImage : noisy image }                                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = addNoiseToImage(image)
    sinFilter = zeros(size(image));
    for x = 1:size(image,1)
        for y = 1:size(image,2)
            sinFilter(x,y) = (sin(5*x+6*y) + sin(7*x+8*y)) / 10;
        end
    end
    noisyImage = image + sinFilter;    
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
%%% This function scale matrix values to range [min , max]                                    %%%
%%% input(s) : {X : given matrix}                                                             %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X , minVal , maxVal)
    X = X - min(min(X));
    result = minVal + (maxVal-minVal)* X / max(max(X));
end