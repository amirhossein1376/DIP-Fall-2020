%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% iterativeMedianFilter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function applies iterative median filter algorithm on the given image                           %%%
%%% input(s) : {noisyImage : given image that we want to remove its noise by iterative median filter}    %%%  
%%% output(s) : {resultImage : result of applying iterative median filter}                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultImage = iterativeMedianFilter(noisyImage)
    resultImage = noisyImage;% create temp variable, we want to apply changes on it and return it as a result
    for i = 1:size(noisyImage,1) % move vertically on the image
        for j = 1:size(noisyImage,2) % move horizontally on the image
            for k = 1:8 % window size = 2 * k + 1 (3,5,7,...,17) as wanted in the question
                vals = []; % variale for saving points in the neighborhood of (i,j)
                for p = i-k:i+k % x's of neighborhoods 
                    for q = j-k:j+k %y's of neighborhoods 
                        if p >= 1 && p <= size(noisyImage,1) && q>=1 && q<= size(noisyImage,2)% check if neighborhood is in the image
                            vals = [vals noisyImage(p,q)]; % add x and y of neighborhood to 'vals' variable
                        end
                    end
                end
                med = median(vals);% find median of neighborhoods
                if med ~= 0 && med ~= 255 % check if median is not noise itself
                    resultImage(i,j) = med;%save median of neighborhood points as value for (i,j)
                    break
                end
            end
        end
    end
end
