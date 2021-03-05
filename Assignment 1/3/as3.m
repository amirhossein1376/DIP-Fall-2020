clear all;
astImage = rgb2gray(imread('astronomical_image.jpg')); % read image
times = [5 , 10, 50 , 100];

for i = 1:4
    currentTimes = times(i); % number of noises in current iteration
    noisyImageSum = zeros(size(astImage)); % create matrix for sum of noisy images
    noiseSum = uint8(zeros(size(astImage))); % create matrix for sum of noises on image
    for j = 1:currentTimes
        noisyImage = imnoise(astImage,'gaussian');
        noisyImageSum = noisyImageSum + double(noisyImage);
        noiseSum = noiseSum + noisyImage - astImage;% add current noise to sum of noises
    end
    avgImage = uint8(noisyImageSum / currentTimes); % caluclate average image
    noiseSum = uint8(noiseSum);
   
    % figure images
    figure('Name',strcat(int2str(currentTimes) , ' times of noise addition'),'NumberTitle','off');
    subplot(2 , 3 , 1);
    imshow(astImage);
    title("Original")
    subplot(2 , 3 , 2);
    imshow(noisyImage);
    title("Noisy")
    subplot(2 , 3 , 3);
    imshow(avgImage);
    title("Average")
    subplot(2 , 3 , 4);
    imhist(astImage);
    subplot(2 , 3 , 5);
    imhist(noisyImage);
    subplot(2 , 3 , 6);
    imhist(avgImage);
    
end