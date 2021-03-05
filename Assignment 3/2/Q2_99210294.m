main
function main()
    image = imread('image2.tif'); % read image
    percentage = input('Pleasse Enter noise percentage:  ');% input percentage of noise from user
    %Question 2 Part (a)
    noisyImage = createNoisyImage(image,percentage);%create noisy image
    
    %Question 2 Part (b)
    resultMatlab3 = medfilt2(noisyImage,[3 3]);% apply matlab median filter 3*3
    resultMatlab5 = medfilt2(noisyImage,[5 5]);% apply matlab median filter 5*5

    %Question 2 Part (c)    
    resultMedian = iterativeMedianFilter(noisyImage);

    %Question 2 Part (d)    
    resultAlphaTrimmed = alphaTrimmedFilter(noisyImage, 5, 15);

    %show results
    figure;
    subplot(231);
    imshow(image);
    title('Main Image')
    subplot(234);
    imshow(noisyImage);
    title('Noisy Image')

    subplot(232);
    imshow(resultMatlab3);
    title('Mat. Median Filter 3*3')

    subplot(235);
    imshow(resultMatlab5);
    title('Mat. Median Filter 5*5')

    subplot(233);
    imshow(resultMedian);
    title('Iterative Median Filter')

    subplot(236);
    imshow(resultAlphaTrimmed);
    title('Alpha Trimmed Filter')
end