%%%%%%%%%%%%%%%%%%%%%%%%%%    convolveFilterOnImage    %%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function convolves image and filter                                 %%%       
%%% input(s) : {inputImage : given image, filter : given filter}             %%%  
%%% output(s) : {convolvedImage : result of convolution}                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function convolvedImage = convolveFilterOnImage(inputImage, filter)
    rotatedFilter = rotateMatrix180(filter); % first, roate filter for convolution
    convolvedImage = applyFilterOnImage(inputImage, rotatedFilter); % do correlation
end