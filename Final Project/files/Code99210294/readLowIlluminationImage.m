%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% readLowIlluminationImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function reads rgb image and transform values of its pixels to range [0 1] and returns it                   
    input(s) : {imagePath : path to the image}

    output(s) : {image : rgb image readed}                                                                           
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function image = readLowIlluminationImage(imagePath)
    image = im2double(imread(imagePath));%read image
    if(size(image , 3) ~= 3)%check if image is rgb
        ME = MException('MyComponent:ImageIsNotRGB', 'The given image is not rgb', imagePath);
        throw(ME)%throw exception if the image is not rgb
    end
end