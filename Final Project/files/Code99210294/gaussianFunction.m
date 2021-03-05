%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% gaussianFunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    This function returns gaussian filter with given size and parameters                       
    input(s) : {height : height of filter ,
                width : width of filter ,
                sigma : standard deviation}   

    output(s) : {f : created filter }                                                               
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = gaussianFunction(height , width , sigma)
    x = 1:width;
    y = 1:height;
    [Y,X] = meshgrid(x,y);
    f = exp(-1 .* (X .^ 2 + Y .^ 2) ./ (sigma .^ 2));%gaussian filter's formula
    lambda = 1 / sum(sum(f));
    f = lambda .* f;%multiply filter by coefficient to make the sum of the filter elements equals 1
end

