clear all;
main();

function main
    %get inputs
    imageName = input("Please enter image name : ");
    windowSize = input("Please enter window size: ");
    padding = floor(windowSize / 2); % calculate padding according to window size

    %read image
    imgRead = imread(imageName);

    %local equalization
    [myOutputImage , matlabOutputImage] = localEqualization(imgRead ,padding);

    %show results
    figure();

    subplot(121);
    imshow(imgRead);
    title("Main Image");

    subplot(222);
    imshow(myOutputImage);
    title("Local Equal. with my function")

     subplot(224);
     imshow(matlabOutputImage);
     title("Local Equal. with matlab's function")

end