clear all;

image = rgb2gray(imread('picture.jpg')); % read image
imageHeight = size(image , 1);
imageWidth = size(image , 2);

%------------------- sampling -------------------%
sampleHeight = 512;
sampleWidth = 512;
sampleImage = uint8(zeros(sampleHeight,sampleWidth)); % create matrix of zeros for saving result image

heightPortion =imageHeight / sampleHeight;
widthPortion = imageWidth / sampleWidth;

for i= 1:sampleHeight
    x = ceil(heightPortion * (i - 1) + 1);
    for j = 1:sampleHeight
        y = ceil(widthPortion * (j - 1) + 1); % (x,y) is corresponding point of sampleImage(i,j) in main image
        sum = 0;
        count = 0;
        %find average of ceil(heightPortion) * ceil(widthPortion) matrix start from (x,y)
        for m = x:x + ceil(heightPortion) - 1
            for n = y:y + ceil(widthPortion) - 1
                if m <= imageHeight && n <= imageWidth %check boundaries
                    sum = sum + int32(image(m,n));
                    count = count +1 ;
                end
            end
        end
        if count ~= 0
            sampleImage(i , j) = uint8(sum / count); % calculate average
        end
    end
end


%------------------- Quantization -------------------%
ql = [256, 128, 64, 32, 2];
quantizedImage = uint8(zeros(size(sampleImage))); % create matrix of zeros for saving quantized image
figure;
for k = 1:8
    quantizationLevels = 2^k;
    for x = 1:sampleHeight
        for y = 1:sampleWidth
            quantizedImage(x,y) = uint8(floor(double(sampleImage(x,y)) / (2^8 / quantizationLevels)) * (2^8 / quantizationLevels) + (2^7 / quantizationLevels));
        end
    end
    subplot(2,4,k);
    imshow(quantizedImage);
    title(strcat(int2str(quantizationLevels) ,' Levels'))
end

quantizedImage = uint8(zeros(size(sampleImage)));
figure;
for k = 1:8
    quantizationLevels = 2^k;
    firstInterval = 0;
    lastInterval = floor(255 / (2^8 / quantizationLevels));
    for x = 1:sampleHeight
        for y = 1:sampleWidth
            interval = floor(double(sampleImage(x,y)) / (2^8 / quantizationLevels));
            if interval == lastInterval
                quantizedImage(x,y) = uint8(255);
            elseif interval == firstInterval
                quantizedImage(x,y) = uint8(0);
            else
                quantizedImage(x,y) = uint8(interval * (2^8 / quantizationLevels) + (2^7 / quantizationLevels));
            end
        end
    end
    subplot(2,4,k);
    imshow(quantizedImage);
    title(strcat(int2str(quantizationLevels) ,' Levels'))
end


quantizedImage = uint8(zeros(size(sampleImage)));
figure;
for k = 1:8
    quantizationLevels = 2^k;
    for x = 1:sampleHeight
        for y = 1:sampleWidth
            quantizedImage(x,y) = uint8(floor(double(sampleImage(x,y)) / (2^8) * (quantizationLevels)));
        end
    end
    subplot(2,4,k);
    imshow(quantizedImage , [0 (quantizationLevels-1)]);
    title(strcat(int2str(quantizationLevels) ,' Levels'))
end
