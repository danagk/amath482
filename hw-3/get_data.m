%% create position vectors
% generate initial vectors
load('cam1_1.mat');
pos1_1 = getPos(vidFrames1_1);
load('cam2_1.mat');
pos2_1 = getPos(vidFrames2_1);
load('cam3_1.mat');
pos3_1 = getPos(vidFrames3_1);

load('cam1_2.mat');
pos1_2 = getPos(vidFrames1_2);
load('cam2_2.mat');
pos2_2 = getPos(vidFrames2_2);
load('cam3_2.mat');
pos3_2 = getPos(vidFrames3_2);

load('cam1_3.mat');
pos1_3 = getPos(vidFrames1_3);
load('cam2_3.mat');
pos2_3 = getPos(vidFrames2_3);
load('cam3_3.mat');
pos3_3 = getPos(vidFrames3_3);
load('cam1_4.mat');
pos1_4 = getPos(vidFrames1_4);
load('cam2_4.mat');
pos2_4 = getPos(vidFrames2_4);
load('cam3_4.mat');
pos3_4 = getPos(vidFrames3_4);

% trim and synchronize data
pos3_1 = [max(pos3_1(2,:))-pos3_1(2,:);pos3_1(1,:)]; % rotate cam 3
pos1_trimmed = pos1_1(:,9:size(pos1_1,2));
pos2_trimmed = pos2_1(:,19:size(pos2_1,2));
pos3_trimmed = pos3_1(:,8:size(pos3_1,2));
minLength = min([size(pos1_trimmed,2),size(pos2_trimmed,2),size(pos3_trimmed,2)]);
pos1_trimmed = pos1_trimmed(:,1:minLength);
pos2_trimmed = pos2_trimmed(:,1:minLength);
pos3_trimmed = pos3_trimmed(:,1:minLength);
knit1 = [pos1_trimmed; pos2_trimmed; pos3_trimmed];

pos3_2 = [max(pos3_2(2,:))-pos3_2(2,:);pos3_2(1,:)]; % rotate cam 3
pos1_trimmed = pos1_2(:,1:size(pos1_2,2));
pos2_trimmed = pos2_2(:,16:size(pos2_2,2));
pos3_trimmed = pos3_2(:,1:size(pos3_2,2));
minLength = min([size(pos1_trimmed,2),size(pos2_trimmed,2),size(pos3_trimmed,2)]);
pos1_trimmed = pos1_trimmed(:,1:minLength);
pos2_trimmed = pos2_trimmed(:,1:minLength);
pos3_trimmed = pos3_trimmed(:,1:minLength);
knit2 = [pos1_trimmed; pos2_trimmed; pos3_trimmed];

pos3_3 = [max(pos3_3(2,:))-pos3_3(2,:);pos3_3(1,:)];
pos1_trimmed = pos1_3(:,1:size(pos1_3,2));
pos2_trimmed = pos2_3(:,25:size(pos2_3,2));
pos3_trimmed = pos3_3(:,1:size(pos3_3,2));
minLength = min([size(pos1_trimmed,2),size(pos2_trimmed,2),size(pos3_trimmed,2)]);
pos1_trimmed = pos1_trimmed(:,1:minLength);
pos2_trimmed = pos2_trimmed(:,1:minLength);
pos3_trimmed = pos3_trimmed(:,1:minLength);
knit3 = [pos1_trimmed; pos2_trimmed; pos3_trimmed];

pos3_4 = [max(pos3_4(2,:))-pos3_4(2,:);pos3_4(1,:)];
pos1_trimmed = pos1_4(:,12:size(pos1_4,2));
pos2_trimmed = pos2_4(:,21:size(pos2_4,2));
pos3_trimmed = pos3_4(:,10:size(pos3_4,2));
minLength = min([size(pos1_trimmed,2),size(pos2_trimmed,2),size(pos3_trimmed,2)]);
pos1_trimmed = pos1_trimmed(:,1:minLength);
pos2_trimmed = pos2_trimmed(:,1:minLength);
pos3_trimmed = pos3_trimmed(:,1:minLength);
knit4 = [pos1_trimmed; pos2_trimmed; pos3_trimmed];

% save knitted matrices
save('knit1.mat','knit1');
save('knit2.mat','knit2');
save('knit3.mat','knit3');
save('knit4.mat','knit4');