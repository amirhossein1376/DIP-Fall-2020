%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% alphaTrimmedFilter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function applies alpha trimmed filter to given image                                            %%%
%%% input(s) : {noisyImage : given image, windowSize : size of filter, alpha : d value for filter}       %%%  
%%% output(s) : {resultImage : result of applying alpha trimmed filter}                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultImage = alphaTrimmedFilter(noisyImage , windowSize , alpha)
    t = floor(windowSize / 2);% number of zeros we should add to top,bottom,left,right of the image
    tempImage = uint8(zeros(size(noisyImage,1) + 2*t,size(noisyImage,2)+2*t));%create big image for adding zero pad to noisy image
    tempImage(t+1:t+size(noisyImage,1), t+1:t+size(noisyImage,2)) = noisyImage;%add noisy image in the correct position in big image
    resultImage = tempImage;%create variable for saving result of algorithm
    for i = t+1:t+size(noisyImage,1)% move vertically on image
        for j = t+1:t+size(noisyImage,2)% move horizontally on image
            mat = tempImage(i-t:i+t , j-t:j+t); % neighborhood of (i,j)
            %convert matrix of gray levels in the neighborhood to vector 
            vec = mat';
            vec = vec(:)';
            sortedVec = sort(vec);%sort vector
            sortedVec = sortedVec(1:end,ceil(alpha/2)+1:length(sortedVec) - floor(alpha/2)); %remove alpha points from this vector
            resultImage(i,j) = round(mean(sortedVec , 'all'));%do alpha trim
        end
    end
    resultImage = resultImage(t+1:t+size(noisyImage,1), t+1:t+size(noisyImage,2));%crop result image from zero pad image
end