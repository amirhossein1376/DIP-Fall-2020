clear all;
main();
function main()
    image = imread("blown_ic.tif");% downloaded image
    zeropadImage = zeropad(image);% zero padded image
    centeredImage = concentrateSpectrum(zeropadImage);% image mutiplied by -1^(x+y)
    F = fft2(centeredImage);% Fast Furier Transform of image

    gFilter = generateGaussianFilter(20 , size(zeropadImage));%gaussian filter
    G = gFilter .* F;
    g = concentrateSpectrum(real(ifft2(G)));

    figure;

    subplot(331)
    imshow(image);
    title("main image")
    subplot(332)
    imshow(uint8(zeropadImage));
    title("zero padded image")

    subplot(333)
    imshow(uint8(centeredImage));
    title("image mutiplied by (-1)^(x+y)")

    subplot(334)
    imshow(log(abs(F) + 1) , []);
    title("spectrum of fft of image")

    subplot(335)
    imshow(gFilter);
    title("gaussian filter")

    subplot(336)
    imshow(abs(G));
    title("spectrum multiplied by gaussian filter")

    subplot(337)
    imshow(g , []);
    title("result of applying filter with zeropad")

    subplot(338)
    imshow(g(1:size(image,1) , 1:size(image,2)) , []);
    title("result of applying filter without zeropad")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generateGaussianFilter  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function generates Gaussian filter                                                   %%%
%%% input(s) : {}                                                                             %%%  
%%% output(s) : {filter : generated filter}                                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filter = generateGaussianFilter(D0 , filterSize)
    M = filterSize(1);
    N = filterSize(2);
    X=0:N-1;
    Y=0:M-1;
    [X, Y]=meshgrid(X,Y);
    Cx=0.5*N;
    Cy=0.5*M;
    filter=exp(-((X-Cx).^2+(Y-Cy).^2)./(2*D0.^2));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% zeropad %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function add zero padding to given image                                             %%%
%%% input(s) : {inputImage : given image}                                                     %%%  
%%% output(s) : {outputImage : zero padded image}                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outputImage = zeropad(inputImage)
    imageHeight = size(inputImage ,1);
    imageWidth = size(inputImage ,2);
    outputImage = zeros(2 * size(inputImage));
    outputImage(1:imageHeight,1:imageWidth) = inputImage;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% concentrateSpectrum %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function mutiplies image to -1^(x+y)                                                 %%%
%%% input(s) : {inputImage : given image}                                                     %%%  
%%% output(s) : {resultImage : result of multiplication}                                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultImage = concentrateSpectrum(inputImage)
    resultImage = inputImage;
    for i = 1:size(resultImage,1)
        for j =1:size(resultImage,2)
            resultImage(i,j) = resultImage(i,j) * (-1)^(i+j);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalizeMatrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function scale matrix values to range [0 255]                                        %%%
%%% input(s) : {X : given matrix}                                                             %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X)
    X = X - min(min(X));
    result = 255 * X / max(max(X));
end