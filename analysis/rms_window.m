function out = rms_window(in,Fs)
  %   rms_window    Computes the RMS over a 0.05 * Fs points windows using a running sum
  %       rms = rms_window(signal,Fs) compute RMS for signal

  window_size = round(Fs * 0.05);

  last = 0.0;
  n = 0;

  running_sum = 0.0;

  for i=1:length(in)
      running_sum = running_sum + (in(i) * in(i));
      if i <= window_size
        n = n + 1;
      else
        last = in(i-window_size);
        running_sum = running_sum - (last * last);
        if running_sum < -0.01
          error('Error in RMS calculation');
        elseif running_sum < 0.0
          running_sum = 0.0;
        end
      end
      out(i) = sqrt(running_sum/n);
  end
end
