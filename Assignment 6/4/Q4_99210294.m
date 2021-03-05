clear all;
close all;
main();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function is starting points of program and calls other functions                                                      %%%
%%% input(s) : {}                                                                                                              %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main()

    originalImage = im2double(imread("dip.tif"));%read image
    a = input("Please Enter coefficient of x-direction motion : ");
    b = input("Please Enter coefficient of y-direction motion : ");
    T = input("Please Enter duration of motion : ");
    
    [motionBluredImage , motionBlurFilter] = applyLinearMotionEffect(originalImage , a , b , T);%applying linera motion effect
%    [motionBluredImage , motionBlurFilter] = motionBlur(originalImage , a , b , T);
    
    motionBlurRestoredImage = restoreMotionBluredImage(motionBluredImage , motionBlurFilter);%removing linera motion effect

    noisyBluredImage = applyGaussianNoiseOnImage(motionBluredImage , 0 , 0.0001);%apply gaussian noise on image
    
    noisyBluredRestoredImage = restoreMotionBluredNoisyImage(noisyBluredImage , motionBlurFilter , 0.0001);%removing linera motion effect and noise

    figure();
    subplot(231);
    imshow(originalImage , []);
    title("The original image")
    
    subplot(232);
    imshow(motionBluredImage , []);
    title(["The motion blured image" , strcat("a : " , num2str(a) , " , b : " , num2str(b) , " , T : " , num2str(T))])

    subplot(233);
    imshow(motionBlurRestoredImage , []);
    title("Result of applying wiener filter on motion blured image ")
    
    subplot(234);
    imshow(noisyBluredImage , []);
    title("Result of adding noise to motion blured image ")
    
    subplot(235);
    imshow(noisyBluredRestoredImage , []);
    title("Result of applying wiener filter on noisy motion blured image ")
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyLinearMotionEffect %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function simulates motion blur according to equation 5-6-11 of the text book                                                            %%%
%%% input(s) : {image , x : coefficient of motion in the x-direction , y : coefficient of motion in the y-direction , T : duration of motion}    %%%  
%%% output(s) : {motionbluredImage : result of motion simulation , motionblurFilter : filter that applied on image}                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [motionBluredImage , motionBlurFilter]= applyLinearMotionEffect(image , a , b , T)

    angle = -atan(a / b) * 180 / pi; % calculate angle of motion

    motionBlurFilter = fspecial('motion' , T , angle);%create motion filter
    motionBluredImage = imfilter(image , motionBlurFilter , 'conv','circular');%apply filter on image

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% restoreMotionBluredImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function applies wiener filter on the blured image                                                                                      %%%
%%% input(s) : {bluredImage : blured image ,blurFilter : created filter for creating motion blur}                                                %%%  
%%% output(s) : {restoredImage : restored image}                                                                                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function restoredImage = restoreMotionBluredImage(bluredImage , blurFilter)
    restoredImage = deconvwnr(bluredImage,blurFilter);%apply wiener filter on blured image
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% restoreMotionBluredImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function applies gaussian noise on blured image                                                                                 %%%
%%% input(s) : {image : blured image ,noise_mean : mean parameter for gaussain noise , noise_var : variance parameter for gaussain noise}%%%  
%%% output(s) : {noisyImage : blured noisy image}                                                                                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function noisyImage = applyGaussianNoiseOnImage(image , noise_mean , noise_var)
    noisyImage = imnoise(image,'gaussian',noise_mean,noise_var);
end

function restoredImage = restoreMotionBluredNoisyImage(image , motionBlurFilter , noise_var)
    signal_var = var(image(:));%get variance of blured noisy image
    NSR = noise_var / signal_var;
    restoredImage = deconvwnr(image,motionBlurFilter,NSR);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% motionBlur %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function simulates motion blur according to equation 5-6-11 of the text book                                                            %%%
%%% input(s) : {image , a : coefficient of motion in the x-direction , y : coefficient of motion in the y-direction , T : duration of motion}    %%%  
%%% output(s) : {bluredImage : result of motion simulation , blurFilter : filter that applied on image}                                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bluredImage , blurFilter ] = motionBlur(image , a , b , T)
    blurFilter = zeros(size(image));%create blur filter
    for u = 1:size(image,1)
        for v = 1:size(image,2)
            x = u - height(image)/2;%calculate x relative to center
            y = v - width(image) / 2;%calculate y relative to center
            blurFilter(u,v) = T * sin(pi*(x*a + y*b)) * exp(-1i*pi*(x*a + y*b)) / (pi*(x*a + y*b) + eps);%equation of filter (eq : 5-6-11)
        end
    end
    imageDft = fft2(concentrateSpectrum(image));
    bluredImage = abs(concentrateSpectrum(ifft2(imageDft .* blurFilter)));
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