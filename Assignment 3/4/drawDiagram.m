%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawHistogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function asks user to draw his or her own histogram.                                           %%%       
%%% input(s) : {drawLine : a boolean varialbe that if is 1 then we create line between each two point}  %%% 
%%% output(s) : {points : selected points by user}                                                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = drawDiagram(drawLine)
    color = rand(1,3);
    points = [];
    initializeView()
    
    function initializeView()
        xlim([0 255])
        ylim([0 1.05])
        
        set(gca, 'xtick', [0 25 50 75 100 125 150 175 200 225 255])
        set (gcf, 'WindowButtonMotionFcn', @mouseMoveCallback); % catch cursos moves
        
        %init axes
        ax = gca;
        ax.XGrid = 'on';
        ax.YGrid = 'on';
        ax.XMinorGrid = 'on';
        ax.YMinorGrid = 'on';
        ax.ButtonDownFcn = @clickCallback;
        
        %init "Done" button
        tb = axtoolbar(ax,{'zoomin','zoomout','restoreview'});
        btn = axtoolbarbtn(tb,'state');
        btn.Icon = 'icon.png';
        btn.Tooltip = 'Done';
        btn.ValueChangedFcn = @btnDoneCallback;
    end

    function btnDoneCallback(src,event)
        switch src.Value
            case 'on'
                pause(0.3);
                close(gcf);
        end
    end
    
    %this function is triggered when user clicks on plot
    function clickCallback(obj,event)
        clickPosition=get(obj,'CurrentPoint');
        xInput=max(min(round(clickPosition(1,1)),255),0);
        yInput=max(min(round(clickPosition(1,2),2),1),0);
        if size(points , 1) == 0
            %this is first point
            points = [xInput , yInput];
        else
            xLast = points(size(points , 1) , 1);
            yLast = points(size(points , 1) , 2);
            if xLast < xInput
                if drawLine
                    line([xLast xInput], [yLast yInput], 'LineWidth',2 ,'color' , color);
                end
                points = [points ; [xInput , yInput]];
            end
        end
        disp(points);
        hold on;
        plot(xInput , yInput , 'o');
    end
    
    function mouseMoveCallback (object, eventdata)
        C = get (gca, 'CurrentPoint');
        title(gca, {['(X) = (', num2str(max(min(round(C(1,1)) , 255),0)) , ')'] , ['(Y) = (', num2str(max(min(round(C(1,2),2),1),0)) , ')']});
    end
uiwait();
end