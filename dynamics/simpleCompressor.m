function out = simpleCompressor(in,time,Fs)
  % simpleCompressor applies a compressor with a fixed envelope, ratio and slope

  indBFS = magTodBFS(in,1.0);

  in = getEnv(in,time,Fs);

  ratio = 8.0;
  slope = 1.0 - (1.0/ratio);
  threshold = -12.0;

  for i=1:length(in)
    if ( indBFS(i) > threshold)
      indBFS(i) = indBFS(i) + slope * (threshold - indBFS(i));
    end
  end

  out = dBFStoMag(indBFS,1.0);
end

%TODO
function env = getEnv(in,time,Fs)
  g = e^(-1/(time*Fs))

  for i=1:length(in)
    env(i) = in(i) + g * in(i);
  end
end
