clear all;
%defaultPnts1 = [0,0;96,32;160,224;255,255]; 
%defaultPnts2 = [0,0;75,75;75,204;136,204;136,136;255,255];
%defaultPnts3 = [0,0;75,75;75,20;136,20;136,136;255,255];
main();

function main
    imgRead1 = imread("fig0310.tif");
    imgRead2 = imread("fig0312.tif");
    figure('Name', 'Images', 'NumberTitle', 'off');
    subplot(121);
    imshow(imgRead1);
    subplot(122)
    imshow(imgRead2);
    %creating two diagrams
    figure('Name', 'First Diagram', 'NumberTitle', 'off');
    points1 = drawDiagram('pointsDefault1');
    figure('Name', 'Second Diagram', 'NumberTitle', 'off');
    points2 = drawDiagram('pointsDefault2');
    
    %show main images
    h = figure();
    set(h, 'Position', [300, 900, 820, 400]);   
    subplot(121);
    imshow(imgRead1);
    subplot(122);
    imshow(imgRead2);
    
    %show two diagrams
    h = figure();
    set(h, 'Position', [300, 400, 820, 400]);   
    subplot(121);
    drawPoints(points1);
    subplot(122);
    drawPoints(points2);
    
    %transform and show two images
    h = figure();
    set(h, 'Position', [300, 100, 820, 400]);   
    subplot(121);
    imgRes1 = applyTransform(imgRead1 , points1);
    imshow(imgRes1);
    subplot(122);
    imgRes2 = applyTransform(imgRead2 , points2);
    imshow(imgRes2);
end