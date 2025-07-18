clc; clear; close all;

folders = {'../data/clean/', '../data/noise/'};
targetFs = 16000;  % desired sample rate

for f = 1:length(folders)
    files = dir(fullfile(folders{f}, '*.wav'));
    for i = 1:length(files)
        filePath = fullfile(folders{f}, files(i).name);
        [audio, fs] = audioread(filePath);

        if fs ~= targetFs
            disp(['🔁 Resampling: ', files(i).name, ' from ', num2str(fs), ' to ', num2str(targetFs)]);
            audio = resample(audio, targetFs, fs);
            audiowrite(filePath, audio, targetFs);
        else
            disp(['✅ Already OK: ', files(i).name]);
        end
    end
end

disp("🎉 All audio files resampled to 16,000 Hz.");
