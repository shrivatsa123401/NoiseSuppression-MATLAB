function evaluateDenoising()
    [noisy, fs1] = audioread('speech1.wav');               % ← your real noisy input
    [denoised, fs2] = audioread('denoised_speech1.wav');   % ← your real denoised output

    if fs1 ~= fs2
        error('Sampling rates do not match!');
    end

    figure;
    subplot(2,1,1);
    spectrogram(noisy, hamming(256), 128, 512, fs1, 'yaxis');
    title('🔊 Noisy Input');

    subplot(2,1,2);
    spectrogram(denoised, hamming(256), 128, 512, fs2, 'yaxis');
    title('✨ Denoised Output');
end
