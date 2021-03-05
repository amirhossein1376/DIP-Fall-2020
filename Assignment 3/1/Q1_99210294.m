main % calling main function of Q1
function main()
    inputImage = imread("img1.tif"); % read image
    filterImage(inputImage , 'Mean'); % apply mean filters on image
    filterImage(inputImage , 'Sobel'); % apply sobel filter on image
    filterImage(inputImage , 'Prewitt'); % apply prewitt filter on image
end
