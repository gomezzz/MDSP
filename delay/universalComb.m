function out = universalComb(in,dly_in_samples)
  %   universalComb    applies a universal comb filter with a fixed delay in samples to the signal
  %       filteredSignal = universalComb(signal,dly_in_samples) applies the filter to the signal

  %Filter coefficients
  BL = 0.5;
  FB = -0.5;
  FF = 1;

  dly(1:dly_in_samples) = 0.0; %delay buffer

  for n=1:length(in);
    inh = in(n) + FB * dly(dly_in_samples);
    out(n) = FF * dly(dly_in_samples) + BL * inh;
    dly=[inh dly(1:dly_in_samples-1)];
  end
end
