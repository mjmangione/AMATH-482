% Matthew Mangione
% AMATH 482: Computational Methods for Data-Analysis
% Assignment 3: Spring-Mass System

%%  Test 1: Ideal Case   --------------------------------------------------

sample_rate = 4; % keeps 1 out of every n frames.

load('cam1_1.mat')
load('cam2_1.mat')
load('cam3_1.mat')


% reduce videos to greyscale
gvid1 = vid2gray(vidFrames1_1);
gvid2 = vid2gray(vidFrames2_1);
gvid3 = vid2gray(vidFrames3_1);

%implay(vidFrames1_1)
clear vidFrames1_1;
clear vidFrames2_1;
clear vidFrames3_1;

% align videos based on delays between videos (determined by eye) 
[gvid1, gvid2, gvid3] = cropvids(gvid1, gvid2, gvid3, [1, 15, 6]);

gvid1 = samplevid(gvid1, sample_rate);
gvid2 = samplevid(gvid2, sample_rate);
gvid3 = samplevid(gvid3, sample_rate);

[~, t1] = trackvid(gvid1, .9, 25, .6); % vertical
[~, t2] = trackvid(gvid2, .9, 25, .85); % vertical
[~, t3] = trackvid(gvid3, .9, 25, .5); % horizontal

%%  Test 2: Noisy case ---------------------------------------------------

sample_rate = 3; % keeps 1 out of every n frames.

load('cam1_2.mat')
load('cam2_2.mat')
load('cam3_2.mat')


% reduce videos to greyscale
gvid1 = vid2gray(vidFrames1_2);
gvid2 = vid2gray(vidFrames2_2);
gvid3 = vid2gray(vidFrames3_2); 

clear vidFrames1_2;
clear vidFrames2_2;
clear vidFrames3_2;

% align videos based on delays between videos (determined by eye) 
[gvid1, gvid2, gvid3] = cropvids(gvid1, gvid2, gvid3, [13, 1, 18]);

gvid1 = samplevid(gvid1, sample_rate);
gvid2 = samplevid(gvid2, sample_rate);
gvid3 = samplevid(gvid3, sample_rate);

gvid1 = cropvid(gvid1, 250, 640, 1, 480);
gvid2 = cropvid(gvid2, 100, 500, 1, 480);
gvid3 = cropvid(gvid3, 250, 640, 100, 300);

[~, t1] = trackvid(gvid1, .95, 25, .4); % vertical
[~, t2] = trackvid(gvid2, .95, 25, .85); % vertical
[~, t3] = trackvid(gvid3, .95, 25, .4); % horizontal

%%  Test 3: Horizontal Displacement----------------------------------------

sample_rate = 5; % keeps 1 out of every n frames.

load('cam1_3.mat') load('cam2_3.mat') load('cam3_3.mat')

% reduce videos to greyscale
gvid1 = vid2gray(vidFrames1_3);
gvid2 = vid2gray(vidFrames2_3);
gvid3 = vid2gray(vidFrames3_3); 

clear vidFrames1_3; clear vidFrames2_3; clear vidFrames3_3;
 
% align videos based on delays between videos (determined by eye) 
[gvid1, gvid2, gvid3] = cropvids(gvid1, gvid2, gvid3, [8, 32, 1]);

gvid1 = samplevid(gvid1, sample_rate);
gvid2 = samplevid(gvid2, sample_rate);
gvid3 = samplevid(gvid3, sample_rate);

gvid1 = cropvid(gvid1, 140, 540, 240, 480);
gvid2 = cropvid(gvid2, 140, 500, 150, 480);
gvid3 = cropvid(gvid3, 250, 640, 100, 300);

[~, t1] = trackvid(gvid1, .95, 25, .4); % vertical
[~, t2] = trackvid(gvid2, .95, 25, .85); % vertical
[~, t3] = trackvid(gvid3, .95, 25, .4); % horizontal

%%  Test 4: Horizontal & Rotation----------------------------------------

sample_rate = 4; % keeps 1 out of every n frames.

load('cam1_4.mat') load('cam2_4.mat') load('cam3_4.mat')

% reduce videos to greyscale
gvid1 = vid2gray(vidFrames1_4);
gvid2 = vid2gray(vidFrames2_4);
gvid3 = vid2gray(vidFrames3_4); 
 
% implay(vidFrames1_4)
% implay(vidFrames2_4)
% implay(vidFrames3_4)

clear vidFrames1_4; clear vidFrames2_4; clear vidFrames3_4;

% align videos based on delays between videos (determined by eye) 
[gvid1, gvid2, gvid3] = cropvids(gvid1, gvid2, gvid3, [1, 1, 1]);

gvid1 = samplevid(gvid1, sample_rate);
gvid2 = samplevid(gvid2, sample_rate);
gvid3 = samplevid(gvid3, sample_rate);

gvid1 = cropvid(gvid1, 140, 540, 240, 480);
gvid2 = cropvid(gvid2, 140, 500, 150, 480);
gvid3 = cropvid(gvid3, 250, 640, 100, 300);

[~, t1] = trackvid(gvid1, .9, 25, .6); % vertical
[~, t2] = trackvid(gvid2, .95, 25, .85); % vertical
[~, t3] = trackvid(gvid3, .85, 25, .4); % horizontal

%% TEST 1 -----------------------------------------------------------------

implay(trackvid(gvid1, .9, 25, .6));
implay(trackvid(gvid2, .9, 25, .85));
implay(trackvid(gvid3, .9, 25, .5));

%% TEST 2 -----------------------------------------------------------------

implay(trackvid(gvid1, .95, 25, .4));
implay(trackvid(gvid2, .95, 25, .85));
implay(trackvid(gvid3, .95, 25, .4));

%% TEST 3 / 4 -------------------------------------------------------------

implay(trackvid(gvid1, .9, 25, .4));
implay(trackvid(gvid2, .95, 25, .85));
implay(trackvid(gvid3, .85, 25, .4));

%% Principal Componenent Analysis (Same for all tests)---------------------
%  run this section after pre-processing of specific test.

% fill in empty data with nearest neighbor / average of
% neighbors. function below
t1 = fillNaN(t1);
t2 = fillNaN(t2);
t3 = fillNaN(t3);


X = [t1; t2; t3]; % SWITCH horizontal & VERTICAL
[m, n] = size(X);
row_aves = mean(X, 2);
X = X - row_aves;
%plot(1:length(X(3,:)), X(3,:))

[U, S, V] = svd( X' / sqrt(n - 1), 'econ');
S2 = S(1:m, 1:m).^2;

% create principle components
Y = V' * X;
r1p = U(:,1)*S(1,1)*V(:,1)';
r2p = r1p + U(:,2)*S(2,2)*V(:,2)';
r3p = r2p + U(:,3)*S(3,3)*V(:,3)';


%% PLOTS

figure(1)
plot(1:m, diag(S2)/max(diag(S2)), 'ro', 'LineWidth', 2)
set(gca, 'fontsize', 14);
title('Horizontal & Rotational Displacement Case');
xlabel('Index of Singular Value');
ylabel('Singular Value (normalized)');


figure(2) % plots PRINCIPLE COMPONENTS (1 should be best)
axes;
plot(1:n ,Y(1,:), 'LineWidth', 1.5); hold on;
plot(1:n ,Y(2,:), 'LineWidth', 1.5);
plot(1:n ,Y(3,:), 'LineWidth', 1.5);
%plot(1:n ,Y(4,:), 'LineWidth', 1.5);

set(gca, 'fontsize', 14);
legend('Principal Component 1','Principal Component 2', 'Principal Component 3');
ylabel('Position (pixels)');
xlabel('Time (video frames)');
title('Principal Components for Horizontal & Rotational Displacement Case');

figure(3)
plot(1:n ,r1p(:,1), 'r', 'LineWidth', 1); hold on;
plot(1:n ,r2p(:,1), 'k', 'LineWidth', 1); 
plot(1:n ,r3p(:,1), 'k', 'LineWidth', 1);


figure(4)
plot3(1:n, Y(3,:), Y(1,:), 'LineWidth', 1.5)
set(gca, 'fontsize', 14);
xlabel('Time (video frames)');
ylabel('Horizontal Position (pixels)');
zlabel('Vertical Position (pixels)');
title('Position vs Time');


%% Functions  -------------------------------------------------------------


function [gvid] = vid2gray(rgb_vid)

    numFrames = size(rgb_vid);
    gvid = zeros(numFrames(1), numFrames(2), numFrames(4));
    
    for j = 1:numFrames(4)
        X = rgb_vid(:,:,:,j);
        gvid(:,:,j) = im2double(rgb2gray(X));
    end
end

function [vid1, vid2, vid3] = cropvids(vid1, vid2, vid3, delay)

    
    vid1 = vid1(:,:, delay(1):end);
    vid2 = vid2(:,:, delay(2):end);
    vid3 = vid3(:,:, delay(3):end);
    
    num_frames = min([size(vid1,3) size(vid2,3) size(vid3,3)]) - 1;

    vid1 = vid1(:,:, 1:(num_frames));
    vid2 = vid2(:,:, 1:(num_frames));
    vid3 = vid3(:,:, 1:(num_frames));
end

function [nvid] = cropvid(vid, y1, y2, x1, x2)
    nvid = zeros(x2-x1+1, y2-y1+1, size(vid, 3));
    for frame = 1:size(vid, 3)
        for i = x1:x2
            for j = y1:y2
                nvid(i + 1 - x1, j + 1 - y1, frame) = vid(i, j, frame);
            end
        end
    end
end

function [svid] = samplevid(vid, jump)
    numFrames = size(vid);
    ind = 1;
    for j = 1:jump:numFrames(3)
        X = vid(:,:,j);
        svid(:,:,ind) = X;
        ind = ind + 1;
    end

end

% Non-max supression: any pixels less than cut ([0, 1])
% are set to 0. Input a video.
function [vid] = brightpass(vid, cut)
    numFrames = size(vid);
    for j = 1:numFrames(3)
        vid(:,:,j) = blur(vid(:,:,j), 50);
        for x = 1:numFrames(1)
            for y = 1:numFrames(2)
                if vid(x,y,j) < cut
                    vid(x,y,j) = 0;
                end
            end
        end
    end
end


% Given a pre-processed grayscale video this function isolates
% the movement of the paint can and returns the averaged coordinates
% of its location through time. To do this, this function filters based
% on brightness, then based on movement, and then takes an average of the
% remaining pixels' location.
function [gvid, track] = trackvid(vid, bright1, blur_cnst, bright2)

%     % HYPERPARAMETERS
%     bright1 = .9;
%     blur_cnst = 25;
%     bright2 = .6;
    
    vid = brightpass(vid, bright1);
    numFrames = size(vid);
    gvid = ones(numFrames(1), numFrames(2), numFrames(3)-1);
    track = zeros(2, numFrames(3)-2);
    for j = 2:numFrames(3)
        frame_diff = abs(minus(vid(:,:,j), vid(:,:,j-1)));
        frame_diff = blur(frame_diff, blur_cnst);
        gvid(:,:,j-1) = frame_diff;
    end
    
    gvid = brightpass(gvid, bright2);
    for j = 1:numFrames(3)-2
        brights = find(gvid(:,:,j) > bright2);
        [x, y] = ind2sub(size(frame_diff), brights);
        if (j > 1 && (length(x) < 15 || length(y) < 15)) 
            track(:,j) = mean(track(:, 1:j-1), 2);
        end
        track(:,j) = [round(mean(x)); round(mean(y))];
    end
end

% Applies a Shannon Filter to inputted image
% n represents the k number of frequencies allowed
% to pass the filter.
function [frame] = blur(frame, n)
    ff = fft2(frame);
    filt = zeros(size(frame));
    x = double(size(filt,1)/2);
    y = double(size(filt,2)/2);
    [x, y] = size(frame);
    filt([1:n+1 x-n+1:x], [1:n+1 y-n+1:y]) = ones((2*n+1), (2*n+1));
    ff = filt .* ff;
    frame = abs(ifft2(ff));

end

function [t] = fillNaN(t)
    tNaN = find(isnan(t));
    for j = 1:length(tNaN)
        [i,k] = ind2sub(size(t), tNaN(j));
        if k == 1
            t(i,k) = t(i,k+1);
        elseif k == length(t)
            t(i,k) = t(i,k-1);
        else
            t(i,k) = round((t(i,k-1) + t(i,k+1))/2);
        end
    end
end


