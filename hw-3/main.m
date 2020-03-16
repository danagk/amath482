%% perform PCA and generate graphs
% case 1
load('knit1.mat')
n = size(knit1,2);
means = mean(knit1,2);
kn = knit1 - repmat(means,1,n); % norm means
[U,S,V] = svd(kn/sqrt(n-1));
lambda = diag(S).^2;
Y = U'*kn; % calculate PC projection

subplot(2,1,1)
plot(lambda/sum(lambda),'ko')
xlabel('Mode')
ylabel('Share of Total Energy')
title('Case 1: Singular Values')

subplot(2,1,2)
t = 1:n;
plot(t, Y(1,:), t, Y(2,:), t, Y(3,:))
xlabel('Frame')
ylabel('Displacement')
title('Case 1: Projection onto First 3 Modes')
legend('Mode 1','Mode 2','Mode 3')
saveas(gcf,'case1-modes.jpg')

% y-motion
frames1 = 1:size(knit1,2);
plot(frames1,knit1(2,:))
hold on
plot(frames1,knit1(4,:));
plot(frames1,knit1(6,:));
title('Case 1: Vertical Position by Frame')
xlabel('Frame')
ylabel('Vertical Position')
legend('Camera 1','Camera 2','Camera 3')
saveas(gcf,'case1-y-pos.jpg')

% case 2
load('knit2.mat')
n = size(knit2,2);
means = mean(knit2,2);
kn = knit2 - repmat(means,1,n); % norm means
[U,S,V] = svd(kn/sqrt(n-1));
lambda = diag(S).^2;
Y = U'*kn; % calculate PC projection

subplot(2,1,1)
plot(lambda/sum(lambda),'ko')
xlabel('Mode')
ylabel('Share of Total Energy')
title('Case 2: Singular Values')

subplot(2,1,2)
t = 1:n;
plot(t, Y(1,:), t, Y(2,:), t, Y(3,:))
xlabel('Frame')
ylabel('Displacement')
title('Case 2: Projection onto First 3 Modes')
legend('Mode 1','Mode 2','Mode 3')
saveas(gcf,'case2-modes.jpg')

% y-motion
frames1 = 1:size(knit2,2);
plot(frames1,knit2(2,:))
hold on
plot(frames1,knit2(4,:));
plot(frames1,knit2(6,:));
title('Case 2: Vertical Position by Frame')
xlabel('Frame')
ylabel('Vertical Position')
legend('Camera 1','Camera 2','Camera 3')
saveas(gcf,'case2-y-pos.jpg')

% x motion
plot(frames1,knit2(1,:))
hold on
plot(frames1,knit2(3,:));
plot(frames1,knit2(5,:));
title('Case 2: Horizontal Position by Frame')
xlabel('Frame')
ylabel('Horizontal Position')
legend('Camera 1','Camera 2','Camera 3')
saveas(gcf,'case2-x-pos.jpg')

% case 3
load('knit3.mat')
n = size(knit3,2);
means = mean(knit3,2);
kn = knit3 - repmat(means,1,n); % norm means
[U,S,V] = svd(kn/sqrt(n-1));
lambda = diag(S).^2;
Y = U'*kn; % calculate PC projection

subplot(2,1,1)
plot(lambda/sum(lambda),'ko')
xlabel('Mode')
ylabel('Share of Total Energy')
title('Case 3: Singular Values')

subplot(2,1,2)
t = 1:n;
plot(t, Y(1,:), t, Y(2,:), t, Y(3,:))
xlabel('Frame')
ylabel('Displacement')
title('Case 3: Projection onto First 3 Modes')
legend('Mode 1','Mode 2','Mode 3')
saveas(gcf,'case3-modes.jpg')

% y-motion graphs
frames1 = 1:size(knit3,2);
plot(frames1,knit3(2,:))
hold on
plot(frames1,knit3(4,:));
plot(frames1,knit3(6,:));
title('Case 3: Vertical Position by Frame')
xlabel('Frame')
ylabel('Vertical Position')
legend('Camera 1','Camera 2','Camera 3')
saveas(gcf,'case3-y-pos.jpg')

% x motion
plot(frames1,knit3(1,:))
hold on
plot(frames1,knit3(3,:));
plot(frames1,knit3(5,:));
title('Case 3: Horizontal Position by Frame')
xlabel('Frame')
ylabel('Horizontal Position')
legend('Camera 1','Camera 2','Camera 3')
saveas(gcf,'case3-x-pos.jpg')

% case 4
load('knit4.mat')
n = size(knit4,2);
means = mean(knit4,2);
kn = knit4 - repmat(means,1,n); % norm means
[U,S,V] = svd(kn/sqrt(n-1));
lambda = diag(S).^2;
Y = U'*kn; % calculate PC projection

subplot(2,1,1)
plot(lambda/sum(lambda),'ko')
xlabel('Mode')
ylabel('Share of Total Energy')
title('Case 4: Singular Values')

subplot(2,1,2)
t = 1:n;
plot(t, Y(1,:), t, Y(2,:), t, Y(3,:))
xlabel('Frame')
ylabel('Displacement')
title('Case 4: Projection onto First 3 Modes')
legend('Mode 1','Mode 2','Mode 3')
saveas(gcf,'case4-modes.jpg')

% y-motion graphs
frames1 = 1:size(knit4,2);
plot(frames1,knit4(2,:))
hold on
plot(frames1,knit4(4,:));
plot(frames1,knit4(6,:));
title('Case 4: Vertical Position by Frame')
xlabel('Frame')
ylabel('Vertical Position')
legend('Camera 1','Camera 2','Camera 3')
saveas(gcf,'case4-y-pos.jpg')

% x motion
plot(frames1,knit4(1,:))
hold on
plot(frames1,knit4(3,:));
plot(frames1,knit4(5,:));
title('Case 4: Horizontal Position by Frame')
xlabel('Frame')
ylabel('Horizontal Position')
legend('Camera 1','Camera 2','Camera 3')
saveas(gcf,'case4-x-pos.jpg')