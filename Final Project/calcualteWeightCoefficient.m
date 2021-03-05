%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calcualteWeightCoefficient %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function weight coeffiencts of fusing using eigen vectors
    input(s) : {eigenVectors : eigen vectors of covariance matrix,
                p : index of maximum eigen value}

    output(s) : {w1 : weight of first image in fusing process,
                 w2 : weight of second image in fusing process}
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w1 , w2] = calcualteWeightCoefficient(eigenVectors , p)
    e = eigenVectors(:,p);
    w1 = e(1) / (e(1) + e(2));
    w2 = e(2) / (e(1) + e(2));
end