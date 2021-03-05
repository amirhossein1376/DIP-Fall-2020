%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    rotateMatrix180    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function rotates given matrix 180 degrees                           %%%       
%%% input(s) : {mat : given matrix}                                          %%%  
%%% output(s) : {changedMat : rotated matrix}                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function changedMat = rotateMatrix180(mat)
    h = size(mat,1);% height of matrix
    w = size(mat,2);% width of matrix
    changedMat = zeros(size(mat));% returned variable
    for i = 1:h % move vertical on matrix
        for j = 1:w % move horizontal on matrix
            changedMat(i,j)=mat(h+1-i,w+1-j);% calculate rotated position if (i,j)
        end
    end
end