% Matthew Mangione
% AMATH 482 
% Assignment 1

clear all; close all; clc;
load("subdata.mat");

L = 10; % spatial domain
n = 64; % Fourier modes
realizations = 49; % number of samples in time

% create discretized grid of spacial domain
x2 = linspace(-L,L,n+1);
x = x2(1:n);
y = x;
z = x;
[X,Y,Z]=meshgrid(x,y,z);

% create discretized grid of spectral domain
k = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1];
ks = fftshift(k);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

% reorganize data into 49 realizations of 64x64x64 volume
dat(:,:,:,:)=reshape(subdata,n,n,n, realizations);

% ------------------------PART 1---------------------------

% sum each realization in fourier space,
ave = zeros(n,n,n);
for i = 1:realizations
    datf = fftn(dat(:,:,:,i));
    ave = ave + datf; 
end
ave = abs(fftshift(ave)/realizations);

% find coords of max value, represents center frequency
[M, I] = max(ave(:));
[x0, y0, z0] = ind2sub(size(ave),I);

% organize center frequency
Kx0 = Kx(x0, y0, z0)
Ky0 = Ky(x0, y0, z0)
Kz0 = Kz(x0, y0, z0)

% plot of slice of frequency noise (t=1, z = z0)
figure(1)
surf(ks,ks, abs(datf(:,:,z0) / max(abs(datf(:,:,z0)), [], 'all')));
axis([-L L -L L 0 1]);
title('Slice of Frequency Magnitude (49th measurement)');
xlabel('Kx');
ylabel('Ky');
zlabel('Magnitude');

% plot of averaged frequency data
figure(2)
surf(ks,ks, ave(:,:,z0)/M);
axis([-L L -L L 0 1]);
title('Magnitude of Averaged Frequencies at Center Frequency');
xlabel('Kx');
ylabel('Ky');
zlabel('Magnitude');

% ------------------------PART 2 & 3---------------------------

% define filter function (Gaussian)
tau = .2;
g = exp(-tau* ((Kx-Kx0).^2 + (Ky-Ky0).^2 + (Kz-Kz0).^2));

% filter frequencies around center frequency
% then return to time domain, find coords of max
coords = zeros(49, 3);
for i = 1:realizations
    datf = fftshift(fftn(dat(:,:,:,i)));
    fdatf = g .* datf;
    fdat = ifftn(ifftshift(fdatf));
    
    [M, I] = max(fdat,[],'all', 'linear');
    [xi, yi, zi] = ind2sub(size(ave),I);
    coords(i, :) = [X(xi,yi,zi) Y(xi,yi,zi) Z(xi,yi,zi)];
end

% plot of averaged frequency data
figure(3)
surf(x,y, abs(dat(:,:,zi)));
axis([-L L -L L 0 1]);
title('Slice of Unfiltered Data in Time Domain');
xlabel('X');
ylabel('Y');
zlabel('Magnitude');


xi = coords(:,1);
yi = coords(:,2);
zi = coords(:,3);

% plot path of submarine
figure(4)
plot3(coords(:,1), coords(:,2), coords(:,3)); hold on;
plot3(coords(end,1), coords(end,2), coords(end,3), 'ro');
axis([-L L -L L -L L]), grid on
title('Submarine Position over Time');
xlabel('X');
ylabel('Y');
zlabel('Z');
