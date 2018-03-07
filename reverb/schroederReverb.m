function out = schroederReverb(in,n,feedback,dlys)
  %   schroederReverb applies a Schroeder reverb to the signal
  %       out = schroederReverb(in,n,feedback,dlys) Applies the reverb using n filters with sample delays given in dlys
  out = iircomb(in,feedback,dlys(1));

  for i=2:n
    out = iircomb(out,feedback,dlys(i+1));
  end

  out = out ./ max(abs(out)); %normalize output
end
