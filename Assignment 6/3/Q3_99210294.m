clear all;
close all;
main;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%log(normalizeMatrix(rayLeigh , 0 , 255) + 1)%%%%%%%%%%%%%%%%
%%% This function is starting points of program and calls other functions                                                      %%%
%%% input(s) : {}                                                                                                              %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main()
    pattern = imread("pattern2.tif");%read pattern image
    M = size(pattern,1);%calculate height of patternlog(normalizeMatrix(rayLeigh , 0 , 255) + 1)
    N = size(pattern,2);%calculate width of pattern

    %gaussian noise apply and restoration
    gaussian = applyGaussianNoise(pattern , M , N , 0 , 15);
    gaussianNoiseRemoved = alphaTrimmedFilter(gaussian , 9 , 6);
    showResults("gaussian" , gaussian , gaussianNoiseRemoved , "alpha trimmed filter");

    %rayLeigh noise apply and restoration
    rayLeigh = applyRayLeighNoise(pattern , M , N , -16*pi , 400*pi);
    reighLeighNoiseRemoved = exp(imfilter(log(normalizeMatrix(rayLeigh , 0 , 255) + 1), ones(5,5), 'replicate')) .^ (1/numel(ones(5,5)));
    showResults("rayleigh" , rayLeigh , reighLeighNoiseRemoved ,  "geometric mean filter");
    
    %erlang noise apply and restoration
    erlang = applyErlangNoise(pattern , M , N , 1/5 , 20/3);
    erlangNoiseRemoved =  medfilt2(erlang);
    showResults("erlang" , erlang , erlangNoiseRemoved , "median filter");

    %exponential noise apply and restorationvec = vec(:)';
    exponential = applyExponentialNoise(pattern , M , N , 0.045);
    exponentialNoiseRemoved = imerode(im2gray(exponential), true(3));
    showResults("exponential" , exponential , exponentialNoiseRemoved , "min filter");
   
    %uniform noise apply and restoration
    uniform = applyUniformNoise(pattern , M , N , -20 , 20);
    uniformNoiseRemoved =  alphaTrimmedFilter(uniform , 9 , 6);
    showResults("uniform" , uniform , uniformNoiseRemoved , "alpha trimmed filter");
    
    %Salt & Pepper noise apply and restorationrayleigh
    saltPepper = applySaltPepperNoise(pattern , 0.8);
    saltPepperNoiseRemoved =  iterativeMedianFilter(saltPepper);
    showResults("Salt & Pepper" , saltPepper , saltPepperNoiseRemoved , "iterative median filter");
    
    %show two main figures
    figure();
    subplot(231)
    imshow(gaussian , []);
    title("Gaussian")
    
    subplot(232)
    imshow(rayLeigh , []);
    title("Rayleigh")
    
    subplot(233)
    imshow(erlang , []);
    title("Erlang")
    
    subplot(234)
    histogram(gaussian , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
    
    subplot(235)
    histogram(rayLeigh , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
    
    subplot(236)
    histogram(erlang , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
    
    
    figure();
    subplot(231)
    imshow(exponential , []);
    title("Exponential")
    
    subplot(232)
    imshow(uniform , []);
    title("Uniform")
    
    subplot(233)
    imshow(saltPepper , []);
    title("Salt & Pepper")
    
    subplot(234)
    histogram(exponential , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
    
    subplot(235)
    histogram(uniform , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
    
    subplot(236)
    histogram(saltPepper , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyGaussianNoise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds noise with gaussian distribution to the given image                    %%%
%%% input(s) : {image : given image, height : height of image, width : width of image         %%%
%%%            ,meanVal : mean parameter , varianceVal : variance parameter}                  %%%  
%%% output(s) : {noisyImage : noisy image}                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = applyGaussianNoise(image , height, width , meanVal , varianceVal)
    noise = meanVal + varianceVal * randn(height,width);
    noisyImage = double(image) + noise;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyUniformNoise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds noise with uniform distribution to the given image                     %%%
%%% input(s) : {image : given image, height : height of image, width : width of image         %%%
%%%            ,a : parameter "a", b : parameter "b"}                                         %%%  
%%% output(s) : {noisyImage : noisy image}                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = applyUniformNoise(image , height, width , a , b)
    noise = a + (b - a) * rand(height,width);
    noisyImage = double(image) + noise;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyRayLeighNoise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds noise with rayleigh distribution to the given image                    %%%
%%% input(s) : {image : given image, height : height of image, width : width of image         %%%
%%%            ,a : parameter "a", b : parameter "b"}                                         %%%  
%%% output(s) : {noisyImage : noisy image}                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = applyRayLeighNoise(image , height, width , a , b)
    noise = a + (-b*log(1 - rand(height , width))).^0.5;
    noisyImage = double(image) + noise;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyExponentialNoise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds noise with exponential distribution to the given image                 %%%
%%% input(s) : {image : given image, height : height of image, width : width of image         %%%
%%%            ,a : parameter "a"}                                                            %%%  
%%% output(s) : {noisyImage : noisy image}                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = applyExponentialNoise(image , height, width , a)
    noise = (-1 / a) * log(1 - rand(height,width));
    noisyImage = double(image) + noise;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyErlangNoise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds noise with erlang distribution to the given image                      %%%
%%% input(s) : {image : given image, height : height of image, width : width of image         %%%
%%%            ,a : parameter "a", b : parameter "b"}                                         %%%  
%%% output(s) : {noisyImage : noisy image}                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = applyErlangNoise(image , height, width , a , b)
    noise = zeros(height , width);
    for j = 1:b
        noise = noise + (-1/a) * log(1 - rand(height,width));
    end
    noisyImage = double(image) + noise;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applySaltPepperNoise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function adds salt and papper noise with given percentage to given image             %%%
%%% input(s) : {inputImage : given image, perc : percentage of noise}                         %%%  
%%% output(s) : {noisyImage : noisyImage}                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = applySaltPepperNoise(image , perc)
    noisyImage = uint8(image);% convert image to 8-bit unsigned int image
    height = size(image,1);% image height
    width = size(image,2);% image width
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% showResults %%%$$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates figure and displays neccessary figures                              %%%
%%% input(s) : {X : given matrix}                                                             %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showResults(noiseType , noisyPattern , noiseRemovedPattern , filterType)
    figure('Name' , strcat(noiseType , " noise"));
    
    subplot(221);
    imshow(noisyPattern , []);
    title(strcat("the pattern with " , noiseType ," noise"))
    subplot(223);
    histogram(noisyPattern , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
    title(strcat("the histogram of the pattern with " , noiseType , " noise"))
    
    subplot(222);
    imshow(noiseRemovedPattern , []);
    title([strcat("the " , noiseType , " noise reduction result") , strcat("filtered by : " , filterType)]);
    subplot(224);
    histogram(noiseRemovedPattern , 'Normalization' , 'probability' , 'BinWidth', 1 , 'NumBins', 255);
    title(strcat("the histogram of the ", noiseType ," noise reduction result"))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalizeMatrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function scale matrix values to range [0 255]                                        %%%
%%% input(s) : {X : given matrix}                                                             %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X , minVal , maxVal)
    X = X - min(min(X));
    result = minVal + (maxVal-minVal)* X / max(max(X));
end
