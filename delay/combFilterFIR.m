function out = combFilterFIR(in,feedback,dly_in_samples)
  %   combFilterFIR    applies a finite impulse response (FIR) comb filter with a fixed delay in samples to the signal
  %       filteredSignal = combFilterFIR(signal,feedback,dly_in_samples) applies the filter to the signal

  dly(1:dly_in_samples) = 0.0;
  for n=1:length(in);
    out(n)=in(n)+feedback*dly(dly_in_samples);
    dly=[in(n) dly(1:dly_in_samples-1)];
  end
end
