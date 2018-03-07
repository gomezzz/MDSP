
signal = audioread('test.mp3'); %Read a test file
signal = 0.5 * signal(:,1) + signal(:,1); %make it mono

filtered = lowpass(signal,Fs,cutoff,filterid);  %Apply a filter

plotWave(signal,Fs,filtered);       %Plot them signals
plotSpectrum(signal,Fs,filtered);
plotRMS(signal,Fs,filtered)