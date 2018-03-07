function out = clip(in,gain,threshold)
  %Applies clipping distortion to a signal
  
  for i=1:length(in)
    if in(i) > threshold
      out(i) = threshold;
    elseif in(i) < -threshold
      out(i) = -threshold;
    else
      out(i) = in(i);
    end
  end

  out = out / max(out);
  out = gain * out;

end
