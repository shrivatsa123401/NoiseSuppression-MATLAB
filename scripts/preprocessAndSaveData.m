% preprocessAndSaveData.m
% 📍 Save this in: D:/NoiseSuppressionProject/scripts/

clear; clc;

% Parameters
cleanFolder = 'D:/NoiseSuppressionProject/data/clean/';
noisyFolder = 'D:/NoiseSuppressionProject/data/noise/';
outputFile = 'D:/NoiseSuppressionProject/models/trainData.mat';  % ✅ Save correctly
targetSize = [257, 3000];  % [freqBins, timeFrames]

% List .wav files
cleanFiles = dir(fullfile(cleanFolder, '*.wav'));
noisyFiles = dir(fullfile(noisyFolder, '*.wav'));

inputs = [];
targets = [];

disp('⏳ Preprocessing started...');

for k = 1:min(length(cleanFiles), length(noisyFiles))
    cleanPath = fullfile(cleanFiles(k).folder, cleanFiles(k).name);
    noisyPath = fullfile(noisyFiles(k).folder, noisyFiles(k).name);

    [cleanAudio, fs1] = audioread(cleanPath);
    [noisyAudio, fs2] = audioread(noisyPath);

    % Match lengths
    minLen = min(length(cleanAudio), length(noisyAudio));
    cleanAudio = cleanAudio(1:minLen);
    noisyAudio = noisyAudio(1:minLen);

    % Check sampling rate
    if fs1 ~= fs2
        error("Sampling rate mismatch for file: " + noisyFiles(k).name);
    end

    % Convert to spectrograms
    win = hamming(512, 'periodic');
    overlap = 256;
    nfft = 512;

    [cleanSpec, ~, ~] = stft(cleanAudio, fs1, 'Window', win, 'OverlapLength', overlap, 'FFTLength', nfft);
    [noisySpec, ~, ~] = stft(noisyAudio, fs2, 'Window', win, 'OverlapLength', overlap, 'FFTLength', nfft);

    cleanMag = abs(cleanSpec);
    noisyMag = abs(noisySpec);

    % Resize to fixed size [257 x 3000]
    cleanMag = resizeSpectrogram(cleanMag, targetSize);
    noisyMag = resizeSpectrogram(noisyMag, targetSize);

    % Add 3rd dimension (channel)
    cleanMag = reshape(cleanMag, [targetSize 1]);
    noisyMag = reshape(noisyMag, [targetSize 1]);

    inputs = cat(4, inputs, noisyMag);
    targets = cat(4, targets, cleanMag);
end

% Save dataset
save(outputFile, 'inputs', 'targets');
disp('✅ Preprocessing done. Saved to trainData.mat');

% -------------- Helper Function ----------------
function specOut = resizeSpectrogram(specIn, targetSize)
    specOut = zeros(targetSize);
    rows = min(size(specIn, 1), targetSize(1));
    cols = min(size(specIn, 2), targetSize(2));
    specOut(1:rows, 1:cols) = specIn(1:rows, 1:cols);
end
