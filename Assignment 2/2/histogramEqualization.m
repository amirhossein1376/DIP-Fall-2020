%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% histogramEqualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function equalize an image                                                         %%%       
%%% input(s) : {inputImage : input image}                                                   %%%  
%%% output(s) : {outputImage : equalized imaged}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outputImage = histogramEqualization(inputImage)
    inputImageHist = calculateImageHistogram(inputImage);
    equaliztionMap = calculateEqualizationMap(inputImage ,inputImageHist);
    outputImage = applyMapOnImage(inputImage , equaliztionMap);
end