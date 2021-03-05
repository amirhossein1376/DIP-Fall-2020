clear all;
addpath("../Q2_99210294/");

main();

function main
    %read image
    imgRead = imread("Fig0323.tif");
    imageHeight = size(imgRead , 1);
    imageWidth = size(imgRead , 2);
    
    f0 = figure();
    imshow(imgRead);
    waitfor(f0);
    %change cursor shape in the figure
    f1 = figure();
    set(f1,'Pointer','arrow');
    drawnow;

    %ask user to draw histogram
    points = drawHistogram(imgRead);
    waitfor(f1);

    goalHistogram = normalizeSketchedHistogram(points);

    %calculate histogram equalization(cumulate hist + normalize + *255) on image
    s = uint8(calculateEqualizationMap(imgRead , calculateImageHistogram(imgRead)));% r = image , s = T(r);

    v = round((255) * cumsum(goalHistogram));% v = G(z) , cumulate user histogram

    mapStoZ = calculateMap(s, v);

    imgResult = uint8(zeros(size(imgRead)));
    for i = 1:imageHeight
        for j = 1:imageWidth
            imgResult(i,j) = mapStoZ(s(imgRead(i,j) + 1) + 1);
        end
    end


    %show results
    figure();
    subplot(221)
    imshow(imgRead);
    subplot(222)
    %drawPoints(points);
    plot(0:255 , goalHistogram');
    xlim([0 255])
    subplot(223)
    imshow(imgResult);
    subplot(224)
    imhist(imgResult);
    
end

function goalHistogram = normalizeSketchedHistogram(points)
    %convert histogram of sketched lines to all gray levels
    goalHistogram = double(zeros(1 , 256));
    for i = 1:256
        for k = 2:size(points , 1)
            x1 = points(k-1,1);
            x2 = points(k,1);
            if x1 <= i && i <= x2
                y1 = points(k-1,2);
                y2 = points(k,2);
                goalHistogram(1 ,i) = y1 + (y2 - y1) / (x2 - x1) * ( i - x1);
                break
            end
        end
    end
    goalHistogram = goalHistogram * (1 / sum(sum(goalHistogram))); % normalize created historgram( sum(sum(hist)) should be equal to 1))
end

function mapStoZ = calculateMap(s ,v)
    mapStoZ = uint8(zeros(1,256));
    for k = 1:256
        nearest = 1;
        min = 256;
        for q = 1:256
            if abs(double(v(1 , q)) - double(s(1, k))) < min
                min = abs(double(v(1 , q)) - double(s(1, k)));
                nearest = q;
            end
        end
            mapStoZ(1 , s(1,k) + 1) = nearest;
    end
end