return
myFolder = 'images';
myFolderEdited = 'images/Enhanced/';
filePatternJpg = fullfile(myFolder, '*.jpg');
filePatternPng = fullfile(myFolder, '*.png');
jpegFiles = [dir(filePatternJpg);dir(filePatternPng)];
count = length(jpegFiles);
strCount = int2str(count);

fileNames = strings(count,1);
entropiesBefore = zeros(count,1);
entropiesAfter = zeros(count,1);
AGsBefore = zeros(count,1);
AGsAfter = zeros(count,1);
startTimes = zeros(count,1);
endTimes = zeros(count,1);
sizes = strings(count,1);
tic;
for k = 1:count
  try
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  
  disp(strcat("Reading " , int2str(k) + "th file out of " , strCount , " files"))
  fileNames(k) = baseFileName;
  
  image = imread(fullFileName);
  
  entropiesBefore(k) = entropy(image);
  AGsBefore(k) = gradientAvg(image);
  sizes(k) = mat2str(size(image));
  startTimes(k) = toc;
  
  resultImage = test(fullFileName);
  endTimes(k) = toc;
  entropiesAfter(k) = entropy(resultImage);
  AGsAfter(k) = gradientAvg(resultImage);
  
  newImage = zeros(size(image,1),2*size(image,2),3);
  newImage(:,1:size(image,2),:) = im2double(image);
  newImage(:,size(image,2)+1:end,:) = resultImage;
  imwrite(resultImage , strcat(myFolderEdited , baseFileName))
  catch
    warning(strcat('Problem with : ' , baseFileName));
  end
      
end

function resultImage = test(path)
    %-------------------------------------------------------------------------------------------------------------------%
%setp1
originalImage = readLowIlluminationImage(path);%read low illumination iamge
%step2
[Ih , Is , Iv ] = rgb2hsv(originalImage);%convert rgb image to hsv form
%step3
Iv_g = applyMultiscaleGaussianFunction(Iv, 15, 15, [1/3 1/3 1/3], [15 80 250]);%estimation of reflection component
%step4
alpha1 = 0.1;
alpha2 = 1;
I_prime_v_1 = adaptiveBrightnessEnhancedImage(Is , Iv , Iv_g , alpha1);%enhance image using alpha = 0.1
I_prime_v_2 = adaptiveBrightnessEnhancedImage(Is , Iv , Iv_g , alpha2);%enhance image using alpha = 1
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
%subplot(121);
%imshow(originalImage);
%title("The original image")
%subplot(122);
%imshow(resultImage);
%title("Result of aplying proposed algorithm")
%-------------------------------------------------------------------------------------------------------------------%
end


function AG = gradientAvg(X)
    %Here X is the array for which Gradient is to be calculated
    [Gmag1,Gdir1] = imgradient(X(:,:,1),'sobel');
    [Gmag2,Gdir2] = imgradient(X(:,:,2),'sobel');
    [Gmag3,Gdir3] = imgradient(X(:,:,3),'sobel');
    Gmag = Gmag1 + Gmag2 + Gmag3;
    % Here since Gmag represent Magnitude of Gradient so no need to take absolute value
    AG = sum(sum(Gmag))./(sqrt(2)*(size(X,1)-1)*(size(X,2)-1));
end