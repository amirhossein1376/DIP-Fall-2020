main
function main()
    readFromDefaults = input("(0) for using default points\n(1) for selecting points\n "); % user prompt
    colors = [0, 0.4470, 0.7410 ; 0.4660, 0.6740, 0.1880 ; 0.75, 0.75, 0];% default colors for diagram
    if readFromDefaults == 0 % we can use default points
        pointsDark = [0,1;64,1;128,0];%default points for peicewise 'dark' membership function
        pointsGray = [64,0;128,1;192,0];%default points for peicewise 'gray' membership function
        pointsBright = [128,0;192,1;255,1];%default points for peicewise 'bright' membership function

        outDark = 30;%value for 'dark' output
        outGray = 128;%value for 'gray' output
        outBright = 226;%value for 'bright' output
    elseif readFromDefaults == 1 % user shoud select points in graphical interface
        % ask user to select peicewise 'dark' membership function points
        f1 = figure('Name', 'Dark Piecewise Linear Function', 'NumberTitle', 'off');
        set(f1,'Pointer','arrow');
        drawnow;
        pointsDark = drawDiagram(1);

        % ask user to select peicewise 'gray' membership function points
        f2 = figure('Name', 'Gray Piecewise Linear Function', 'NumberTitle', 'off');
        set(f2,'Pointer','arrow');
        drawnow;
        pointsGray = drawDiagram(1);

        % ask user to select peicewise 'bright' membership function points
        f3 = figure('Name', 'Bright Piecewise Linear Function', 'NumberTitle', 'off');
        set(f3,'Pointer','arrow');
        drawnow;
        pointsBright = drawDiagram(1);

        f4 = figure('Name', 'Output Points', 'NumberTitle', 'off');
        set(f4,'Pointer','arrow');
        drawnow;
        outPoints = drawDiagram(0);% ask user to select 'dark','gray' and 'bright' output values
        outDark = outPoints(1,1);%value for 'dark' output
        outGray = outPoints(2,1);%value for 'gray' output
        outBright = outPoints(3,1);%value for 'bright' output

    end

    image = imread('image.tif');% read image

    darkMembershipMap = calculateMap(pointsDark);
    grayMembershipMap = calculateMap(pointsGray);
    brightMembershipMap = calculateMap(pointsBright);

    resultImage = image;
    for i = 1:size(image,1)
        for j = 1:size(image,2)
            currentPixIndex = image(i,j) + 1;
            res = (darkMembershipMap(currentPixIndex,1) * outDark + grayMembershipMap(currentPixIndex,1) * outGray +brightMembershipMap(currentPixIndex,1) * outBright) / (darkMembershipMap(currentPixIndex,1)+grayMembershipMap(currentPixIndex,1)+brightMembershipMap(currentPixIndex,1)) ;% calclulate final pixel gray level by equation(3-8-22) in the book
            resultImage(i,j) = uint8(res);
        end
    end

    %show results
    figure();
    subplot(131);
    imshow(image);
    title('Main Image');

    subplot(132);
    imshow(histeq(image));
    title('Equalized Image');

    subplot(133);
    imshow(resultImage);
    title('Fuzzy Enhanced Image');

    figure();
    subplot(221);
    histogram(image, 'Normalization', 'probability' , 'BinWidth' , 0.01 , 'NumBins', 256);
    xlim([0 255]);
    title('Main Image Histogram');

    subplot(222);
    histogram(histeq(image), 'Normalization', 'probability' , 'BinWidth' , 0.01 , 'NumBins', 256);
    xlim([0 255]);
    title('Equalized Image Histogram');

    %show historgram and fuzzy membership functions on it
    subplot(223);
    h0 = histogram(image, 'Normalization', 'probability' , 'BinWidth' , 0.01 , 'NumBins', 256);

    h1 = drawPoints(scalePoints(pointsDark) , colors(1,:));
    h2 = drawPoints(scalePoints(pointsGray) , colors(2,:));
    h3 = drawPoints(scalePoints(pointsBright) , colors(3,:));
    ylim(get(gca,'YLim') * 1.05)
    hold on;
    legend([h0 h1 h2 h3],{'Histogram' , 'Dark' , 'Gray' , 'Bright'});

    title('Fuzzy Functions on Main Histogram');

    subplot(224);
    histogram(resultImage, 'Normalization', 'probability' , 'BinWidth' , 0.01 , 'NumBins', 256);
    xlim([0 255]);
    title('Fuzzy Enhanced Image Histogram');

end
%this function scale points acoording to current yLimit of plot
function resultPoints = scalePoints(points)
    resultPoints = points;
    yLimits = get(gca,'YLim');% current histogram yLimit
    yMax = double(yLimits(2));% get maximum of y in the current histogram
    resultPoints(:,2) = resultPoints(:,2) .* yMax;
end