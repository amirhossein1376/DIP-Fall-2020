clear all;
close all;

image = double(imread("sti.tif"));% read image
resizedImage = partA(im2double(image));%resize image
[dctMatrix , fftMatrix] = partB(resizedImage);% calculate dct and fft of sub images
mask = partC();%get binary mask
maskedDct = partD(dctMatrix, mask);%multiply mask to DCT coefficients
reconstructedDCT = partE(maskedDct);%reconstruct image from dct coefficients
reconstructedFFT = partF(fftMatrix, mask);%reconstruct image from dft coefficients

dctDiff =  imabsdiff(image,reconstructedDCT);%difference of original image and dct reconstructed image
fftDiff =  imabsdiff(image,reconstructedFFT);%difference of original image and fft reconstructed image

dctMSE = RMSE(image,reconstructedDCT);%mean squared error of original image and dct reconstructed image
fftMSE = RMSE(image,reconstructedFFT);%mean squared error of original image and fft reconstructed image


figure();
subplot(131);
imshow(image , []);
title("The original image")

subplot(232);
imshow(reconstructedDCT, []);
title("DCT compressed")

subplot(233);
imshow(reconstructedFFT, []);
title("FFT compressed")

subplot(235);
imshow(dctDiff, []);
title(['MSE: ', num2str(dctMSE)])

subplot(236);
imshow(fftDiff, []);
title(['MSE: ', num2str(fftMSE)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function resizes image to have dividible to 8 by 8 blocks                                                             %%%
%%% input(s) : {image : given grayscale image}                                                                                 %%%  
%%% output(s) : {resizedImage : resized image}                                                                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resizedImage = partA(image)
    imageNewSize = ceil(size(image , 1:2) ./ 8) .* 8; % round number of rows and columns to nearest greater multiplication of 8
    resizedImage = imresize(image , imageNewSize , 'bilinear'); % resize image to new height and width
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function applies dct and fft on each sub image                                                                        %%%
%%% input(s) : {image : given grayscale image}                                                                                 %%%  
%%% output(s) : {dctMatrix : result of dct transformation , fftMatrix : result of applying fft}                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dctMatrix , fftMatrix] = partB(image)
    fftMatrix = zeros(size(image));%result holder for fft 
    dctMatrix = zeros(size(image));%result holder for dct
    for i = 1:size(image,1)/8 
        for j = 1:size(image,2)/8
            iRange = 8*i-7:8*i;
            jRange = 8*j-7:8*j;
            currentBlock = image(iRange,jRange); % current 8 by 8 block
            fftMatrix(iRange,jRange) = fft2(currentBlock);% calculate fft of current block
            dctMatrix(iRange,jRange) = dct2(currentBlock);% calculate dct of current block
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function generates binary mask as shown in Fig. 8.29(a)                                                               %%%
%%% input(s) : {}                                                                                                              %%%  
%%% output(s) : {mask : generated mask}                                                                                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mask = partC()
    [y , x] = meshgrid(1:8,1:8);
    mask = ones(8,8);
    mask(x + y > 6) = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function multiplies dct coefficients matrix to generated mask                                                         %%%
%%% input(s) : {dctMatrix : dct coefficients , ,mask : generated mask}                                                         %%%  
%%% output(s) : {maskedDct : result of multiplication}                                                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function maskedDct = partD(dctMatrix, mask)
    globalMask = repmat(mask , size(dctMatrix) ./ 8); % reapeat mask to its size be identical to image
    maskedDct = globalMask .* dctMatrix;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function reconstructs image from 15 dct coefficients in every 8 by 8 matrix                                           %%%
%%% input(s) : {maskedDct : compressed dct coefficients}                                                                       %%%  
%%% output(s) : {reconstructedDCT : reconstructed image}                                                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function reconstructedDCT = partE(maskedDct)
    reconstructedDCT = zeros(size(maskedDct));%result holder for inverse dct
    for i = 1:size(maskedDct,1)/8 
        for j = 1:size(maskedDct,2)/8
            iRange = 8*i-7:8*i;
            jRange = 8*j-7:8*j;
            currentBlock = maskedDct(iRange,jRange);% currnt 8 by 8 block
            reconstructedDCT(iRange,jRange) = idct2(currentBlock);% calculate inverse dct of current block
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function compresses fft by multiplying it to mask and then reconstructs image from compresses dft                     %%%
%%% input(s) : {fftMatrix : dft of image , mask : generated mask}                                                              %%%  
%%% output(s) : {reconstructedFFT : reconstructed image}                                                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function reconstructedFFT = partF(fftMatrix , mask)
    globalMask = repmat(mask , size(fftMatrix) ./ 8);
    maskedFFT = globalMask .* fftMatrix;
    reconstructedFFT = zeros(size(maskedFFT));
    for i = 1:size(maskedFFT,1)/8 
        for j = 1:size(maskedFFT,2)/8
            iRange = 8*i-7:8*i;
            jRange = 8*j-7:8*j;
            currentBlock = maskedFFT(iRange,jRange);% currnt 8 by 8 block
            reconstructedFFT(iRange,jRange) = abs(ifft2(currentBlock));% calculate inverse fft of current block
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates mean squared error of reconstructed image                                                         %%%
%%% input(s) : {image1 : original image , image2 : reconstructed image}                                                        %%%  
%%% output(s) : {MSE : calcualted mean squared error}                                                                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RMSE = RMSE(image1, image2)
    image1 = double(image1);
    image2 = double(image2);
    [M, N] = size(image1);
    error = image1 - image2;
    RMSE = sqrt(sum(sum(error .^2)) / (M * N));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalizeMatrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function scale matrix values to range [0 255]                                        %%%
%%% input(s) : {X : given matrix}                                                             %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X , minVal , maxVal)
    if nargin<2
      minVal = 0;
      maxVal = 255;
    end
    X = X - min(min(X));
    result = minVal + (maxVal-minVal)* X / max(max(X));
end



