%% initialize important variables
clear; close all; clc;
load Testdata

L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1);
x=x2(1:n);
y=x;
z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; % rescale frequencies
ks=fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

%% spectral averaging
ave=zeros(n,n,n);
for j=1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Unfft=fftn(Un);
    ave=ave+Unfft;
end
ave=abs(ave)/20;

% plot if desired - data is very messy, though
close all;
isosurface(Kx,Ky,Kz,fftshift(ave),median(abs(ave),'all'));
axis([-7 7 -7 7 -7 7]), grid on

%% filtering
% find frequency signature
[val,ind]=max(ave(:));
[i,j,k]=ind2sub([n,n,n],ind);
kx0=Kx(i,j,k);
ky0=Ky(i,j,k);
kz0=Kz(i,j,k);

% build filter
tau = 1; % width of filter
mfilter = exp(-tau*((Kx-kx0).^2+(Ky-ky0).^2+(Kz-kz0).^2));

% find dominant signal component at each time step
xpos=zeros(1,20);
ypos=zeros(1,20);
zpos=zeros(1,20);
for j = 1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Ufiltered = ifftn(fftn(Un).*mfilter);
    [val,ind]=max(Ufiltered(:)); 
    [xm,ym,zm]=ind2sub([n,n,n],ind);
    xpos(j)=X(xm,ym,zm); 
    ypos(j)=Y(xm,ym,zm);
    zpos(j)=Z(xm,ym,zm);
end

%% plot trajectory
plot3(xpos,ypos,zpos,'b','Linewidth',2);
grid on, hold on
% highlight final position
plot3(xpos(end),ypos(end),zpos(end),'ro','Linewidth',5);
xlabel('x')
ylabel('y')
zlabel('z')
legend({'path','final position'},'Location','Best');
title('Position of Marble Over Time')