% denoiseAudio.m
clc;
clear;

% Set paths
inputFolder = '../data/noise';
outputFolder = '../results';
modelPath = '../models/denoisingNet.mat';

% Create output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Load trained model
fprintf("⏳ Loading model...\n");
load(modelPath, 'net');
fprintf("✅ Model loaded.\n");

% Parameters
winLength = 512;
fftLength = 512;
overlap = 256;
targetSpecSize = [257, 3000];

% Process each audio file
audioFiles = dir(fullfile(inputFolder, '*.wav'));
for i = 1:length(audioFiles)
    % Read audio
    [audioIn, fs] = audioread(fullfile(inputFolder, audioFiles(i).name));

    % STFT
    win = hamming(winLength, 'periodic');
    [spec, ~, ~] = stft(audioIn, fs, 'Window', win, ...
        'OverlapLength', overlap, 'FFTLength', fftLength);

    mag = abs(spec);
    phase = angle(spec);
    [rows, cols] = size(mag);

    % Resize magnitude to match model input [257x3000]
    magResized = zeros(targetSpecSize);
    rowsToUse = min(rows, 257);
    colsToUse = min(cols, targetSpecSize(2));
    magResized(1:rowsToUse, 1:colsToUse) = mag(1:rowsToUse, 1:colsToUse);

    % Prepare input for model
    input = reshape(magResized, [targetSpecSize(1), targetSpecSize(2), 1, 1]);

    % Predict
    predictedMag = predict(net, input);
    predictedMag = squeeze(predictedMag);

    % Resize predicted magnitude back to original spectrogram size
    predictedMag = predictedMag(1:rowsToUse, 1:colsToUse);

    % Reconstruct complex STFT
    reconstructedComplex = predictedMag .* exp(1j * phase(1:rowsToUse, 1:colsToUse));

    % ISTFT
    specPadded = zeros(fftLength, colsToUse);
    specPadded(1:rowsToUse, :) = reconstructedComplex;
    specPadded(rowsToUse+1:end, :) = flipud(conj(reconstructedComplex(2:end-1, :)));

    audioOut = istft(specPadded, fs, 'Window', win, ...
        'OverlapLength', overlap, 'FFTLength', fftLength);

    % Normalize and save output
    audioOut = real(audioOut);
    audioOut = audioOut / max(abs(audioOut)); % Normalize

    [~, name, ~] = fileparts(audioFiles(i).name);
    outputFile = fullfile(outputFolder, ['denoised_' name '.wav']);
    audiowrite(outputFile, audioOut, fs);

    fprintf("✅ Denoised audio saved: %s\n", outputFile);
end
