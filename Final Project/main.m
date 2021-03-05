clear;
close all;
clc;

%-------------------------------------------------------------------------------------------------------------------%
imagePath = input("Please Enter Image Path: \n");
%setp1
originalImage = readLowIlluminationImage(imagePath);%read low illumination iamge
%step2
[Ih , Is , Iv ] = rgb2hsv(originalImage);%convert rgb image to hsv form

figure('Name' , 'RGB to HSV');
subplot(232);
imshow(originalImage,[]);
title("The orignial image")

subplot(234);
imshow(Ih,[]);
title("Hue component of the original image")

subplot(235);
imshow(Is,[]);
title("Saturation component of the original image")

subplot(236);
imshow(Iv,[]);
title("Brightness component of the original image")

%step3
Iv_g = applyMultiscaleGaussianFunction(Iv, 15, 15, [1/3 1/3 1/3], [15 80 250]);%estimation of reflection component

figure('Name' , 'Illustration component')
imshow(Iv_g , []);

%step4
alpha1 = 0.1;
alpha2 = 1;
I_prime_v_1 = adaptiveBrightnessEnhancedImage(Is , Iv , Iv_g , alpha1);%enhance image using alpha = 0.1
I_prime_v_2 = adaptiveBrightnessEnhancedImage(Is , Iv , Iv_g , alpha2);%enhance image using alpha = 1

figure('Name' , 'Adaptive brightness enhanced');
subplot(121);
imshow(I_prime_v_1,[]);
title(strcat("First enhanced brightness component , alpha = " , num2str(alpha1)));

subplot(122);
imshow(I_prime_v_2,[]);
title(strcat("Second enhanced brightness component, alpha = " , num2str(alpha2)));

%step5
C = getCovarianceMatrix(I_prime_v_1 , I_prime_v_2);
%step6
[eigenVectors,p] = getEigenVecotrs(C);%get eigen vectors of covariance matrix
%step7
[w1 , w2] = calcualteWeightCoefficient(eigenVectors, p);
%step8
fusedImage = w1 .* I_prime_v_1 +  w2 .* I_prime_v_2;
%step9
resultImage = convertFusedImageToRgbSpace(height(originalImage), width(originalImage), Ih, Is, fusedImage);
%step10
figure('Name', 'Result');
subplot(121);
imshow(originalImage);
title("The original image")
subplot(122);
imshow(resultImage);
title("Result of aplying proposed algorithm")
%-------------------------------------------------------------------------------------------------------------------%
