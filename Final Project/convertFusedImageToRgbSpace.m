%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% convertFusedImageToRgbSpace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function converts fused image from hsv space to rgb sapce
    input(s) : {imageHeight : height of the original image,
                imageWidth : width of the original image,
                Ih : hue component of the original image,
                Is : saturation component of the original image,
                fusedImage : fused brightness component of the original image}

    output(s) : {resultImage : output image in rgb space}
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultImage = convertFusedImageToRgbSpace(imageHeight, imageWidth, Ih, Is, fusedImage)
    hsvImage = zeros(imageHeight, imageWidth);
    hsvImage(:,:,1) = Ih;
    hsvImage(:,:,2) = Is;
    hsvImage(:,:,3) = normalizeMatrix(fusedImage, 0, 1);
    resultImage = hsv2rgb(hsvImage);
end