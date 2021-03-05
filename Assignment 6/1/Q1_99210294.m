clear all;
close all;
main;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function is starting points of program and calls other functions                                                      %%%
%%% input(s) : {}                                                                                                              %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main()
    image = im2double(imread("apollo17.tif"));%read image
    radius = 120;%

    figure();
    noisyImageDft = partA(image, radius);%create noisy image
    bandRejectFilter = partB(image, radius , noisyImageDft);%filter with band reject filter
    figure();
    partC(noisyImageDft, bandRejectFilter);%extract noise pattern
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds periodic noise to image and shows it next to its spectrum                                               %%%
%%% input(s) : {image : original image , radius : radius of noise ring}                                                        %%%  
%%% output(s) : {noisyImageDft : discrete furier transform of noisy image}                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImageDft = partA(image , radius)
    p = [0 ; pi/ 4 ; 2*pi/4 ; 3*pi/4 ; pi];%some degrees we want to apply noise on points of circle that have this degrees
    noisePoints = [radius * cos(p) radius * sin(p)];% calculate x and y of noise impulses

    [noiseSpatial , noiseSpectrum] = getPeriodicNoiseFunction(size(image,1),size(image,2),noisePoints);%get periodic noise with spikes on given points in the furier transform

    noisyImage = image + noiseSpatial;%create noisy image

    noisyImageDft = fft2(concentrateSpectrum(noisyImage));
    noisyImageDftLog = log10(noisyImageDft + 1);
    noiseBosstedSpectrum = normalizeMatrix(imboxfilt(noiseSpectrum,5), min(min(noisyImageDftLog)),max(max(noisyImageDftLog))); % bold noise points in the frequency domain

    subplot(231);
    imshow(image, []);%show main image
    title("the original image");
    subplot(234);
    imshow(noisyImage, []);%show noisy image
    title("the noisy image");
    subplot(232);
    imshow(abs(noisyImageDftLog) , [])%show spectrum of noisy image
    title("the spectrum of noisy image");
    subplot(235);
    imshow (abs(noisyImageDftLog + noiseBosstedSpectrum) , []);%show spectrum of noisy image with boosted noise
    title("the boosted spectrum of noisy image");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function filters noisy image with band reject filter and shows the filtered image                                         %%%
%%% input(s) : {image : original image , radius : radius of noise ring , noisyImageDft : discrete furier transform of noisy image} %%% 
%%% output(s) : {filter : designed band reject filter }                                                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filter = partB(image , radius , noisyImageDft)
    filter = getBandReject(size(image,1),size(image,2), radius , 10); % design band reject filter
    
    resultOfFiltering = concentrateSpectrum(ifft2(noisyImageDft .* filter));% apply filter in frequency domain
    
    subplot(233);
    imshow(filter , []);% show band reject filter
    title("the band reject filter");
    
    subplot(236);
    imshow(abs(resultOfFiltering), []);%show result of applying filter
    title("result of filtering");
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function extracts noise pattern with band pass filter and shows it                                                    %%%
%%% input(s) : {noisyImageDft : discrete furier transform of noisy image , bandRejectFilter : designed band reject filter }    %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function partC(noisyImageDft , bandRejectFilter)
    bandPassFilter = 1 - bandRejectFilter;
    noisePattern = concentrateSpectrum(ifft2(noisyImageDft .* bandPassFilter));% apply filter in frequency domain
    
    subplot(121);
    imshow(bandPassFilter, []);%show band pass filter
    title("the band pass filter");
    
    subplot(122);
    imshow(abs(noisePattern) , []);% show band reject filter
    title("noise pattern");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getBandReject %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates butterworth band reject filter                                                                                %%%
%%% input(s) : {M : height of the filter , N : width of the filter , D0 : radius of filter , W : width of ring of the filter}           %%%  
%%% output(s) : {bandReject : created filter}                                                                                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bandReject = getBandReject(M,N,D0,W)
    D = zeros(M,N);%distance of all pixels from center pixel
    for i = 1:M
        for j = 1:N
            D(i,j) = sqrt((i-M/2)^2+(j-N/2).^2);
        end
    end
    
    %generating filter accoding to its formula
    bandReject = 1 - exp(-((D .^ 2 - D0.^2) ./ (D.*W + eps)).^2);%eps = we use epsion to prevent "divide by zero" error
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getPeriodicNoiseFunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates symmetric impulses in the furier spectrum and returns corresponding noise in frequency and spatial domain     %%%
%%% input(s) : {M : height of the plane , N : width of the plane , points : points of impulses realative to center of the plane}        %%%  
%%% output(s) : {noiseSpatial : noise in spatial domain , noiseSpectrum : spectrum of noise in furier domain}                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ noiseSpatial , noiseSpectrum ] = getPeriodicNoiseFunction(M , N , points)
    noiseSpectrum = zeros(M,N);% create matrix with given size
    for j = 1:size(points,1)% for each points do : 
        u1 = floor(M/2) + 1 - floor(points(j,1)); % calcuclate absolute x value of point in the plane
        v1 = floor(N/2) + 1 - floor(points(j,2)); % calcuclate absolute y value of point in the plane

        noiseSpectrum(u1,v1) = M*N/10;% create impulse in the given point
        
        u2 = floor(M/2) + 1 + floor(points(j,1));% calcuclate absolute x value of corresponding symmetric point in the plane
        v2 = floor(N/2) + 1 + floor(points(j,2));% calcuclate absolute y value of corresponding symmetric point in the plane

        noiseSpectrum(u2,v2) = M*N/10;% create impulse in the corresponding symmetric point

    end
    
    noiseSpatial = real(ifft2(ifftshift(noiseSpectrum)));%transfer the impulses to spatial domain
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
%%% This function scale matrix values to range [minVal maxVal]                                %%%
%%% input(s) : {X : given matrix , minVal : start of range , maxVal : end of range}           %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X , minVal , maxVal)
    X = X - min(min(X));
    result = minVal + (maxVal-minVal)* X / max(max(X));
end