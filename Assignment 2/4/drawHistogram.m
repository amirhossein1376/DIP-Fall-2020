%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawHistogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function asks user to draw his or her own histogram.                               %%%       
%%% input(s) : {image : given image that we want to appply histogram specification on it.}  %%% 
%%% output(s) : {points : selected points by user}                                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = drawHistogram(image)
    %draw histogram of given image
    h = histogram(image , 'Normalization', 'probability' , 'BinWidth' , 0.01 , 'NumBins', 256);
    h.ButtonDownFcn = @histClickCallback;
    
    points = [];
    initializeView()
    
    function initializeView()
        xlim([0 255])
        ylim([0 1])
        
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
%                 xLast = points(size(points , 1) , 1);
%                 yLast = points(size(points , 1) , 2);
%                 if xLast < 255
%                     xInput = 255;
%                     yInput = 0;
%                     drawLine(xLast , yLast, xInput , yInput);
%                     points = [points ; [xInput , yInput]];
%                 end
                % wait for 0.3 second and then close the figure
                pause(0.3);
                close(gcf);
        end
    end
    
    %this function is triggered when user clicks on histogram
    function histClickCallback(src,event)
        clickPosition = event.IntersectionPoint;
        handleClick(clickPosition);
    end
    %this function is triggered when user clicks on plot
    function clickCallback(obj,event)
        clickPosition=get(obj,'CurrentPoint');
        handleClick(clickPosition);
    end
    
    function handleClick(clickPosition)
        xInput=clickPosition(1,1);
        yInput=clickPosition(1,2);
        if size(points , 1) == 0
            %this is first point
            points = [xInput , yInput];
        else
            xLast = points(size(points , 1) , 1);
            yLast = points(size(points , 1) , 2);
            if xLast < xInput
                drawLine(xLast , yLast , xInput , yInput);
                points = [points ; [xInput , yInput]];
            end
        end
        disp(points);
        hold on;
        plot(xInput , yInput , 'o');

    end

    function mouseMoveCallback (object, eventdata)
        C = get (gca, 'CurrentPoint');
        title(gca, {['(X) = (', num2str(floor(C(1,1))) , ')'] , ['(Y) = (', num2str(C(1,2)) , ')']});
    end
uiwait();
end