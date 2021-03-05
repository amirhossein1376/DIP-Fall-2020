clear all;
close all;
main();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function is starting points of program and calls other functions                                                      %%%
%%% input(s) : {}                                                                                                              %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main()
    image = im2double(imread("a.tif"));% read image
    D0 = 40;
    n = 3;
    noise_freq = [0.1 -150 -150;0.4 -150 150;0.3 -300 -150;0.2 -300 150];
    [noisyImage , filter] = partA(image , D0 , n , noise_freq);
    partB(noisyImage , filter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds serveral noise to image and designs a multiple notch filter                                             %%%
%%% input(s) : {image : original image , D0 : cutoff frequency , n : order of butterworth filter}                              %%%  
%%% output(s) : {noisyImage : image with noise , filter : generated butterworth mutiple notch filter}                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [noisyImage , filter] = partA(image , D0 , n , noise_freq)
    M = size(image , 1);% height of the image
    N = size(image , 2);% width of the image
    noisyImage = addNoiseToImage(image , noise_freq);%create noisy image
    
    imageDft = fft2(concentrateSpectrum(noisyImage));% discrete furier transform of noisy image
    spectrum = abs(imageDft);% spectrum of noisy image
    logSpectrum = uint8(normalizeMatrix(log(1 + spectrum) , 0 , 255));%get log from spectrum to display it simply
    
    [x , y] = getNoisePoints(M , N ,logSpectrum);%input noise points
    filter = getMutipleNotchFilter(M , N , x , y , D0 , n);%design multiple notch filter
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function removes all noises in one pass using mutiple notch filter                                                    %%%
%%% input(s) : {noisyImage : created noisy image , filter : butterworth mutiple notch filter}                                  %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function partB(noisyImage , filter)
    imageDft = fft2(concentrateSpectrum(noisyImage));% discrete furier transform of noisy image
    spectrum = abs(imageDft);% spectrum of noisy image
    logSpectrum = uint8(normalizeMatrix(log(1 + spectrum) , 0 , 255));%get log from spectrum to display it simply

    filteredSpec = imageDft  .* filter;% filter spectrum using given filter

    subplot(221);
    imshow(noisyImage , []);
    title("The noisy image")

    subplot(222);
    imshow(logSpectrum, []);
    title("Spectrum of the noisy image")

    subplot(223);
    imshow(uint8(normalizeMatrix(log(filteredSpec + 1) , 0 , 255)));
    title("Spectrum of the noisy image multiplied by notch filter")

    subplot(224);
    imshow(concentrateSpectrum(ifft2(filteredSpec)), []);
    title("Restored image")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getNoisePoints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function inputs x and y of each noise in the spectrum domain                                                           %%%
%%% input(s) : {M : height of the noise plane , N : width of the noise plane , logSpectrum : log of spectrum of the noisy image}%%%  
%%% output(s) : {x : verctor of y-value of points , y : verctor of y-value of points }                                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x , y] = getNoisePoints(M , N , logSpectrum)
    if isfile("xy.mat")%check if file of points exists
        flag = input("Do you want to design notch filters manually ? \n");
        if flag == 1% if user wants to select points :
            imshow (logSpectrum)%show spectrum
            [y , x] = getpts;%get points of noises on the image
            x = x - M/2;%calcualte x relative to center of plane
            y = y - N/2;%calcualte y relative to center of plane
            save("xy.mat" , 'x' , 'y')%save selected points for further use
            close all;
        else%if user dosen't want to select points himself
            load("xy.mat");
        end
    else% if not recent file of points exists:
        flag = input("Do you want to design notch filters manually ? \n");
        if flag == 1
            imshow (logSpectrum)
            [y , x] = getpts;
            x = x - M/2;
            y = y - N/2;
            save("xy.mat" , 'x' , 'y')
        end
    end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getMutipleNotchFilter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function generates notch filter according to equation 4-10-5 of text book                                                     %%%
%%% input(s) : {filterHieght : same as name! , filterWidth : same as name! ,                                                           %%%
%%% x : selected points x-value , y : selected points y-value , D0 : cut off freq. , n : order of butterworth}                         %%%  
%%% output(s) : {x : verctor of y-value of points , y : verctor of y-value of points }                                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filter = getMutipleNotchFilter(filterHeight , filterWidth , x , y , D0 , order)

    filter = ones(filterHeight , filterWidth);%create filter holder
    for k = 1:length(x)
        
        u = floor(x(k));
        v = floor(y(k));

        D1 = zeros(size(image));% distance of pixels from center
        D2 = zeros(size(image));% distance of pixels from center of symmetric point
        for i = 1:filterHeight
            for j = 1:filterWidth
                D1(i,j) = sqrt((i- filterHeight/2 - u)^2+(j- filterWidth/2 - v)^2) + eps;
                D2(i,j) = sqrt((i- filterHeight/2 + u)^2+(j- filterWidth/2 + v)^2) + eps;            
            end
        end

        filter = filter .* (1 ./ (1 + (D0 ./ D1).^2*order)) .* (1 ./ (1 + (D0 ./ D2).^2*order));

    end

    filter(filter < 0.1) = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% addNoiseToImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds periodic sinusoidal noise to image in spatial domain                   %%%
%%% input(s) : {image : given image}                                                          %%%  
%%% output(s) : {noisyImage : noisy image }                                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = addNoiseToImage(image , noise_freq)
    noisyImage = image;
    for i = 1:size(noise_freq , 1)
        sinFilter = zeros(size(image));
        noiseAmputude = noise_freq(i , 1);
        noiseXFrequency = noise_freq(i , 2);
        noiseYFrequency = noise_freq(i , 3);
        for x = 1:size(image,1)
            for y = 1:size(image,2)
                sinFilter(x,y) = noiseAmputude*sin(2*pi*noiseXFrequency*x/size(image , 2) + 2*pi*noiseYFrequency*y/size(image , 1));
            end
        end
        noisyImage = noisyImage + sinFilter;% add noise to image   
    end
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