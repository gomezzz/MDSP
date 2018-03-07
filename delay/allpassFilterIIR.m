function out = allpassFilterIIR(in,dly_in_samples)
  %   allpassFilterIIR    applies an infinite impulse response (IIR) allpass filter with a fixed delay in samples to the signal using a circular buffer
  %       filteredSignal = allpassFilterIIR(signal,dly_in_samples) applies the filter to the signal

  clear ring_buffer; % clear previous buffers
  ring_buffer = circularBuffer(dly_in_samples);
  ring_buffer_out = circularBuffer(dly_in_samples);

  b0 = 0.8; % IIR coefficient, needs to be between 0 <= value < 1

  for n=1:length(in);
    v(n) = b0 * in(n) + ring_buffer.getValue(dly_in_samples);
    out(n) = v(n) - b0 * ring_buffer_out.getValue(dly_in_samples);

    ring_buffer = ring_buffer.push(in(n));
    ring_buffer_out = ring_buffer.push(out(n));
  end
end
