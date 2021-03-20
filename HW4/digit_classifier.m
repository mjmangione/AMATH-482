% Matthew Mangione
% AMATH 482
% Homework 4


%% Setup

% load MNIST training and test datasets
[images, labels] = mnist_parse('train-images-idx3-ubyte', 'train-labels-idx1-ubyte');
[test_images, test_labels] = mnist_parse('t10k-images-idx3-ubyte', 't10k-labels-idx1-ubyte');

% reshape images to vectors // convert pixels to doubles
images = double(reshape(images, size(images, 1)*size(images, 2), size(images, 3)));
test_images = double(reshape(test_images, size(test_images, 1)*size(test_images, 2), size(test_images, 3)));

% remove means from each row
images = images - mean(images, 2);

[U, S, V] = svd(images, 'econ');

%% Analysis 2-4: plots

% prominent features
figure(1)
for k = 1:9
    subplot(3,3,k)
    ut1 = reshape(U(:,k),28,28);
    ut2 = rescale(ut1);
    imshow(ut2)
end
sgtitle('First 9 Features of MNIST Dataset')

% singular values
figure(2)
plot(diag(S) / max(diag(S)),'ko','Linewidth',2)
title('Singular Values of MNIST Images');
xlabel('Index of Singular Value');
ylabel('Normalized Singular Value');
xlim([0 100]);
ylim([0 1]);

% Project onto three V-modes (columns)
figure(3)
cols = [1 2 4];
proj = S(cols, cols)*V(:,cols)';
colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 1 .65 0; 0 0 .5; 0 .5 .5; 0 0 0];
for i = 0:9
    kind = proj(:,find(labels == i));
    plot3(kind(1,:), kind(2,:), kind(3,:), 'o', 'Color', colors(i+1,:)); hold on
end
title('Projection of MNIST images onto Main Principal Components')
legend('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

xlabel('Principal Component 2')
ylabel('Principal Component 3')
zlabel('Principal Component 5')


%% LDA 

% project onto SVD basis
pcimgs = S*V';
pctest = U'*test_images;

% define numbers to be classified
nums = [0 1 2 3 4 5 6 7 8 9];
nums = [4 9 3];                 % worst: [4 9] : 93.8%

% number of features & observations
features = 50;
n = 2000;

% get optimal projection onto 1 dimension for separation
[proj] = getLDAProjection(nums, pcimgs, labels, features, n);

% access performance of model
[thresh, set, acc] = findAccuracy(nums, pcimgs, labels, proj, features, n);
acc
[thresh1, set, acc] = findAccuracy(nums, pctest, test_labels, proj, features, 800);
acc

% find accuracies of >2 digit classifier (multiple threshholds
[thresh1, set, acc] = findAccuracy([nums(1) nums(3)], pctest, test_labels, proj, features, 800);

[thresh2, set, acc] = findAccuracy([nums(1) nums(2)], pctest, test_labels, proj, features, 800);
acc
[thresh3, set, acc] = findAccuracy([nums(2) nums(3)], pctest, test_labels, proj, features, 800);
acc


%% Plot LDA (2)
% plot the separated digits on their optimal projection (linear)
% digits are separated by color and x-position, although all data lies
% on the same line.

colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 1 .65 0; 0 0 .5; 0 .5 .5; 0 0 0];
figure(4)
for i = 1:length(nums)
    kind = pcimgs(:,find(labels == nums(i)));
    kind = kind(1:features, 1:300);
    
    vnum = proj' * kind;
    col = (i)*ones(size(digits,1));
    p(:,i) = plot(col, vnum, 'o', 'Color', colors(i,:)); hold on;
    
    plot(0:2*length(nums)-1, thresh*ones(2*size(nums)), 'k'); hold on;


end
legend([p(1,1) p(2,2)], string(nums));
title('LDA Classifier 2 Digits (4, 9)');
ylabel('Projected Value');
xlim([.5 2.5])

%set(ax,'xtick',[])

%% Plot LDA (3)
% plot the separated digits on their optimal projection (linear)
% digits are separated by color and x-position, although all data lies
% on the same line.

colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 1 .65 0; 0 0 .5; 0 .5 .5; 0 0 0];
figure(4)
for i = 1:length(nums)
    kind = pcimgs(:,find(labels == nums(i)));
    kind = kind(1:features, 1:200);
    
    vnum = proj' * kind;
    col = (i)*ones(size(digits,1));
    p(:,i) = plot(col, vnum, 'o', 'Color', colors(i,:)); hold on;
    
    %plot(0:2*length(nums)-1, -thresh1*ones(2*size(nums)), 'k'); 
    plot(0:2*length(nums)-1, thresh2*ones(2*size(nums)), 'k'); 
    plot(0:2*length(nums)-1, -thresh3*ones(2*size(nums)), 'k'); 

end
legend([p(1,1) p(2,2) p(3,3)], string(nums));
title('LDA Classifier 3 Digits (4, 9, 3)');
ylabel('Projected Value');
xlim([.5 3.5])

%% SVM // Decision Trees

% projection of data to SVD basis
proj = S*V';

% define feature/observations parameters for models
features = 50;
n = 4000;

% number of observations in test data  
% (n + testn) must be <= total obs per each digit, ~5500
testn = 800;

nums = [0 1 2 3 4 5 6 7 8 9];
nums = [0 1];                   % [4 9] : 93.8%

% make unique training/testing data from selected digits (nums)
[train, train_labels, test, tlabels] = getNums(nums, proj, labels, features, n);

% rescale projected data to range of [-1, 1]
train = rescale(train', -1, 1);
test = rescale(test', -1, 1);


%% Decision Tree classifier 

tree = fitctree(train, train_labels , 'CrossVal', 'on');
view(tree.Trained{1},'Mode','graph');
classError = kfoldLoss(tree)
DTaccuracy = 1 - classError


%% SVM classifier

Mdl = fitcecoc(train,train_labels);
pred_labels = predict(Mdl,test);
length(find(pred_labels == tlabels))/length(pred_labels)


%% functions

function [set, new_labels, tset, tlabels] = getNums(nums, images, labels, features, n)
    
    % ugly fencepost loop (finds first n observations of digit nums(1) )
    kind = images(:,find(labels == nums(1)));
    tset = kind(1:features, end-1000+1:end);
    set = kind(1:features, 1:n);
    
    % creates labels vector (which we know is all num(1) )
    new_labels = nums(1) * ones(n,1);
    tlabels = nums(1) * ones(1000,1);


    % collects the first n observations of rest of nums in vector
    for i = 2:length(nums)
        kind = images(:,find(labels == nums(i)));
        tset = [tset kind(1:features, end-1000+1:end)];
        set = [set kind(1:features, 1:n)];
        
        new_labels = [new_labels; nums(i) * ones(n,1)];
        tlabels = [tlabels; nums(i) * ones(1000,1)];

    end
end

% Finds the optimal projection between a set of digits
function [proj] = getLDAProjection(nums, pcimgs, labels, features, n)
    mu = 0;
    for i = 1:length(nums)
        kind = pcimgs(:,find(labels == nums(i)));
        kind = kind(1:features, 1:n);
        mu = mu + mean(kind, 2);
    end
    mu = mu ./ length(nums);
    mean(mu)

    Sb = zeros(features);
    Sw = zeros(features);
    for i = 1:length(nums)
        kind = pcimgs(:,find(labels == nums(i)));
        kind = kind(1:features, 1:n);
        means = mean(kind, 2);
        Sb = Sb + (means - mu)*(means - mu)';
        for j = 1:length(kind)
            Sw = Sw + (kind(:, j) - means) * (kind(:, j) - means)';
        end
    end

    [V2, D] = eig(Sb, Sw);
    [lambda, ind] = max(abs(diag(D)));
    w = V2(:, ind);
    w = w/norm(w,2);
    proj = w;
end

% given a projection and 2 digits, finds the threshold between them 
% and accuracy in separation 
function [thresh, set, acc] = findAccuracy(nums, pcimgs, labels, proj, features, n)
    
    for i = 1:length(nums)
        kind = pcimgs(:,find(labels == nums(i)));
        kind = kind(1:features, 1:n);
        vnum(:,i) = proj' * kind;
        vnum(:,i) = sort(vnum(:,i));
    end
    
    if mean(vnum(:,1)) > mean(vnum(:,2))
        proj = -proj;
        vnum(:,1) = -vnum(:,1);
        vnum(:,2) = -vnum(:,2);
    end
    
    t1 = length(vnum(:,1));
    t2 = 1;
    while vnum(t1,1) > vnum(t2,2)
        t1 = t1 - 1;    
        t2 = t2 + 1;
    end
    thresh = (vnum(t1,1) + vnum(t2, 2))/2;
    
    set = [vnum(:,1); vnum(:,2)];
    lab = [nums(1) * ones(length(vnum(:,1)), 1);
           nums(2) * ones(length(vnum(:,2)), 1)];

    correct = 0;
    for i = 1:length(set)
        if (set(i) < thresh)
            if (lab(i) == nums(1))
                correct = correct + 1;
            end
        else
            if (lab(i) == nums(2))
                correct = correct + 1;
            end
        end
    end
    acc = correct / length(set);
end