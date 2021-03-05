main
function main()
    image = imread("image2.tif"); % read image
    bluredImage = imfilter(image , ones(3,3)/9);% blur image using matlab function
    mask = double(image) - double(bluredImage);% calcualte mask
    
    %scale mask to 0 - 255
    firstMask = double(mask) - ones(size(mask))*(min(min(double(mask))));
    firstMask = uint8(255 * firstMask / max(max(firstMask)));
    
    sharpedImage = uint8(image + 1 * uint8(mask));% calcualte sharped image
    highBoostsharpedImage = uint8(image + 6 * uint8(mask));% calcualte high boosted sharped image
    
    %show images
    figure;
    subplot(231);
    imshow(image);
    title('Main Image')

    subplot(234);
    imshow(bluredImage);
    title('Blured Image')

    subplot(232);
    imshow(uint8(mask) , []);
    title('Mask')

    subplot(235);
    imshow(firstMask);
    title('Scaled Mask')

    subplot(233);
    imshow(sharpedImage);
    title('Unsharp Masking')

    subplot(236);
    imshow(highBoostsharpedImage);
    title('High boost Filtering')

end