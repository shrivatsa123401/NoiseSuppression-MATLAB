function testModel()
    % Load trained model
    modelPath = 'D:\NoiseSuppressionProject\models\noiseSuppressorNet.mat';
    load(modelPath, 'net');
    fprintf('✅ Loaded trained model.\n');

    % Select test noisy audio file
    [file, path] = uigetfile('*.wav', 'Select a test NOISY .wav file');
    [noisy, fs] = audioread(fullfile(path, file));
    fprintf('🔊 Loaded test file: %s\n', file);

    % Convert to spectrogram
    win = hamming(256, 'periodic');
    overlap = 128;
    nfft = 512;
    [S, F, T] = spectrogram(noisy, win, overlap, nfft);
    mag = abs(S);

    % Crop or pad to match model input
    freqBins = 257;
    timeFrames = 3000;
    inputSpec = zeros(freqBins, timeFrames);
    minT = min(size(mag, 2), timeFrames);
    inputSpec(:, 1:minT) = mag(:, 1:minT);

    % Predict
    predicted = predict(net, reshape(inputSpec, freqBins, timeFrames, 1));

    % Reconstruct complex spectrogram using noisy phase
    phase = angle(S(:, 1:minT));
    S_clean = predicted(:, 1:minT) .* exp(1j * phase);

    % Inverse STFT
    clean_est = istft(S_clean, fs, 'Window', win, 'OverlapLength', overlap, 'FFTLength', nfft);

    % Save or play output
    audiowrite('denoised_output.wav', clean_est, fs);
    fprintf('🎧 Denoised audio saved to denoised_output.wav\n');

    % Optional: Play result
    soundsc(clean_est, fs);
end
