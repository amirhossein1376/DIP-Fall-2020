%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawLine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function asks user to draw his or her own histogram.                               %%%       
%%% input(s) : {image : given image that we want to appply histogram specification on it.   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawLine(x1 ,y1 ,x2 ,y2)
%    line([x1 x2], [y1 y2], 'LineWidth',0.5 ,'color' , rand(1,3));
    for i = x1:x2
        y = y1 + (y2 - y1) / (x2 - x1) * ( i - x1);
        line([i i], [0 y], 'LineWidth',0.5 ,'color' , 'red');
    end
end
