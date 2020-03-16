%% load & split data
load('songs.mat')
[Atr,Ats,Ltr,Lts] = split_train_test(A,lab);

%% main body - run this for each dataset
X = A; % edit only this line to change dataset

% split data
[Xtr,Xts,Ltr,Lts] = split_train_test(X,lab);
% make specs
Xsp = spec_vec(Xtr);
% make projection
[Xtr,U,S,w] = LDA2(Xsp,25,90*.8);
% apply to test data
Xtssp = spec_vec(Xts);
Xts = w'*(U'*Xtssp);
% knn
plab = knn(Xtr,Ltr,Xts,5);
% calculate error
errs = nnz(plab-Lts);
err_ind = plab~=Lts;
err_rate = errs/length(plab);

%% plotting
%% one-time plots
% example wavform
v=A(:,1)'; Fs = 44100;
plot((1:length(v))/Fs,v);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signal of Interest, v(n)');
xlim([0 5]);
saveas(gcf,'wavform.png')

close all;
% example spec
spectrogram(v);
title('Spectrogram of Signal');
saveas(gcf,'spec.png')

%% plots for all cases
% scatter, training data
close all;
scatter(Xtr(1,1:71),Xtr(2,1:71),'^r')
hold on
scatter(Xtr(1,72:143),Xtr(2,72:143),'og')
scatter(Xtr(1,144:216),Xtr(2,144:216),'*b')
legend('class 1','class 2','class 3')
title('LDA Projection of Case I, Training Data');
saveas(gcf,'scat-train-1.png')

close all;
% scatter, testing data
scatter(Xts(1,1:18),Xts(2,1:18),'^r')
hold on
scatter(Xts(1,19:36),Xts(2,19:36),'og')
scatter(Xts(1,37:52),Xts(2,37:52),'*b')
legend('class 1','class 2','class 3')
title('LDA Projection of Case I, Testing Data');
saveas(gcf,'scat-test-1.png')

close all;
% scatter, all data
scatter(Xtr(1,1:71),Xtr(2,1:71),'^r')
hold on
scatter(Xtr(1,72:143),Xtr(2,72:143),'og')
scatter(Xtr(1,144:216),Xtr(2,144:216),'*b')
scatter(Xts(1,:),Xts(2,:),'+k')
legend('class 1','class 2','class 3','testing data')
title('LDA Projection of Case I, All Data');
saveas(gcf,'scat-all-1.png')

close all;
% scatter, errors + training data
err_pts = [plab(err_ind); Lts(err_ind)];
scatter(Xtr(1,1:71),Xtr(2,1:71),'^r')
hold on
scatter(Xtr(1,72:143),Xtr(2,72:143),'og')
scatter(Xtr(1,144:216),Xtr(2,144:216),'*b')
scatter(Xts(1,err_ind),Xts(2,err_ind),'+k');
legend('class 1','class 2','class 3','wrongly labelled data')
title('LDA Projection of Case I, Errors');
saveas(gcf,'scat-err-1.png')

close all;
% energy vs mode
lambda = diag(S).^2;
semilogy(lambda/sum(lambda),'ko')
xlabel('Mode')
ylabel('Share of Total Energy')
title('Singular Values of Case 1')
saveas(gcf,'modes-1.png')

%% functions
% assumption: obs need to be columns in A
function [Atr,Ats,Ltr,Lts] = split_train_test(A,lab)
    % save 18 out of every 90 for testing (20%)
    train = 1:72;
    test = 73:90;
    Atr = [A(:,train) A(:,train+90) A(:,train+180)];
    Ltr = [lab(train) lab(train+90) lab(train+180)];
    Ats = [A(:,test) A(:,test+90) A(:,test+180)];
    Lts = [lab(test) lab(test+90) lab(test+180)];
end

% LDA2: 2 for 2-dim projection
% n is num of each class in the data - classes MUST be consecutive
function [result,U,S,w] = LDA2(X, feature,n)
    
    [U,S,V] = svd(X,'econ');
    Xp = S*V'; % proj onto principal components
    U = U(:,1:feature);
    X1 = Xp(1:feature,1:n);
    X2 = Xp(1:feature,(n+1):(2*n));
    X3 = Xp(1:feature,(2*n+1):(3*n));
    
    % calculate Sw,Sb
    m1 = mean(X1,2);
    m2 = mean(X2,2);
    m3 = mean(X3,2);
    Sw = 0; % within class
    for i=1:n
        Sw = Sw + (X1(:,i)-m1)*(X1(:,i)-m1)';
        Sw = Sw + (X2(:,i)-m2)*(X2(:,i)-m2)';
        Sw = Sw + (X3(:,i)-m3)*(X3(:,i)-m3)';
    end
    m = (m1+m2+m3)/3;
    Sb1 = (m1-m)*(m1-m)'; % between class
    Sb2 = (m2-m)*(m2-m)';
    Sb3 = (m3-m)*(m3-m)';
    Sb = Sb1+Sb2+Sb3;
    
    % LDA
    [V2,D] = eig(Sb,Sw);
    [lambda,I] = maxk(abs(diag(D)),2);
    w1 = V2(:,I(1)); %w1 = w1/norm(w1,2);
    w2 = V2(:,I(2)); %w2 = w2/norm(w2,2);
    
    % 2-dim proj
    w = [w1 w2];
    v1 = w'*X1; v2 = w'*X2; v3 = w'*X3;
    result = [v1,v2,v3];
end

% make specs
% X must have observations as cols
function [spec] = spec_vec(X)
    n = size(X,2); % num of observations

    % determine size for memory pre-allocation
    tmp = spectrogram(X(:,1));
    sz = size(tmp);
    
    % make spectrogram matrix
    spec = zeros(sz(1)*sz(2),n);
    for j=1:n
        s = spectrogram(X(:,j));
        s = abs(s);
        s = reshape(s, [sz(1)*sz(2),1]);
        spec(:,j) = s;
    end
end

% knn
function [pred] = knn(tr,lab,ts,k)
    ntr = size(tr,2);
    nts = size(ts,2);
    X = repmat(ts(1,:),ntr,1)-repmat(tr(1,:)',1,nts);
    Y = repmat(ts(2,:),ntr,1)-repmat(tr(2,:)',1,nts);
    l2 = (X.^2 + Y.^2).^(1/2); % Euclid. dist
    
    % for each col, find k least entries
    [~,I] = sort(l2,1);
    pred = lab(I(1:k,:));
    pred = mode(pred,1); % takes 1st sorted item for ties
end