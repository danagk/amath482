%% prepare variables
clear; close all;
load handel
v = y';
plot((1:length(v))/Fs,v);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signal of Interest, v(n)');
%p8 = audioplayer(y,Fs);
%playblocking(p8);
saveas(gcf,'p1-rawdata.png')

% initialize
S = v;
n = length(v);
L = n/Fs; % time in seconds
t = linspace(0,L,n+1);
t = t(1:n);
k = (2*pi/L)*[0:(n-1)/2 -(n-1)/2:-1];
ks = fftshift(k);

%% vary window width
a_vec = [100 10 1 0.1];
for jj = 1:length(a_vec)
    a = a_vec(jj);
    tslide=0:0.1:L;
    Sgt_spec = zeros(length(tslide),n);
    for j=1:length(tslide)
        g=exp(-a*(t-tslide(j)).^2);
        Sg=g.*S;
        Sgt=(fft(Sg));
        Sgt_spec(j,:) = fftshift(abs(Sgt));
    end
    subplot(2,2,jj);
    pcolor(tslide,ks/(2*pi),Sgt_spec.'), shading interp
    title(['a = ',num2str(a)],'Fontsize',12)
    xlabel('Time [sec]')
    ylabel('Frequency [Hz]')
    set(gca,'Ylim',[0 3500],'Fontsize',12)
end
saveas(gcf,'p1-windows.png')

%% change window function
% init fixed values
tslide = 0:.1:L;
a = 30;

% gabor
Sgabor_spec = zeros(length(tslide),n);
for j=1:length(tslide)
    gabor = exp(-a*(t-tslide(j)).^2);
    Sgabor = fft(S.*gabor);
    Sgabor_spec(j,:) = fftshift(abs(Sgabor));
end

% mexican hat
S_mex_spec = zeros(length(tslide),n);
for j=1:length(tslide)
    mex_hat = (1 - (t-tslide(j)).^2).*(exp(-a*(t-tslide(j)).^2/2));
    S_mex = fft(S.*mex_hat);
    S_mex_spec(j,:) = fftshift(abs(S_mex));
end

% shannon
S_shan_spec = zeros(length(tslide),n);
for j=1:length(tslide)
    shannon = (abs(t-tslide(j)) <= a/2);
    S_shan = fft(S.*shannon);
    S_shan_spec(j,:) = fftshift(abs(S_shan));
end

% plot
figure('Position',[500, 0, 600, 800])

subplot(3,1,1)
pcolor(tslide,ks/(2*pi),Sgabor_spec.'), shading interp
title(['Gaussian Filter'],'Fontsize',12)
xlabel('Time [sec]');
ylabel('Frequency [Hz]');
set(gca,'Ylim',[0 3500],'Fontsize',12)

subplot(3,1,2)
pcolor(tslide,ks/(2*pi),S_mex_spec.'), shading interp
title(['Mexican Hat Filter'],'Fontsize',12)
xlabel('Time [sec]');
ylabel('Frequency [Hz]');
set(gca,'Ylim',[0 3500],'Fontsize',12)

subplot(3,1,3)
pcolor(tslide,ks/(2*pi),S_shan_spec.'), shading interp
title(['Shannon Filter'],'Fontsize',12)
xlabel('Time [sec]');
ylabel('Frequency [Hz]');
set(gca,'Ylim',[0 3500],'Fontsize',12)

saveas(gcf,'p1-functions.png')

%% part II
%% piano
[y,Fs] = audioread('music1.wav');
tr_piano=length(y)/Fs; % record time in seconds
%p8 = audioplayer(y,Fs);
%playblocking(p8);

% init
S = y';
n = length(y);
L = tr_piano;
t = linspace(0,L,n+1);
t = t(1:n);
k = (2*pi/L)*[0:(n/2-1) -n/2:-1];
ks_p = fftshift(k);

% prep spectrogram
a = 100;
tslide_p=0:.1:L;
p_notes = zeros(1,length(tslide_p));
Sgt_spec_p = zeros(length(tslide_p),n);
for j=1:length(tslide_p)
    g=exp(-a*(t-tslide_p(j)).^2);
    Sg=g.*S;
    Sgt=(fft(Sg));
    [M,I] = max(fftshift(abs(Sgt)));
    p_notes(j) = abs(ks_p(I))/(2*pi);
    Sgt_spec_p(j,:) = fftshift(abs(Sgt));
end

%% recorder
[y,Fs] = audioread('music2.wav');
tr_rec=length(y)/Fs; % record time in seconds
%p8 = audioplayer(y,Fs);
%playblocking(p8);

% init
S = y';
n = length(y);
L = tr_rec; % time in seconds
t = linspace(0,L,n+1);
t = t(1:n);
k = (2*pi/L)*[0:(n/2-1) -n/2:-1];
ks_r = fftshift(k);

% prep spectrogram
a = 100;
tslide_r=0:.1:L;
r_notes = zeros(1,length(tslide_r));
Sgt_spec_r = zeros(length(tslide_r),n);
for j=1:length(tslide_r)
    g=exp(-a*(t-tslide_r(j)).^2);
    Sg=g.*S;
    Sgt=(fft(Sg));
    [M,I] = max(fftshift(abs(Sgt)));
    r_notes(j) = abs(ks_r(I))/(2*pi);
    Sgt_spec_r(j,:) = fftshift(abs(Sgt));
end

%% generate spectrograms
subplot(2,1,1)
pcolor(tslide_p,ks_p/(2*pi),Sgt_spec_p.'), shading interp
title('Piano')
xlabel('Time [sec]')
ylabel('Frequency [Hz]')
set(gca,'Ylim',[0 1000],'Fontsize',12)

subplot(2,1,2)
pcolor(tslide_r,ks_r/(2*pi),Sgt_spec_r.'), shading interp
title('Recorder')
xlabel('Time [sec]')
ylabel('Frequency [Hz]')
set(gca,'Ylim',[500 3500],'Fontsize',12)

saveas(gcf,'p2-spectrograms.png')

%% generate score
subplot(2,1,1)
for j=1:length(p_notes)
    scatter(tslide_p(j), p_notes(j),'k')
    hold on
end
p_note_names = [246.94, 261.63, 277.18, 293.66, 311.13, 329.63];
for j=1:length(p_note_names)
    plot([0 16],[p_note_names(j) p_note_names(j)],'k--')
end
yticks(p_note_names)
yticklabels({'B3','C4','C#4','D4','D#4','E4'})
title('Piano Notes')
ylabel('Note Name')
xlabel('Time (s)')
set(gca,'Ylim',[240 350])

subplot(2,1,2)
for j=1:length(r_notes)
    scatter(tslide_r(j), r_notes(j),'k')
    hold on
end
r_note_names = [783.99, 830.61, 880, 932.33, 987.77, 1046.5];
for j=1:length(r_note_names)
    plot([0 15],[r_note_names(j) r_note_names(j)],'k--')
end
yticks(r_note_names);
yticklabels({'G4','G#4','A4','A#4','B4','C5'});
title('Recorder Notes')
ylabel('Note Name')
xlabel('Time (s)')
set(gca,'Ylim',[750 1100])

saveas(gcf,'p2-notes.png')