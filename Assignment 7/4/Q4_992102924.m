clear all;
close all;

image = double(imread("sti.tif"));% read image

f_hat = partA(double(image) , 1);% calcualte f_hat
[codedArray , comp] = partB(f_hat);% code f_hat using huffman coding
decodedMat = partC(size(image) , codedArray , comp);% decode image
partD(image , f_hat , decodedMat);%compute the entropy of original and compressed image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates f_hat according to equation 8.2-34 as displays 4 images like figure 8.34                          %%%
%%% input(s) : {f : given grayscale image , alpha : parameter of f_hat}                                                        %%%  
%%% output(s) : {f_hat : calculate value for f_hat}                                                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f_hat = partA(f , alpha)
    f_hat = zeros(size(f));
    
    for i = 1:size(f , 1)
        for j = 2:size(f , 2)
            f_hat(i,j) = round(alpha .* f(i , j-1));%calculate f_hat accroding to equation 8.2-34
        end
    end
    
    predError = f - f_hat;% prediction error

    figure();
    subplot(221);
    imshow(f , []);
    title("The original image");

    subplot(222);
    histogram(f , 'Normalization' , 'probability' , 'NumBins' , 256);
    title(["Histogram of the image",strcat("STD : " , num2str(std(f(:))) , " ENTROPTHY : " , num2str(entropy(uint8(f))))]);

    subplot(223);
    imshow(predError , []);
    title("The prediction error");

    subplot(224);
    histogram(predError , 'Normalization' , 'probability' , 'NumBins' , 256);
    doublePredError = normalizeMatrix(predError);
    title(["The histogram of prediction error",strcat("STD : " , num2str(std(doublePredError(:))) , " ENTROPTHY : " , num2str(entropy(uint8(doublePredError))))]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates encodes image with huffman coding method                                                          %%%
%%% input(s) : {image : given grayscale image }                                                                                %%%  
%%% output(s) : {dict : huffman dictionary , comp : binary values of coded image}                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dict , codedArray] = partB(image)
    imageVec = double(image(:));%conver image to vector
    [p,symbols]= hist(imageVec,unique(imageVec));%calcualte the number of times each gray level appeared in the image
    p=p/sum(p);% convert p to probability domain
    %encode image with huffman coding
    [dict,~] = huffmandict(symbols,p);
    codedArray = huffmanenco(imageVec,dict);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function decoodes given array with given huffman dictionary                                                           %%%
%%% input(s) : {imageSize : size of image , dict : huffman dictionary , codedArray : coded image}                              %%%  
%%% output(s) : {decodedMat : image decoded from given parameters}                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function decodedMat = partC(imageSize , dict , codedArray)
    deco = huffmandeco(codedArray, dict);%decode array
    decodedMat = reshape(deco , imageSize);%reshape arrray to be like an image
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% partD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function displays the original, compressed and the difference images.                                                 %%%
%%% input(s) : {originalImage , transformedImage : f_hat , compressedImage}                                                   %%%  
%%% output(s) : {}                                                                                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function partD(originalImage , transformedImage , compressedImage)
    originalImage = uint8(normalizeMatrix(originalImage));% change type of original image to unsigned integer
    transformedImage = uint8(normalizeMatrix(transformedImage));% change type of original image to unsigned integer
    compressedImage = uint8(normalizeMatrix(compressedImage));% change type of compressed image to unsigned integer
    
    originalImageEntropy = entropy(originalImage);%calcualte entropy of original image
    transformedImageEntropy = entropy(transformedImage);%calcualte entropy of original image
    compressedImageEntropy = entropy(compressedImage);%calcualte entropy of compressed image
    
    
    figure();
    
    subplot(131);
    imshow(compressedImage , []);
    title(["The compressed image",strcat("Entropy : " , num2str(compressedImageEntropy))])

    subplot(232);
    imshow(originalImage , []);
    title(["The original image",strcat("Entropy : " , num2str(originalImageEntropy))])

    subplot(235);
    imshow(transformedImage , []);
    title(["The transformed image (f hat)",strcat("Entropy : " , num2str(transformedImageEntropy))])

    
    subplot(233);
    imshow(imabsdiff(originalImage,compressedImage), []);
    title("difference")

    subplot(236);
    imshow(imabsdiff(transformedImage,compressedImage), []);
    title("difference")
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% entropy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calcualtes entropy of image                                                 %%%
%%% input(s) : {img : given image}                                                            %%%  
%%% output(s) : {ent : calcualted entropy}                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ent = entropy(img)
    p = zeros(256 , 1);% probability of apearing each gray level in the image
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            p(img(i,j) + 1) = p(img(i,j) + 1) + 1; 
        end
    end
    p = p ./ (height(img) * width(img));
    p = p + eps;
    
    ent = -1 * sum(sum(p .* log2(p)));%calculate entropy according to equation 8.1-7
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalizeMatrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function scale matrix values to range [0 255]                                        %%%
%%% input(s) : {X : given matrix}                                                             %%%  
%%% output(s) : {result : result of normalization}                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X , minVal , maxVal)
    if nargin<2
      minVal = 0;
      maxVal = 255;
    end
    X = X - min(min(X));
    result = minVal + (maxVal-minVal)* X / max(max(X));
end

