duration = 20; % Duration of recording in seconds
fs = 19000; % Sampling frequency (19 kHz)
numBits = 8; % Number of bits saved in each sample
numChannels = 1; % Number of channels

% Create an audiorecorder object
recObj = audiorecorder(fs, numBits, numChannels);

% Start the recording
disp('Start speaking...');
recordblocking(recObj, duration);

% End of recording
disp('Recording complete.');

% Get the recorded audio data
audioData = getaudiodata(recObj);

% Plot the recorded audio
time = (0:length(audioData)-1) / fs;
plot(time, audioData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Recorded Audio');

% Load the recorded audio
%[audioData, fs] = audioread('recorded_audio.wav');

% Calculate the power signal per sample
powerPerSample = mean(abs(audioData).^2);

% Convert power signal per sample to dB
powerPerSample_dB = 10 * log10(powerPerSample);

% Display the power signal per sample
disp(['Power signal per sample: ', num2str(powerPerSample_dB)]);

% Specify the desired SNR in dB
SNR = 15;

% Add the noise to the recorded audio
contaminatedAudio = awgn(audioData, SNR, powerPerSample_dB);

% Plot the original and contaminated audio waveforms
time = (0:length(audioData)-1) / fs;
figure;
subplot(2, 1, 1);
plot(time, audioData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Audio');

subplot(2, 1, 2);
plot(time, contaminatedAudio);
xlabel('Time (s)');
ylabel('Amplitude');
title('Contaminated Audio');

try
    cd Audios;
catch
    mkdir('Audios');
    cd Audios;
end
% Save the recorded audio to a WAV file
audiowrite('mainRecord.wav', audioData, fs);
audiowrite('noisyRecord.wav', contaminatedAudio, fs);
cd ../;

[filter,dSignal] = LPfilter(contaminatedAudio);

figure(2);
subplot(2,1,1);
plot(contaminatedAudio(1:2000));
title('Noisy Signal');
grid on;
subplot(2,1,2);
plot(dSignal(1:2000),'r');
title('Denoised Signal');