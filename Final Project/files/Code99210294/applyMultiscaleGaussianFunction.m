%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyMultiscaleGaussianFunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function calculates weighted sum of result of applying mutiple gaussian filter on image                   
    input(s) : {image : image to be filtered ,
                height : height of filter ,
                width : width of filter ,
                thetas : weight of each gaussian filter on output
                sigmas : standard deviation parameters of gausian functions}                   

    output(s) : {f : weighted sum of result of applying mutiple gaussian filter on image}                                                                              
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = applyMultiscaleGaussianFunction(image, height , width , thetas , sigmas)
    f = zeros(size(image));
    for i = 1:length(sigmas)
        f = f + thetas(i) .* applyFilterOnImage(image, gaussianFunction(height , width , sigmas(i)));
    end
end