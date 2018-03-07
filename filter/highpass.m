function filtered = highpass(signal,Fs,cutoff, id,Q)
  %  highpass implements a variety of highpass filters.

  if (id == 1)
    filtered = signal;
  elseif (id == 2)
    filtered = recursiveHP(signal);
  elseif (id == 3)
    filtered = biquadHP(signal,Fs,cutoff,Q);
  else
    filtered = signal;
  end
end

function filtered = recursiveHP(signal)

  N = length(signal);
  filtered(1) = signal(1);

  for i=2:N
      filtered(i) =  0.86 * filtered(i-1) + 0.93 * signal(i) - 0.93 * signal(i-1);
  end
end

function filtered = biquadHP(signal,Fs,cutoff,Q)
  w0 = 2 * pi * cutoff / Fs;

  w0cos = cos(w0);
  w0sin = sin(w0);

  Q = 1.0 / Q;

  % alpha = w0sin / (2*Q)
  alpha = w0sin * sinh(log(2)/2 * Q * w0/w0sin);


  a0 = 1 + alpha;

  b0 = (1.0 + w0cos) / (2.0 * a0);
  b1 = - (1.0 + w0cos) / a0;
  b2 = (1.0 + w0cos) / (2.0 * a0);
  a1 = (-2.0 * w0cos) / a0;
  a2 = (1.0 - alpha) / a0;


  d0 = 0.0;
  d1 = 0.0;

  for n=1:length(signal)
    filtered(n) = b0 * signal(n) + d0;
    d0 = b1 * signal(n) - a1 * filtered(n) + d1;
    d1 = b2 * signal(n) - a2 * filtered(n);
  end

end
