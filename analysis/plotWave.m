function plotWave(signal,Fs,filtered)
  %   plotWave    Plots the waveform of one or two signals. Signal should be in mag not dBFS
  %       plotWave(signal,Fs) plots waveform for one signal
  %       plotWave(signal,Fs,filteredSignal) plots waveform for two signal

  alpha = 0.5; %plot transparency

  N = length(signal);
  t_end = length(signal) / Fs;

  if nargin < 3
    maxflt = 0.0;
    minflt = 0.0;
  else
    maxflt = max(filtered);
    minflt = min(filtered);
  end

  maxAmp = max(max(signal),maxflt) + 0.1;
  minAmp = min(min(signal),minflt) - 0.1;

  points = linspace(0,t_end,N);

  figure('Position', [100, 100, 1600, 800])

  subplot(2,1,1)

  p = plot(points,signal,'LineWidth',2);
  p.Color(4) = alpha;
  hold on
  if nargin == 3
    p = plot(points,filtered,'LineWidth',2);
    p.Color(4) = alpha;
    legend('signal','filtered signal')
  else
    legend('signal');
  end
  xlabel('Time (s)')
  ylabel('Amplitude')
  axis([0 0.05 minAmp maxAmp]);
  set(gca,'FontSize',20)


  subplot(2,1,2)

  p = plot(points,signal,'LineWidth',2);
  p.Color(4) = alpha;
  if nargin == 3
    hold on
    p = plot(points,filtered,'LineWidth',2);
    p.Color(4) = alpha;
    legend('signal','filtered signal')
  else
    legend('signal');
  end
  xlabel('Time (s)')
  ylabel('Amplitude')
  axis([0 t_end minAmp maxAmp]);
  set(gca,'FontSize',20)

end
