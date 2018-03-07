function plotRMS(signal,Fs,filtered)
  %   plotRMS    Plots the RMS of one or two signals over time. Signal should be in mag not dBFS
  %       plotRMS(signal,Fs) plots one signal
  %       plotRMS(signal,Fs,filteredSignal) plots two signal

  N = length(signal);
  t_end = length(signal) / Fs;

  alpha = 0.5;  % Plot transparency

  signal_rms = rms_window(signal,Fs);     %compute RMS
  signal_rms = magTodBFS(signal_rms,1.0); %convert to dBFS

  min_flt_rms = 0.0;
  if nargin == 3
    filtered_rms = rms_window(filtered,Fs);     %compute RMS
    filtered_rms = magTodBFS(filtered_rms,1.0); %convert to dBFS
    min_flt_rms = min(filtered);
  end

  %this improves scaling
  rms_min = min(min(signal_rms),min_flt_rms) + 0.1;
  rms_min = max(-30,rms_min);

  points = linspace(0,t_end,N);

  figure('Position', [100, 100, 1600, 800])

  p = plot(points,signal_rms,'LineWidth',2);
  p.Color(4) = alpha;
  if nargin == 3
    hold on
    p = plot(points,filtered_rms,'LineWidth',2);
    p.Color(4) = alpha;
    legend('signal','filtered signal')
  else
    legend('signal');
  end
  xlabel('Time (s)')
  ylabel('dB FS')
  axis([0 t_end rms_min 0]);
  set(gca,'FontSize',20)

end
