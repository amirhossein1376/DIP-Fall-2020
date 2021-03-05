%%%%%%%%%%%%%%%%%%%%%%%%%%    applyMapOnImage    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function applys given map on given image                       %%%       
%%% input(s) : {inputImage : same as its name!! , map : given map }     %%%  
%%% output(s) : {resultImage : result of mapping}                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function resultImage = applyMapOnImage(inputImage , map)
    resultImage = uint8(zeros(size(inputImage)));
    for i = 1:size(inputImage,1)
        for j = 1:size(inputImage,2)
            resultImage(i,j) = map(inputImage(i,j) + 1);
        end
    end
end