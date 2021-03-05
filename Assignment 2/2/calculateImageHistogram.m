%%%%%%%%%%%%%%%%%%%%%%%%%% calculateImageHistogram %%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates histogram for a given image                  %%%       
%%% input(s) : {inputImage : given image for calculating histogram}       %%%  
%%% output(s) : {outputHistogram : obtained histogram}                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [outputHistogram] = calculateImageHistogram(inputImage)
    outputHistogram = zeros(1 , 256);
    for i = 1:size(inputImage,1)
        for j = 1:size(inputImage,2)
            outputHistogram(1 , inputImage(i,j) + 1) = outputHistogram(1 , inputImage(i,j) + 1) + 1;
        end
    end
end