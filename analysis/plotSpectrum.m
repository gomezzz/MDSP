function plotSpectrum(signal,Fs,filtered)
  %   plotSpectrum    Plots the spectrum of one or two signals. Signal should be in mag not dBFS
  %       plotSpectrum(signal,Fs) plots spectrum for one signal
  %       plotSpectrum(signal,Fs,filteredSignal) plots spectrum for two signal

  alpha = 0.4; %plot transparency

  N = length(signal);

  useDecibel = 0;       %plots can be in dB
  decibelReference = 1;

  max_val_sig = 0.05;
  max_val_flt = 0.05;

  minimalVal = 0.0;
  maximumVal = 0.0;

  maxPhaseFlt = 0.0;
  minPhaseFlt = 0.0;
  maxPhaseSig = 0.0;
  minPhaseSig = 0.0;

  % Frequency Response
  dF = Fs/N;                     % hertz
  freq = 0:dF:Fs/2;           % hertz


  %Compute DFTs
  signal_dft = fft(signal);
  signal_dft = signal_dft(1:floor(N/2)+1);
  signal_dft(1) = 0;
  sig_phase = unwrap(angle(signal_dft));

  if nargin == 3
    filtered_dft = fft(filtered);
    filtered_dft = filtered_dft(1:floor(N/2)+1);
    filtered_dft(1) = 0;
    flt_phase = unwrap(angle(filtered_dft));
  end

  signal_dft = abs(signal_dft) / max(abs(signal_dft));
  if nargin == 3
    filtered_dft = abs(filtered_dft) / max(abs(filtered_dft));
  end

  if useDecibel
    signal_dft = magTodBFS(signal_dft,decibelReference);
    if nargin == 3
      filtered_dft = magTodBFS(filtered_dft,decibelReference);
    end
    minimalVal = -100.0;
    maximumVal = 5.0;
  else
    if nargin ==4
      [max_val_flt,idxR] = max(abs(filtered_dft));
    end
    [max_val_sig,idxL] = max(abs(signal_dft));
  end

  maxPhaseSig = max(sig_phase);
  minPhaseSig = min(sig_phase);

  if nargin == 3
    maxPhaseFlt = max(flt_phase);
    minPhaseFlt = min(flt_phase);
  end

  % Plot single-sided amplitude spectrum.
  figure('Position', [100, 100, 1600, 800])
  subplot(2,1,1)

  sig = semilogx(freq,signal_dft,'LineWidth',2);
  sig.Color(4) = alpha;
  if nargin == 3
    hold on
    flt = semilogx(freq,filtered_dft,'LineWidth',2);
    flt.Color(4) = alpha;
    legend('signal','filtered signal','Location','southwest');
  else
    legend('signal');
  end

  max_occ_freq = freq(maxNonZeroValue(signal_dft));

  tmp = max(max_val_sig*1.1,max_val_flt*1.1);

  axis([20 max_occ_freq minimalVal max(tmp,maximumVal)])
  ax = gca;
  ax.XTick = [25 50 75 100 200 500 1000 2000 5000 10000 20000];
  % ax.XTickLabel = {'5000 ','10000', '15000', '20000'};

  title('Single-Sided DFT Amplitude Spectrum')
  xlabel('Frequency (Hz)')
  if useDecibel
    ylabel('Amplitude (dB FS)')
  else
    ylabel('Amplitude (Mag)')
  end
  set(gca,'FontSize',20)

  subplot(2,1,2)

  p = semilogx(freq,sig_phase/pi,'LineWidth',2);
  p.Color(4) = alpha;
  if nargin == 3
    hold on
    flt = semilogx(freq,flt_phase/pi,'LineWidth',2);
    flt.Color(4) = alpha;
    legend('signal','filtered signal','Location','southwest')
  else
    legend('signal','Location','southwest');
  end

  ax = gca;
  ax.XTick = [25 50 75 100 200 500 1000 2000 5000 10000 20000];
  axis([20 max_occ_freq (1.1*min(minPhaseFlt,minPhaseSig)) max((1.1*max(maxPhaseSig,maxPhaseFlt)),0.001)])

  title('Phase plot')
  xlabel('Frequency (Hz)')
  ylabel('Phase / \pi')
  set(gca,'FontSize',20)

end

function idx = maxNonZeroValue(dft)
  idx = length(dft);
  while idx >= 1 && (abs(dft(idx)) == 0.0)
    idx = idx - 1;
  end
end
