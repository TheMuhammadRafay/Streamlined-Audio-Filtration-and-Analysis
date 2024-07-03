% Read the audio file
[audio, Fs] = audioread('make.wav');
disp(['Sampling Rate: ', num2str(Fs), ' Hz']);

% Ensure y is a column vector
if size(audio, 2) > 1
    audio = audio(:, 1); % Select the first channel if the audio is stereo
end

% Plot the frequency spectrum of the noisy audio
N = length(audio);
f = linspace(-Fs/2, Fs/2, N); % Corrected to match length of Y
Y = fftshift(fft(audio));

% Design a low-pass filter to remove noise (example: Butterworth filter)
order = 5; % Filter order
cutoff_freq = 1500; % Cutoff frequency in Hz
[b, a] = butter(order, cutoff_freq/(Fs/2), 'high');

% Apply the filter to the noisy audio
audio_filtered = filter(b, a, audio);

% Plot the time domain representation of the original and filtered audio
t = (0:N-1) / Fs;
figure;
subplot(2, 1, 1);
plot(t, audio, 'b');
title('Time Domain - Original Audio');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2, 1, 2);
plot(t, audio_filtered, 'r');
title('Time Domain - Filtered Audio');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plot the frequency spectrum of the original and filtered audio
freq_audio_filtered = fftshift(fft(audio_filtered));
figure;
subplot(2, 1, 1);
plot(f, abs(Y), 'b');
title('Frequency Spectrum - Original Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

subplot(2, 1, 2);
plot(f, abs(freq_audio_filtered), 'r');
title('Frequency Spectrum - Filtered Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% Play the filtered audio
soundsc(audio_filtered, Fs);

% Save the filtered audio to a new file
audiowrite('filtered_audio.wav', audio_filtered, Fs);

% Plot the spectrograms of the original and filtered audio in one window
figure;
subplot(2, 1, 1);
spectrogram(audio, 256, [], [], Fs, 'yaxis');
title('Spectrogram - Original Audio');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

subplot(2, 1, 2);
spectrogram(audio_filtered, 256, [], [], Fs, 'yaxis');
title('Spectrogram - Filtered Audio');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Plot the frequency spectrum with noise level highlighted (Original)
figure;
plot(f, abs(Y), 'b');
title('Frequency Spectrum with Noise Level - Original Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
hold on;
plot(f(f > cutoff_freq), abs(Y(f > cutoff_freq)), 'r.', 'MarkerSize', 10);
legend('Original Audio', 'Noise above threshold');
xlim([-Fs/2 Fs/2]);

% Plot the frequency spectrum with noise level highlighted (Filtered)
figure;
plot(f, abs(freq_audio_filtered), 'b');
title('Frequency Spectrum with Noise Level - Filtered Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
hold on;
plot(f(f > cutoff_freq), abs(freq_audio_filtered(f > cutoff_freq)), 'r.', 'MarkerSize', 10);
legend('Filtered Audio', 'Noise above threshold');
xlim([-Fs/2 Fs/2]);
