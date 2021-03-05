%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculateMap %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function project every bin of historgram to corresponding lines specified by points                                     %%%
%%% input(s) : {points : givent points corresponding to drawed lines}                                                            %%%  
%%% output(s) : {map : a vector of size 256 * 1 that we use it to map gray levels to corresponding points on the drawed lines}   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function map = calculateMap(points)
    map = zeros(256,1);% vector for saving maps
    for currentLevel = 0:255 % for each gray level do :
        for k = 2:size(points , 1) % find 2 succesive points that this gray level is on the line crosses from this two points
            x1 = points(k-1,1);
            x2 = points(k,1);
            if x1 == x2 && x1 == currentLevel
                map(curretLevel + 1 ,1) = map(currentLevel);
            elseif x1 <= currentLevel && currentLevel <= x2 % current level's corresponding points is on this line : (x1,y1)--->(x2,y2)
                y1 = points(k-1,2);
                y2 = points(k,2);
                map(currentLevel+1 ,1) = y1 + (y2 - y1) / (x2 - x1) * ( currentLevel - x1);%find corresponding point on that line
                break
            end
        end
    end
end