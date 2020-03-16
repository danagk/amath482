function pos = getPos(video)
    pos = zeros(2,size(video,4));
    imshow(video(:,:,:,1));
    pos(:,1) = int16(ginput(1));
    for j = 2:size(video,4)
        lastBox = getBox(video(:,:,:,j-1), pos(:,j-1), 20, 20);
        pos(:,j) = tracker(video(:,:,:,j), lastBox, pos(:,j-1), 20, 20);
    end
end