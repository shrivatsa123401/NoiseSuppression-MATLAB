% trainModel.m
% 📍 Save this in: D:/NoiseSuppressionProject/scripts/

clear; clc;

%% Load Training Data
dataPath = 'D:/NoiseSuppressionProject/models/trainData.mat';  % ✅ Corrected path
load(dataPath, 'inputs', 'targets');

%% Check Dimensions
disp("Input Size: " + mat2str(size(inputs)));
disp("Target Size: " + mat2str(size(targets)));

%% Create Datastore
inputDS = arrayDatastore(inputs, 'IterationDimension', 4);
targetDS = arrayDatastore(targets, 'IterationDimension', 4);
dsTrain = combine(inputDS, targetDS);

%% Define Network
layers = [
    imageInputLayer([257 3000 1], 'Name', 'input')

    convolution2dLayer(3, 64, 'Padding', 'same', 'Name', 'conv1')
    reluLayer('Name', 'relu1')

    convolution2dLayer(3, 64, 'Padding', 'same', 'Name', 'conv2')
    reluLayer('Name', 'relu2')

    convolution2dLayer(3, 1, 'Padding', 'same', 'Name', 'conv3')

    regressionLayer('Name', 'regression')
];

%% Training Options
options = trainingOptions('adam', ...
    'MaxEpochs', 5, ...
    'MiniBatchSize', 16, ...
    'InitialLearnRate', 1e-3, ...
    'Shuffle', 'every-epoch', ...
    'Plots', 'training-progress', ...
    'Verbose', true);

%% Train Network
disp('⏳ Training network...');
net = trainNetwork(dsTrain, layers, options);
disp('✅ Training complete.');

%% Save Model
modelPath = 'D:/NoiseSuppressionProject/models/denoisingNet.mat';
save(modelPath, 'net');
disp("✅ Model saved to: " + modelPath);
