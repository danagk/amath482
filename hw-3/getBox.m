function box = getBox(frame, prev, boxR, searchR)
    minX = max(boxR+1, prev(1)-searchR);
    maxX = min(size(frame,2)-boxR, prev(1)+searchR);
    
    minY = max(boxR+1, prev(2)-searchR);
    maxY = min(size(frame,1)-boxR, prev(2)+searchR);
    
    box = frame(minY:maxY,minX:maxX,:);
end