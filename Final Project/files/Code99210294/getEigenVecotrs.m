%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getEigenVecotrs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function calcualtes eigen values and vector of given covariance matrix and index of maximun eigen value
    input(s) : {C : given covarrianve matrix}

    output(s) : {eigenVectors : eigen vectors,
                 p : index of maximum eigen value}
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [eigenVectors,p] = getEigenVecotrs(C)
    [eigenVectors,eigenValues] = eig(C);%get eigen vectors of covariance matrix

    if eigenValues(1,1) > eigenValues(2,2)
        p=1;
    else
        p=2;
    end
     % now p is index of row of maximum eigen value
end