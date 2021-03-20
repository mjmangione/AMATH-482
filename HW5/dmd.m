% Matthew Mangione
% AMATH 482: Computational Methods for Data Analysis
% Assignment 5: Video Background Subtraction

%% Load videos / convert to matrices / save for easier access
v_ski = VideoReader('ski_drop_low.mp4');
v_mc = VideoReader('monte_carlo_low.mp4');

% convert each ski video frame into grayscale double matrix
for i = 1:v_ski.numFrames
    ski(:,:, i) = im2double(im2gray(readFrame(v_ski)));
end

% convert each monte carlo video frame into grayscale double matrix
for i = 1:v_mc.numFrames
    mc(:,:, i) = im2double(im2gray(readFrame(v_ski)));
end

%save('ski.mat', 'ski');
%save('mc.mat', 'mc');

%% Reload pre-processed video files // Assign DMD matrices

%load('ski.mat');
%load('mc.mat');

%ski = samplevid(ski, 2);
%playVid(ski)

% reshape each pixel in each image to be a vector, sample video
X = samplevid(reshape(ski, size(ski, 1)*size(ski, 2), size(ski, 3)), 2);
Xs = samplevid(X, 2);

% assign sub matrices
X1 = Xs(:,1:end-1); 
X2 = Xs(:,2:end);
t = 1:size(Xs,2);


%% SVD / initialization
[U,Sigma,V] = svd(X1, 'econ');
rank = 10;

U = U(:,1:rank); 
Sigma = Sigma(1:rank,1:rank);
V = V(:,1:rank);

S = U'*X2*V*diag(1./diag(Sigma));
[eV,D] = eig(S);
Phi = U*eV;

mu = diag(D);
omega = log(mu)/dt;

y0 = Phi\X(:, 1);  % pseudo-inverse initial conditions

% get omega closest to 0
[~, minOmega] = min(abs(omega));

%% plot singular values
sv = diag(Sigma) / max(diag(Sigma));

figure(1)
plot(1:5, sv(1:5), 'ro')
title('Singular Values of Video');
xlabel('Index of Singular Value');
ylabel('Singular Value (Normalized)');

%% Recreate DMD solution

lowrank = y0(minOmega).*Phi(:, minOmega).*exp(omega(minOmega).*t);
sparse = Xs - abs(lowrank);

% Create matrix of residuals (negative values)
R = sparse .* (sparse < 0);

% Add residuals back into reconstructions
lowrank = abs(lowrank) + R; 
sparse = sparse - R; 

%% plots
frame = 200;

figure(2)
fg = reshape(sparse, [height,width, length(t)]);
imshow(uint8(fg(:,:,frame)))
title("Original Video at Frame 200");

figure(3) = reshape(Xs, [height,width, length(t)]);
imshow(uint8(fg(:,:,frame)))
title("Sparse (Foreground) at Frame 200");


figure(4)
bg = reshape(low_rank, [height,width, length(t)]);
imshow(uint8(bg(:,:,frame)))
title("Low Rank (Background) at Frame 200");

%% functions

% samples a video (takes 1 per n frames)
function [svid] = samplevid(vid, jump)
    numFrames = size(vid);
    ind = 1;
    for j = 1:jump:numFrames(2)
        X = vid(:,j);
        svid(:,ind) = X;
        ind = ind + 1;
    end

end
