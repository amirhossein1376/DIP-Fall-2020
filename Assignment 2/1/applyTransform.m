%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% applyTransform %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function applys user diagram to an image                                       %%%
%%% input(s) : {inputImage : same as its name!! , points : selected points on diagram } %%%  
%%% output(s) : {resultImage : transformed image}                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultImage = applyTransform(inputImage , points)
    resultImage = uint8(zeros(size(inputImage)));
    imgHeight = size(inputImage , 1);
    imgWidth = size(inputImage , 2);
    for i = 1:imgHeight
        for j = 1:imgWidth
            currentPix = inputImage(i , j);
            for k = 2:size(points , 1)
                x1 = points(k-1,1);
                x2 = points(k,1);
                if x1 == x2 && x1 == currentPix
                    currentPix = currentPix + 1;
                end
                if x1 <= currentPix && currentPix <= x2
                    y1 = points(k-1,2);
                    y2 = points(k,2);
                    resultImage(i, j) = uint8(y1 + (y2 - y1) / (x2 - x1) * ( currentPix - x1));
                    break
                end
            end
        end
    end
end
