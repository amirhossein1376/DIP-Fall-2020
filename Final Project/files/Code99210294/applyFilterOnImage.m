%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyFilterOnImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function applys given filter on given image                       
    input(s) : {inputImage : given image,
                filter : given filter}

    output(s) : {resultImage : result of applying filter on image}                                                             
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultImage = applyFilterOnImage(inputImage, filter)
    imageHeight = size(inputImage,1);% read image height
    imageWidth = size(inputImage,2);% raed image width
    fh = size(filter,1);% filter height
    a = floor(fh/2);
    fw = size(filter,2);% filter width
    b = floor(fw/2);
    
    paddedImage = zeros(imageHeight + 4 * a, imageWidth + 4 * b);% create bigger image for zero padding
    paddedImage(2*a + 1:2*a + imageHeight,2*b + 1:2*b + imageWidth) = inputImage; % add main image to correct position in bigger zero padded image
    resultImage = paddedImage;% create another image of size paddedImage for saving results in it
    for i = a + 1:3 * a + imageHeight % move on the vertical points of main image in the zero padded image
        for j = b + 1:3 * b + imageWidth % move on the horizontal points of main image in the zero padded image
            resultImage(i,j) = sum(sum((paddedImage(i-a:i+a,j-b:j+b) .* filter))); % multiply filter by elements of (i,j) Neighborhood
        end
    end
    resultImage = resultImage(2*a + 1:2 * a + imageHeight,2*b + 1:2 * b + imageWidth);% convert result image to 8-bit unsigned integer matrix
end
