%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawPoints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function draws digram of given points                                          %%%
%%% input(s) : {points : given points }                                                 %%%  
%%% output(s) : {}                                                                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawPoints(points)
    xlim([0 255])
    ylim([0 255])
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    ax.XMinorGrid = 'on';
    ax.YMinorGrid = 'on';

    
    for i = 2:size(points , 1)
        x1 = points(i-1,1);
        y1 = points(i-1,2);
        x2 = points(i,1);
        y2 = points(i,2);
        line([x1 x2], [y1 y2], 'LineWidth',2 ,'color' , rand(1,3));
    end
end
