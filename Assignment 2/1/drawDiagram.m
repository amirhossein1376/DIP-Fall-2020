%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawDiagram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function asks user to draw a diagram                                            %%%
%%% input(s) : {saveAddress : a property for saving selected points to use in future}    %%%  
%%% output(s) : {points : selected poionts added by points (0,0) and (255,255) }         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = drawDiagram(saveAddress)
    points = [0,0];
    uiInit();

    %initializing axes
    function uiInit

        xlim([0 255])
        ylim([0 255])

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
    % this function is triggered when "Done" button is turned on
    function btnDoneCallback(src,event)
        switch src.Value
            case 'on'
                xInput = 255;
                yInput = 255;
                xLast = points(size(points , 1) , 1);
                yLast = points(size(points , 1) , 2);
                line([xLast xInput], [yLast yInput], 'LineWidth',2 ,'color' , rand(1,3));
                pause(0.3);
                close(gcf);

                points = [points ; [xInput , yInput]];
                save(saveAddress , 'points');
        end
    end
    % this function is triggered when mouse is clicked
    function clickCallback(obj,event)
        cp=get(obj,'CurrentPoint');
        xInput=cp(1,1);
        yInput=cp(1,2);
        xLast = points(size(points , 1) , 1);
        yLast = points(size(points , 1) , 2);
        if xLast <= xInput
            line([xLast xInput], [yLast yInput], 'LineWidth',2 ,'color' , rand(1,3));
            points = [points ; [xInput , yInput]];
        end
    end

    uiwait();% wait for figure to close
end