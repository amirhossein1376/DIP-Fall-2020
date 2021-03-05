clear all;

partA();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates results as Fig4.24 of text book                                     %%%
%%% input(s) : {}                                                                             %%%  
%%% output(s) : {}                                                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function partA()
    image = imread("woman.tif");% downloaded image
    rectangle = generateRectangle(size(image));% constrcut an image of a rectangle
    centeredRectangle = concentrateSpectrum(rectangle);% concentrate spectrum in the center of image
    rectangleFFT = fft2(rectangle);% apply fast furier transform
    rectangleMagnitude = abs(rectangleFFT);% calculate spectrum of furier transform
    rectangleAngle = angle(fft2(rectangle));% calculate angle of furier transform
    rectanglePhase = exp(1i * rectangleAngle);% calculate phase of furier transform

    centeredFFT = fft2(centeredRectangle);% apply fast furier transform
    centeredMagnitude = abs(centeredFFT);% spectrum of centered fast furier transform

    figure();
    subplot(231);
    imshow(rectangle);
    title("rectangle");

    subplot(232);
    imshow(rectangleMagnitude , []);
    title("rectangle spectrum");

    subplot(233);
    imshow(log10(1 + normalizeMatrix(rectangleMagnitude)) , []);
    title("log of rectangle spectrum");

    subplot(234);
    imshow(centeredRectangle);
    title("centered rectangle");

    subplot(235);
    imshow(centeredMagnitude , []);
    title("centered rectangle spectrum");


    subplot(236);
    imshow(log10(1 + normalizeMatrix(centeredMagnitude)) , []);
    title("log of centered rectangle spectrum")
    
    partBC(rectangle,-90,[140 , -140]);
    partD(image ,rectangleMagnitude ,rectanglePhase)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generateRectangle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates image of rectangle as mentioned in question                         %%%
%%% input(s) : {sizeOfImage : size of image}                                                  %%%  
%%% output(s) : {rectangleImage : a black plane with white rectangle inside it}               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rectangleImage = generateRectangle(sizeOfImage)
    h = sizeOfImage(1);
    w = sizeOfImage(2);
    rectangleImage = zeros(sizeOfImage);
    rectangleImage(215:295 , 248:262)=255;
%    rectangleImage(uint8(0.4199 * h):uint8(0.5762 * h), uint8(0.4844 * w):uint8(0.5117 * w))=255;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partBC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates results as Fig4.25 and Fig 4.26 of text book                                             %%%
%%% input(s) : {image : rectangle image , givenAngle : angle of rotation , givenTranslate : parameter of translation}%                                                                             %%%  
%%% output(s) : {}                                                                                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function partBC(image, givenAngle , givenTranslate)
    rotatedImage = imrotate(image, givenAngle );
    translatedImage = imtranslate(image , givenTranslate);

    fftR = normalizeMatrix(abs(fftshift(fft2(rotatedImage)))); % calculate spectrum of rotated image
    fftT = normalizeMatrix(abs(fftshift(fft2(translatedImage))));% calculate spectrum of translated image

    figure;
    subplot(223);
    imshow(rotatedImage);
    title("rotated image");
    subplot(224);
    imshow(log10(fftR + 1) , []);
    title("spectrum of rotated image");

    subplot(221);
    imshow(translatedImage);
    title("translated image");

    subplot(222);
    imshow(log10(fftT + 1) , []);
    title("spectrum of translated image");

    angle1 = angle(fft2(image));
    angle2 = angle(fft2(translatedImage));
    angle3 = angle(fft2(rotatedImage));

    figure
    subplot(131);
    imshow(angle1 , []);
    title("Angle of rectangle")
    subplot(132);
    imshow(angle2 , []);
    title("Angle of translated rectangle")

    subplot(133);
    imshow(angle3 , []);
    title("Angle of rotated rectangle")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function creates results as Fig4.27 of text book                                                                         %%%
%%% input(s) : {image : main image , rectangleMagnitude : spectrum of fft of rectangle , rectanglePhase : phase of fft of rectangle}%                                                                             %%%  
%%% output(s) : {}                                                                                                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function partD(image ,rectangleMagnitude , rectanglePhase)
    imageFFT = fft2(image);% furier transform of image

    imageAngle = angle(imageFFT);% angle of furier transform
    imagePhase = exp(1i * imageAngle);% phase of furier transform
    phaseInverse = ifft2(imagePhase); % reconstructed image from phase

    imageMagnitude = abs(imageFFT); % spectrum of furier transform
    magnitudeInverse = ifftshift(ifft2(imageMagnitude));% reconstructed image from spectrum

    image5 = ifft2(rectangleMagnitude .* imagePhase);% reconstructed image from phase of image and spectrum of rectangle
    image6 = ifft2(imageMagnitude .* rectanglePhase);% reconstructed image from phase of rectangle and spectrum of image

    figure;
    subplot(231);
    imshow(image);
    title("Main Image")
    
    subplot(232);
    imshow(imageAngle);
    title("Image FFT Angle")

    subplot(233);
    imshow(phaseInverse , []);
    title("Phase Reconstructed")
    
    subplot(234);
    imshow(uint8(magnitudeInverse));
    title("Spectrum Reconstructed")

    subplot(235);
    imshow(image5 , []);
    title("Image 5")

    subplot(236);
    imshow(image6 , []);
    title("Image 6")
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