load('urls.mat')

% make labels
m = zeros(1,90);
lab = [m+1 m+2 m+3];

mFs = getMinFs(Au);
A = [];
for j=1:size(Au,1) 
    [y,Fs] = webread(Au(j,1));
    % stereo -> mono
    if size(y,2)==2
        y = (y(:,1)+y(:,2))/2;
    end
    y = downsample(y, round(Fs/mFs));
    % take 3 samples, (roughly) 5 sec each
    A = [A; 
        y(30*mFs:35*mFs,:)';
        y(45*mFs:50*mFs,:)';
        y(60*mFs:65*mFs,:)'];
end

mFs = getMinFs(Bu);
B = [];
for j=87:size(Bu,1) 
    [y,Fs] = webread(Bu(j,1));
    % stereo -> mono
    if size(y,2)==2
        y = (y(:,1)+y(:,2))/2;
    end
    % downsample
    y = downsample(y, round(Fs/mFs));
    Fs = Fs/2;
    % take 3 samples, 5 sec each
    B = [B; 
        y(30*mFs:35*mFs,:)';
        y(45*mFs:50*mFs,:)';
        y(60*mFs:65*mFs,:)'];
end

mFs = getMinFs(Cu);
C = [];
for j=1:size(Cu,1) 
    [y,Fs] = webread(Cu(j,1));
    % stereo -> mono
    if size(y,2)==2
        y = (y(:,1)+y(:,2))/2;
    end
    % downsample
    y = downsample(y, round(Fs/mFs));
    Fs = Fs/2;
    % take 3 samples, 5 sec each
    C = [C; 
        y(30*mFs:35*mFs,:)';
        y(45*mFs:50*mFs,:)';
        y(60*mFs:65*mFs,:)'];
end

A = A'; B = B'; C = C'; % each col is a song now
Fs=mFs;
save('data.mat','A','B','C','lab','Fs')

function [minFs] = getMinFs(U)
    [~,minFs] = webread(U(1));
    for j=2:size(U,1)
        [~,Fs] = webread(U(j));
        if Fs < minFs
            minFs = Fs;
        end
    end
end