% Matthew Mangione
% AMATH 482: ...
% Rock & Roll & the Gabor Transform

clear all; close all;

% ---------------------------- GNR ------------------------------
[x, sample_rate_gnr] = audioread('GNR.m4a');
time_gnr = length(x)/sample_rate_gnr; % record time in seconds

L = time_gnr; 
n = length(x);
t2 = linspace(0,L,n+1);
t = t2(1:n); clear t2;
ks = fftshift((1/L)*[0:n/2-1 -n/2:-1]); % wavenumber -> Hertz

a = 128;
b = 2;
tau = 0:0.1:L;

guitar_rect_filt = zeros(1, n);
guitar_rect_filt(331937:342345) = 1; % positive indices (plots
guitar_rect_filt(316773:327000) = 1; % negative indices (works)

Sgf_spec(:,:) = zeros(length(ks), length(tau));
Sgf_spec(:,:) = zeros(length(ks), length(tau));

for j = 1:length(tau)
    g = exp(-a*(t - tau(j)).^2);
    % Window function
    Sgf = abs(fftshift(fft(g.*(x')))); % fft of data * gaussian time filter
    Sgf = Sgf .* guitar_rect_filt;
    [M, I] = max(Sgf);
    peaks(j) = -ks(I);
    Sgf_spec(:,j) = Sgf;%.*gfilt;
end

figure(1) % only first 2 bars
plot_ind = 1:(length(tau));
pcolor(tau(plot_ind), ks, log(Sgf_spec(:, plot_ind) + 1)); hold on;
shading interp
set(gca,'ylim',[220 880])
colormap(hot)
colorbar
xlabel('time (t)');
ylabel('frequency (Hz)');
title('`Sweet Child `O Mine` Guitar Spectrogram');

figure(2)
plot(plot_ind, peaks(plot_ind), 'k', 'LineWidth', 0.01); hold on;
plot(plot_ind, peaks(plot_ind), 'r_', 'MarkerSize', 6);
set(gca,'ylim',[220 880],'Fontsize', 10)
yticks([277.2, 311.13,369.994, 415.3, 554.3653, 698.456, 739.99]);
yticklabels({'C#', 'D#', 'F#', 'G#', 'C#', 'F ', 'F#'}) 
xticks([3.5, 22.5, 40.5, 59.5, 78.5, 97.5, 116.5, 135.5]);
xticklabels({'1', '2', '3', '4', '5', '6', '7', '8'}) 
xlabel('time (Bars)');
ylabel('Notes / Frequency');
title('Notes in `Sweet Child `O Mine`');

% zoom in on only 2 bars of guitar
plot_ind = 1:(length(tau)/3.5);

figure(3) % only first 2 bars
pcolor(tau(plot_ind), ks, log(Sgf_spec(:, plot_ind) + 1)); hold on;
plot(tau(plot_ind), peaks(plot_ind), 'LineWidth', 2, 'Color', 'w');
shading interp
set(gca,'ylim',[220 880])
colormap(hot)
colorbar
xlabel('time (t)');
ylabel('frequency (Hz)');
title('`Sweet Child `O Mine` Notes over Corresponding Spectrogram');

figure(4)
plot(plot_ind, peaks(plot_ind), 'k'); hold on;
plot(plot_ind, peaks(plot_ind), 'r_', 'LineWidth', .5, 'MarkerSize', 6);
set(gca,'ylim',[220 880],'Fontsize', 10)
% yticks([261.626, 277.2, 293.665, 311.127, 329.63, 349.23, 369.994, 391.995, ...
%        415.305, 440, 466.164, 493.89, 523.25, 554.3653, 587.3295, 622.254, 659.255, ...
%        698.456, 739.99, 783.99, 830.61, 880]);
% yticklabels({'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#', 'A ', 'A#', 'B ', 'C ',...
%             'C#',  'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#', 'A '})
yticks([277.2, 369.994, 415.3, 554.3653, 698.456, 739.99]);
yticklabels({'C#', 'F#', 'G#', 'C#', 'F ', 'F#'}) 
xlabel('time (t)');
ylabel('Notes / Frequency');
title('Notes in `Sweet Child `O Mine` for First Two Bars');


% ---------------------------- Pink Floyd ------------------------------
clear Sgf g Sgf_spec peaks 

[y, sample_rate_pf] = audioread('Floyd.m4a');
time_floyd = length(y)/sample_rate_pf; % record time in seconds

% limit use of song data to reduce RAM
time_start = 0;
time_end = 60;
time_step = .5;


L = time_floyd; 
n = length(y);
t2 = linspace(time_start,time_end,n+1);
t = t2(1:n); clear t2;
ks = fftshift((1/L)*[0:n/2-1 -n/2:-1]); % wavenumber -> Hertz

a = 256;
b = 1;
c = .005;
tau = time_start:time_step:time_end;

% define rectangular filter around bass frequencies ([50, 240])
bass_rect_filt = zeros(1, n);
bass_rect_filt(freq2ind(-240, n, range(ks)):freq2ind(-50, n, range(ks))) = 1;
bass_rect_filt(freq2ind(50, n, range(ks)):freq2ind(240, n, range(ks))) = 1; 

% define rectangular filter around guitar frequencies ([230, max])
guitar_rect_filt = ones(1, n-1);
guitar_rect_filt(freq2ind(-240, n, range(ks)):freq2ind(240, n, range(ks))) = 0;



% % isolate guitar solo & write new audio file
solo = fftshift(fft(y'));
g_filt = blockfilter([246.9 329.6], ks, c);
solo = ifft(ifftshift(guitar_rect_filt .* solo(1:(n-1)))); %.* g_filt));
audiowrite('comfortably_numb_guitar_solo.m4a', real(solo), sample_rate_pf);

%isolate bass & write new audio file 
bass = fftshift(fft(y'));
bass = ifft(ifftshift(bass_rect_filt .* bass));
audiowrite('comfortably_numb_bass_iso.m4a', real(bass), sample_rate_pf);

% redefine bass rectangular filter to exclude rhythm guitar for the purpose
% of recreating musical score of the bass notes. Lower range to [50, 140]
bass_rect_filt = zeros(1, n);
bass_rect_filt(freq2ind(-140, n, range(ks)):freq2ind(-50, n, range(ks))) = 1;
bass_rect_filt(freq2ind(50, n, range(ks)):freq2ind(140, n, range(ks))) = 1; 

% apply Gabor transform to each timeframe of the song using gaussian 
% with width a. Apply non-max supression to reduce noise / emphasize notes.
Sgf_spec(:,:) = zeros(length(ks), length(tau));
Sgf_spec_guitar(:,:) = zeros(length(ks), length(tau));

for j = 1:length(tau)
    g = exp(-a*(t - tau(j)).^2); % localize data in time
    Sgf = abs(fftshift(fft(g.*(y')))); % fft of data * gaussian time filter
    g_filt = blockfilter([246.9, 329.6, 369.9, 493.8, 587.3, 739.9], ks, c);
    %g_filt = blockfilter([], ks, c);

    % isolate bass & apply non-max supression
    Sgf = Sgf.*bass_rect_filt; % apply filter to focus on bass line
    [M, I] = max(Sgf);
    peaks_bass(j) = -ks(I);
    g_filt = exp(-b*((ks+ks(I)).^2));
    Sgf_spec(:,j) = Sgf(1:length(ks)).*g_filt; 
    
    % isolate guitar solo & apply non-max supression
    Sgf = Sgf(1:(n-1)).*guitar_rect_filt; % apply filter to focus on bass line
    Sgf = Sgf(1:(n-1)) .* g_filt;
    [M, I] = max(Sgf);
    peaks_guitar(j) = -ks(I);
    g_filt = exp(-b*((ks+ks(I)).^2));
    Sgf_spec_guitar(:,j) = Sgf(1:(n-1)) .*g_filt; 
end

figure(5) % spectrogram of bass notes
plot_ind = 1:length(tau);
pcolor(tau(plot_ind), ks, log(Sgf_spec(:, plot_ind) + 1)); hold on;
%plot(tau(plot_ind), peaks(plot_ind), 'LineWidth', 2);
shading interp
set(gca,'ylim',[70 140])
caxis([0 5])
colormap(hot)
colorbar
xlabel('time (t)');
ylabel('frequency (Hz)');
title('Spectrogram of Bass Frequencies in `Comfortably Numb`');

figure(6) % approximate score of bass line
plot(plot_ind, peaks_bass(plot_ind), 'k'); hold on;
plot(plot_ind, peaks_bass(plot_ind), 'r_', 'LineWidth', .5, 'MarkerSize', 6);
set(gca,'ylim',[70 140])
yticks([82.41, 91.49, 97.99, 110.0, 123.4]);
yticklabels({'E ', 'F#', 'G ', 'A ', 'B '})        
xlabel('time (t)');
ylabel('Notes / Frequency');
title('Bass Notes in `Comfortably Numb`');

figure(7) % guitar solo spectrogram
plot_ind = 1:length(tau);
pcolor(tau(plot_ind), ks, log(Sgf_spec_guitar(:, plot_ind) + 1)); hold on;
%plot(tau(plot_ind), peaks(plot_ind), 'LineWidth', 2);
shading interp
set(gca,'ylim',[200 800])
caxis([0 5])
colormap(hot)
colorbar
xlabel('time (t)');
ylabel('frequency (Hz)');
title('Spectrogram of Guitar Frequencies in `Comfortably Numb`');


figure(8) 
plot(plot_ind, peaks_guitar(plot_ind), 'k'); hold on;
plot(plot_ind, peaks_guitar(plot_ind), 'r_', 'LineWidth', .5, 'MarkerSize', 6);
set(gca,'ylim',[250 600],'Fontsize', 10)

%yticks([82.41, 91.49, 97.99, 110.0, 123.4]);
%yticklabels({'E ', 'F#', 'G ', 'A ', 'B '})        
xlabel('time (t)');
ylabel('Notes / Frequency');
title('Guitar Notes in `Comfortably Numb`');

% approximates the index of a given frequency in a vector
function [ind] = freq2ind(freq, n, range)
    slope = n / range;
    zed = n/2;
    ind = round(slope * freq + zed);
end

% creates a filter that blocks all frequencies of a given vector v
function [g_filt] = blockfilter(v, ks, c)
    g_filt = ones(1, length(ks));
    for i = 1:length(v)
        g_filt = g_filt - exp(-c*((ks-ks(freq2ind(v(i), length(ks)+1, range(ks)))).^2));
        g_filt = g_filt - exp(-c*((ks-ks(freq2ind(-v(i), length(ks)+1, range(ks)))).^2));
    end

end
