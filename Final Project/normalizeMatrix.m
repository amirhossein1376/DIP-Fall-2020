%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalizeMatrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function scale matrix values to range [minVal maxVal]                       
    input(s) : {X : given matrix ,
                minVal : start of range ,
                maxVal : end of range}  

    output(s) : {result : result of normalization}                                                               
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =  normalizeMatrix(X , minVal , maxVal)
    X = X - min(min(X));
    result = minVal + (maxVal-minVal)* X / max(max(X));
end