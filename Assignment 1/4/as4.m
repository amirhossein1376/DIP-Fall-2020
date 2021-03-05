% clear all variables from environment
clear all;

baseImage = rgb2gray(imread('city.jpg'));%read base image
baseHeight = size(baseImage , 1);%calculate base image height
baseWidth = size(baseImage , 2);%calculate base image width

shearParam = input('Please Enter shear parameter: ');%read shear parameter from input

shearMatrix = [1, shearParam, 0; 0, 1, 0; 0, 0, 1];
tform = maketform('affine',shearMatrix);%transfrom base image

inputImage = uint8(imtransform(baseImage,tform));%save result image in grayscale
inputHeight = size(inputImage , 1);%calculate input image height
inputWidth = size(inputImage , 2);%calculate input image width

prompt = input('set control points ? ');

if prompt == 1
    [selectedMovingPoints,selectedFixedPoints] = cpselect(inputImage, baseImage , 'Wait' , true);%control points selection
    fixedPoints = selectedFixedPoints;
    movingPoints = selectedMovingPoints;
    save('points' , 'fixedPoints' , 'movingPoints');%save points in points.mat file for further use
end

load('points.mat');%load contol points

fixedPoints = double(int32(fixedPoints))';% convert fixed points to int (to integer points) then double (for using in arithmetic operations)
movingPoints = double(int32(movingPoints))';% convert moving points to int (to integer points) then double (for using in arithmetic operations)


%vectorize 2 eqations
F = @(c) [fixedPoints - ([c(1); c(5)] * movingPoints(1, :) ...
    + [c(2); c(6)] * movingPoints(2 , :) ...
    + [c(3);c(7)] * (movingPoints(1, :) .* movingPoints(2 ,:)) ...
    + [c(4) , c(4), c(4) ,c(4);c(8) , c(8), c(8) ,c(8)])];

InitialGuess = zeros(8,1);
c = fsolve(F , InitialGuess); % solve 8 equations



%-------------solve equations with second method-------------% 
%{
syms c1 c2 c3 c4 c5 c6 c7 c8
equation11 = fixedPoints(1,1) - (c1 * movingPoints(1,1) + c2 * movingPoints(2,1) + c3 * movingPoints(1,1) * movingPoints(2,1) + c4);
equation12 = fixedPoints(2,1) - (c5 * movingPoints(1,1) + c6 * movingPoints(2,1) + c7 * movingPoints(1,1) * movingPoints(2,1) + c8);

equation21 = fixedPoints(1,2) - (c1 * movingPoints(1,2) + c2 * movingPoints(2,2) + c3 * movingPoints(1,2) * movingPoints(2,2) + c4);
equation22 = fixedPoints(2,2) - (c5 * movingPoints(1,2) + c6 * movingPoints(2,2) + c7 * movingPoints(1,2) * movingPoints(2,2) + c8);

equation31 = fixedPoints(1,3) - (c1 * movingPoints(1,3) + c2 * movingPoints(2,3) + c3 * movingPoints(1,3) * movingPoints(2,3) + c4);
equation32 = fixedPoints(2,3) - (c5 * movingPoints(1,3) + c6 * movingPoints(2,3) + c7 * movingPoints(1,3) * movingPoints(2,3) + c8);

equation41 = fixedPoints(1,4) - (c1 * movingPoints(1,4) + c2 * movingPoints(2,4) + c3 * movingPoints(1,4) * movingPoints(2,4) + c4);
equation42 = fixedPoints(2,4) - (c5 * movingPoints(1,4) + c6 * movingPoints(2,4) + c7 * movingPoints(1,4) * movingPoints(2,4) + c8);
sol = solve(equation11, equation12, equation21, equation22, equation31, equation32, equation41, equation42);
c = [sol.c1; sol.c2; sol.c3; sol.c4; sol.c5; sol.c6; sol.c7; sol.c8];
%}

c = double(c);% convert c values to double

%{
%-------------test correctness of solution-------------% 

disp (fixedPoints(: , 1) - ([c(1); c(5)] * movingPoints(1,1) + [c(2); c(6)] * movingPoints(2 , 1) + [c(3);c(7)] *(movingPoints(1, 1) .* movingPoints(2 ,1)) + [c(4);c(8)]));
disp(c);
%}


registeredImage = uint8(zeros(size(baseImage))); %create registered image with size equal to base image


%{
−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− → v
|
|
|
|
|
|
|
|
|
↓
w

%}


for v = 1:inputWidth
    for w = 1:inputHeight
        x = round(c(1) * v + c(2) * w + c(3) * v * w + c(4)) ;% calculate x 
        y = round(c(5) * v + c(6) * w + c(7) * v * w + c(8)) ;% calculate y
        if x >= 1 && x <= baseWidth && y >=1 && y <= baseHeight % check boundaries
            registeredImage(y, x) = inputImage(w , v); % the coordinates of the matrix are the opposite of the coordinates of the image
        end        
    end
end

% plot base image with fixedPoints on it
figure;
subplot(221);
imshow(baseImage);
axis on
hold on;
for i= 1:4
    plot(fixedPoints(1,i),fixedPoints(2,i), 'r.', 'MarkerSize', 10, 'LineWidth', 1);
end

% plot input image with movingPoints on it
subplot(222);
imshow(inputImage);
axis on
hold on;
for i= 1:4
    plot(movingPoints(1,i),movingPoints(2,i), 'r.', 'MarkerSize', 10, 'LineWidth', 1);
end

% plot registered image with transformed movingPoints on it
subplot(223);
imshow(registeredImage);
axis on
hold on;
for i= 1:4
    v = movingPoints(1,i);
    w = movingPoints(2,i);
    x = round(c(1) * v + c(2) * w + c(3) * v * w + c(4)) ;
    y = round(c(5) * v + c(6) * w + c(7) * v * w + c(8)) ;
    
    plot(x,y, 'r.', 'MarkerSize', 10, 'LineWidth', 1);
end

% plot difference of base and registered image        
subplot(224);
imshow(imabsdiff(registeredImage , baseImage));
