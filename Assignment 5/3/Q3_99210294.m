clear all;
main;
function main()
    image = imread("airplane04.tif");% read drawed binary pattern image
    x = extractObjectPixels(image);% extract frontiers of airplane that are black

    n = size(x,2);% dimension of x
    [mX , cX] = calc(x);% mean and covariance of our points
    [e,lambda]  = eig(cX);% eigenvalues and eigenvectors of covariance matrix

    dia = eye(n);
    lambda = lambda .* dia;%extract lambdas from diagonal matrix lambda

    [~,idx] = sort(lambda(lambda > 0) , 'descend');%sort lambdas and recive index transformations
    sortede = e(:,idx);% sort e by lambda values descending

    A = sortede';% calculate matrix A as mentoined in text book
    y = (x - repmat(mX' , size(x,1) , 1)) * A';% caluclate our new axis

    figure;

    subplot(231);
    drawPoints(x(:,1) , x(:,2) , 0 , size(image,1) , 0 , size(image,2));%draw xs
    title("An object")
    
    subplot(233);
    drawPoints(x(:,1) , x(:,2) , 0 , size(image,1) , 0 , size(image,2));%draw xs
    hold on;
    axisLength = (12/30)*min(size(image,1),size(image,2));
    quiver(mX(1),mX(2),axisLength*e(1,1),axisLength*e(1,2),0,'LineWidth',2,'Color','red');
    quiver(mX(1),mX(2),axisLength*e(2,1),axisLength*e(2,2),0,'LineWidth',2,'Color','green');
    viscircles([mX(1) mX(2)],5 , 'color' , 'w');
    legend('Center of gravity','e2' , 'e1');
    title("An object with eigenvectors")

    subplot(234);
    a = size(image,1) / 2;
    b = size(image,2) / 2;
    drawPoints(y(:,1) , y(:,2) , -1*a , 1*a , -1*b , 1*b);%draw ys
    hold on;
    quiver(0,-2*b/3,0,4*b/3,0,'LineWidth',2,'Color','red');
    quiver(-2*a/3,0,4*a/3,0,0,'LineWidth',2,'Color','green');
    hold on;
    viscircles([0 0],5 , 'color' ,'w');
    legend('(0,0)','y2' , 'y1');
    title("Transformed object")
    
    subplot(236);
    newY = y - repmat(min(y) , size(y,1) , 1);
    drawPoints(newY(:,1) , newY(:,2) , -100, size(image,1), -100, size(image,2));%draw ys
    hold on;
    viscircles(mean(newY),10 , 'color' ,'w');
    legend('Center of gravity');
    title("Translated transformed object")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calc %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function calculates mean and covariance of given matrix                                    %%%
%%% input(s) : {x : given matrix for performin operations }                                         %%%  
%%% output(s) : {mX : mean of columns of x , Cx : covariance matrix of x}                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [mX , Cx] = calc(x)
    mX = mean(x)';
    Cx = cov(x);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% extractObjectPixels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function extracts pixels of object according to real numbers axis                                                  %%%
%%% input(s) : {image : given image }                                                                                       %%%  
%%% output(s) : {x : x  = [x1 x2] that are x-axis and y-axis of black points in the image}                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = extractObjectPixels(image)
    [x1,x2] = find(image == 0);
    changedX1 = size(image,1) - x1;
    x = [x2 , changedX1];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawPoints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function plots given points                                                                                        %%%
%%% input(s) : {data1 : x-axis of points , data2 : y-axis of points , $other_parameters : min and max limit of x and y axis}%%%  
%%% output(s) : {resultImage : result of multiplication}                                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawPoints(data1 , data2 , minY , maxY , minX , maxX)
    swarmchart(data1,data2,5 , 'black');
    xlim([minX maxX]);
    ylim([minY maxY]);
end
