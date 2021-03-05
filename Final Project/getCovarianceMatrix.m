%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getCovarianceMatrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function calcualtes covariance matrix of given images
    input(s) : {image1 : first image, 
                image2 : secong image}

    output(s) : {C : covariance matrix}
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C = getCovarianceMatrix(image1 , image2)
    X1 = image1(:);%convert first enhanced image to vector
    X2 = image2(:);%convert second enhanced image to vector
    X = [X1 X2];%join two vectors in n * 2 matrix (n = height(image) * width(image))
    C = cov(X);%calcualte covariance matrix of X
end