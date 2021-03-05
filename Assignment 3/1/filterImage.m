%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    filterImage    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates wanted filters and call functions for applying these filters on image                    %%%       
%%% input(s) : {inputImage : given image, filterType : type of filter we want to apply (Mean , Soble , Prewitt)}   %%%  
%%% output(s) : {we haven't any outputs for this function, this function just show results in figure}              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filterImage(inputImage , filterType)
    imgHeight = size(inputImage, 1);
    imgWidth = size(inputImage, 2);
    if filterType == "Mean" % check if we are int the Question 1 Part (a)
        filter1 = (1/9)*[1,1,1;1,1,1;1,1,1]; % filter in Fig 3.32 (a)
        filter2 = (1/16)*[1,2,1;2,4,2;1,2,1]; % filter in Fig 3.32 (b)
        myConvolvedImage1 = convolveFilterOnImage(inputImage, filter1);% convolve image and first filter 
        myConvolvedImage2 = convolveFilterOnImage(inputImage, filter2);% convolve image and second filter 
        matlabConvolvedImage1 = uint8(conv2(inputImage, filter1));% convolve image and first filter with matlab function
        matlabConvolvedImage2 = uint8(conv2(inputImage, filter2));% convolve image and second filter with matlab function
        diff1 = imabsdiff(myConvolvedImage1,matlabConvolvedImage1);% calculate difference of my convolution and matlab's convolution for first filter
        diff2 = imabsdiff(myConvolvedImage2,matlabConvolvedImage2);% calculate difference of my convolution and matlab's convolution for second filter
    else % we are int the Question 1 Part (b)
        if filterType == "Sobel"
            filter1 = [-1,-2,-1;0,0,0;1,2,1];% initialize sobel's horizontal filter
            filter2 = [-1,0,1;-2,0,2;-1,0,1];% initialize sobel's vertical filter
        elseif filterType == "Prewitt"
            filter1 = [1,1,1;0,0,0;-1,-1,-1];% initialize Prewitt's horizontal filter
            filter2 = [1,0,-1;1,0,-1;1,0,-1];% initialize Prewitt's vertical filter
        end
        myConvolvedImage1 = convolveFilterOnImage(inputImage, filter1);% convolve horizontal filter and image
        myConvolvedImage2 = convolveFilterOnImage(inputImage, filter2);% convolve vertical filter and image
        myConvolvedImage = myConvolvedImage1 + myConvolvedImage2; % Gradient estimation
        matlabConvolvedImage1 = uint8(conv2(inputImage, filter1));% convolve horizontal filter and image with matlab's function
        matlabConvolvedImage2 = uint8(conv2(inputImage, filter2));% convolve vertical filter and image with matlab's function
        matlabConvolvedImage = matlabConvolvedImage1 + matlabConvolvedImage2;% Gradient estimation with matlab's function
        diff = imabsdiff(myConvolvedImage,matlabConvolvedImage);% calculate difference of my gradient and matlab's gradient
    end
    
    figure('Name', strcat(filterType , ' Filters'), 'NumberTitle', 'off');% show and change the name of figure
    %show main image
    subplot(141)
    imshow(inputImage)
    title('Main Image')

    if filterType == "Mean"
        % show first convolved image
        subplot(242)
        imshow(myConvolvedImage1)
        title('My Filter 1 Convolution')
        %show second convolved image
        subplot(246)
        imshow(myConvolvedImage2)
        title('My Filter 2 Convolution')
        %show first image that convolved with matlab function
        subplot(243)
        imshow(matlabConvolvedImage1)
        title('Matlab"s Filter 1 Convolution')
        %show second image that convolved with matlab function
        subplot(247)
        imshow(matlabConvolvedImage2)
        title("Matlab's Filter 2 Convolution")
        
        %show difference of my and matlab implementation for first filter 
        subplot(244)
        imshow(diff1,[])
        title({"1 : Difference",strcat("Total : " , int2str(sum(sum(diff1))),strcat(" , Mean : " , num2str(sum(sum(diff1))/ imgWidth / imgHeight)))});
        
        %show difference of my and matlab implementation for second filter 
        subplot(248)
        imshow(diff2,[])
        
        title({"2 : Difference",strcat("Total : " , int2str(sum(sum(diff2))),strcat(" , Mean : " , num2str(sum(sum(diff2))/ imgWidth / imgHeight)))});
    else
        % show main image
        subplot(141)
        imshow(inputImage)
        title('Main Image')
        
        % show convolved image
        subplot(142)
        imshow(myConvolvedImage)
        title('My Convolution')
        
        % show image convolved my matlab function
        subplot(143)
        imshow(matlabConvolvedImage)
        title("Matlab's Convolution")
        
        % show difference of my and matlab implementation for filter 
        subplot(144)
        imshow(diff)
        title({"Difference",strcat("Total : " , int2str(sum(sum(diff))),strcat(" , Mean : " , num2str(sum(sum(diff))/ imgWidth / imgHeight)))});
    end
end