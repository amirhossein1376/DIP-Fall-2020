%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculateEqualizationMap %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates equalization map for a given histogram                            %%%       
%%% input(s) : {inputImage : input image, inputHist : given histogram for calculating map}     %%%  
%%% output(s) : {equalizationMap : equalized historgram map}                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function equalizationMap = calculateEqualizationMap(inputImage, inputHist)
    normalizedHist = inputHist ./ (size(inputImage,1) * size(inputImage,2));
    equalizationMap = round((255) * cumsum(normalizedHist));
end