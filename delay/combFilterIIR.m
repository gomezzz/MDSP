function out = combFilterIIR(in,feedback,dly_in_samples)
  %   combFilterIIR    applies a infinite impulse response (IIR) comb filter with a fixed delay in samples to the signal
  %       filteredSignal = combFilterIIR(signal,feedback,dly_in_samples) applies the filter to the signal

  clear ring_buffer; % clear previous buffers
  ring_buffer = circBuffer(dly_in_samples);
  out(1:length(in)) = 0.0;

  %scaling to prevent clipping
  if (feedback < 1.0)
    c = 1.0 / sqrt(1.0-feedback*feedback);
  else
    c = 0.0;
  end

  %Filter
  for n=1:length(in);
    out(n)=in(n) + feedback * ring_buffer.getValue(dly_in_samples);
    ring_buffer = ring_buffer.push(out(n));
  end

  %apply scaling

  out = c * out;
end
