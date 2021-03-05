%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawPoints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function draws digram of given points                                          %%%
%%% input(s) : {points : given points, color : given color for lines }                  %%%  
%%% output(s) : {}                                                                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = drawPoints(points , color)
    xlim([0 255])
    yticklabels([])

    flag = 0;
    for i = 2:size(points , 1)
        x1 = points(i-1,1);
        y1 = points(i-1,2);
        x2 = points(i,1);
        y2 = points(i,2);
        if flag == 0
            h = line([x1 x2], [y1 y2], 'LineWidth',2 ,'color' , color);
            flag = 1;
        else
            hold on;
            line([x1 x2], [y1 y2], 'LineWidth',2 ,'color' , color);
        end
    end
end
