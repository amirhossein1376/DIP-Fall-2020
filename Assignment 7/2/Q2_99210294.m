clear all;
close all;


image = imread("sti.tif");% read image
doEdgeDetection(image , 'Laplacian');% edge detection using Laplacian method
doEdgeDetection(image , 'Sobel');% edge detection using Sobel method
doEdgeDetection(image , 'Di Zenzo');% edge detection using Di Zenzo method


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% doEdgeDetection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function detect edges in RGB image usin 3 different methods : 'Laplacian' , 'Sobel' , 'Di zenzo'                      %%%
%%% input(s) : {image : given rgb image , method : 'Laplacian' or 'Sobel' or 'Di zenzo'}                                       %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function doEdgeDetection(image , method)
    rgb = ["Red" , "Green" , "Blue"];
    
    figure('Name' , method);
    subplot(2,4,1);
    imshow(image);
    title(strcat("The original image"));

    if method == "Laplacian"
        
        filter = [0 -1 0;-1 4 -1;0 -1 0];% design filter
        lapResult = uint8(zeros(size(image)));%variable for saving result of laplacian
        for i = 1:3 % iterate on R , G , B plates
            plate = image(:,:,i);% current plate
            lapPlateResult = uint8(convolveFilterOnImage(plate, filter));% convolve image and first filter
            lapResult(:,:,i) = lapPlateResult;%save result of filtering to corresponding plate in the final rgb image
            
            %show result
            subplot(2,3,i+3);
            imshow(lapPlateResult);
            title(strcat("Result of applying Laplacian filter on " , rgb(i) , " Plate"));
        end
        combined = lapResult(:,:,1) + lapResult(:,:,2) + lapResult(:,:,3);%add result of different plates together to get combined version
        subplot(2,4,2);
        imshow(lapResult);
        title(strcat("Result of combined Laplacian filtering"));
        subplot(2,4,3);
        imshow(combined);
        title(strcat("Grayscale Result of combined Sobel filtering"));
        subplot(2,4,4);
        imshow(image + lapResult);
        title(strcat("Final Image"));
        
    elseif method == "Sobel"
        
        filterX = [-1,-2,-1;0,0,0;1,2,1];% initialize sobel's horizontal filter
        filterY = [-1,0,1;-2,0,2;-1,0,1];% initialize sobel's vertical filter
        sobelResult = uint8(zeros(size(image)));%variable for saving result of sobel filtering
        for i = 1:3 % iterate on R , G , B plates
            plate = image(:,:,i);% current plate
            sobelPlateResultX = uint8(convolveFilterOnImage(plate, filterX));% convolve plate and horizontal filter
            sobelPlateResultY = uint8(convolveFilterOnImage(plate, filterY));% convolve plate and vertical filter
            sobelPlateResult = sobelPlateResultX + sobelPlateResultY;% add horizontal and vertical convolution results
            sobelResult(:,:,i) = sobelPlateResult;%save result of filtering to corresponding plate in the final rgb image
            
            %show result
            subplot(2,3,i+3);
            imshow(sobelPlateResult);
            title(strcat("Result of applying Sobel filter on " , rgb(i) , " Plate"));
        end
        
        combined = sobelResult(:,:,1) + sobelResult(:,:,2) + sobelResult(:,:,3);%add result of different plates together to get combined version
        subplot(2,4,2);
        imshow(sobelResult);
        title(strcat("Result of combined Sobel filtering"));
        subplot(2,4,3);
        imshow(combined);
        title(strcat("Grayscale Result of combined Sobel filtering"));
        subplot(2,4,4);
        imshow(image + sobelResult);
        title(strcat("Final Image"));
        
    elseif method == "Di Zenzo"
        
        image = im2double(image);% transform image to range [0 1]
        
        filterX = [-1,-2,-1;0,0,0;1,2,1];% initialize sobel's horizontal filter
        filterY = [-1,0,1;-2,0,2;-1,0,1];% initialize sobel's vertical filter
        
        plateR = image(:,:,1);% red plate of image
        plateG = image(:,:,2);% green plate of image
        plateB = image(:,:,3);% blue plate of image

        round_R_x = convolveFilterOnImage(plateR, filterX);%round(R)/round(x)
        round_G_x = convolveFilterOnImage(plateG, filterX);%round(G)/round(x)
        round_B_x = convolveFilterOnImage(plateB, filterX);%round(B)/round(x)
        
        round_R_y = convolveFilterOnImage(plateR, filterY);%round(R)/round(y)
        round_G_y = convolveFilterOnImage(plateG, filterY);%round(G)/round(y)
        round_B_y = convolveFilterOnImage(plateB, filterY);%round(B)/round(y)
        
        
        Gxx = round_R_x.^2 + round_G_x.^2 + round_B_x.^2;
        Gyy = round_R_y.^2 + round_G_y.^2 + round_B_y.^2;
        
        Gxy = round_R_x .* round_R_y + round_G_x .* round_G_y + round_B_x .* round_B_y;

        theta = atan(2.*Gxy ./ (Gxx - Gyy + eps))./2;
        Ftheta1 = sqrt(( (Gxx + Gyy) + ( (Gxx - Gyy) .* cos(2.*theta)) + (2.*Gxy.*sin(2.*theta)) ) ./ 2);

        %calculate Ftheta using theta + pi/2
        theta = theta + pi / 2;
        Ftheta2 = sqrt(( (Gxx + Gyy) + ( (Gxx - Gyy) .* cos(2.*theta)) + (2.*Gxy.*sin(2.*theta)) ) ./ 2);
               
        Ftheta = max(Ftheta1 , Ftheta2);
        
        dizenzoResult = zeros(size(image));%variable for saving result of laplacian
        dizenzoResult(:,:,1) = sqrt(round_R_x .^ 2 + round_R_y .^ 2);%Result of applying Di zenzo filter on red plate
        dizenzoResult(:,:,2) = sqrt(round_G_x .^ 2 + round_G_y .^ 2);%Result of applying Di zenzo filter on green plate
        dizenzoResult(:,:,3) = sqrt(round_B_x .^ 2 + round_B_y .^ 2);%Result of applying Di zenzo filter on blue plate
        
        subplot(234);
        imshow(dizenzoResult(:,:,1) , []);
        title("Result of applying Di zenzo filter on red plate");
        subplot(235);
        imshow(dizenzoResult(:,:,2) , []);
        title("Result of applying Di zenzo filter on green plate");
        subplot(236);
        imshow(dizenzoResult(:,:,3) , []);
        title("Result of applying Di zenzo filter on blue plate");
        subplot(242);
        imshow(dizenzoResult);
        title(strcat("Result of combined Di zenzo filtering"));
        subplot(243);
        imshow(Ftheta);
        title(strcat("Grayscale Result of combined Di zenzo filtering"));
        subplot(244);
        imshow(Ftheta + image, []);
        title("Final image");
    end
end