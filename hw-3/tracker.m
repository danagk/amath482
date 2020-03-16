function pos = tracker(frame, lastBox, prev, boxR, searchR)
    min_error = 1e10; % larger than any possible error
    minX = max(boxR+1, prev(1)-searchR);
    maxX = min(size(frame,2)-boxR, prev(1)+searchR);
    minY = max(boxR+1, prev(2)-searchR);
    maxY = min(size(frame,1)-boxR, prev(2)+searchR);
    for x = minX:maxX
        for y = minY:maxY
            % find best new box
            newBox = frame((y-boxR):(y+boxR),(x-boxR):(x+boxR),:);
            error = sum((int16(newBox) - int16(lastBox)).^2,'all');
            if error < min_error
               min_error = error;
               min_point = [x;y];
            end
        end
    end
    pos = min_point;
end