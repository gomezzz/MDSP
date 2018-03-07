function filtered = lowpass(signal,Fs,cutoff,res,id)
  %  lowpass implements a variety of lowpass filters.

  if (nargin < 5)
    filtered = biquad(signal,Fs,cutoff,0.75);
    return
  end

  if (id == 1)
    filtered = sincLP(signal,cutoff);
  elseif (id == 2)
    filtered = IIRLP(signal);
  elseif (id == 3)
    filtered = chebyshevType1SecondOrder(signal,Fs,cutoff, res);
  elseif (id == 4)
    filtered = biquad(signal,Fs,cutoff,0.75);
  elseif (id == 5)
    filtered = savitzky_golay(signal);
  else
    filtered = signal;
  end
end

function filtered = savitzky_golay(signal)
  N = length(signal);
  filtered(1:2) = signal(1:2);
  filtered(N-1:N) = signal(N-1:N);

  for i=3:N-2
    filtered(i) = 1/35 * (- 3 * signal(i-2) + 12 * signal(i-1) + 17 * signal(i) + 12 * signal(i+1) - 3 * signal(i+2));
  end

end

function filtered = IIRLP(signal)

  N = length(signal);
  filtered(1) = signal(1);

  for i=2:N
      filtered(i) =  0.85 * filtered(i-1) + 0.15 * signal(i);
  end
end

function filtered = sincLP(signal,cutoff)
  steps = 500;

  N = length(signal);

  buffer(1:steps) = 0;
  coeff = getBlackmanWindowCoeff(steps,cutoff);

  for i=1:N
    if (i < steps)
      filtered(i) = signal(i);
    else
      first = i - steps + 1;
      last = i;
      buffer(1:steps) = signal(first:last);
      filtered(i) = 0;
      for j=1:steps
        filtered(i) = filtered(i) + coeff(j) * buffer(j);
      end
    end
  end
end

function filtered = biquad(signal,Fs,cutoff,Q)
    filtered(1:length(signal)) = 0.0;

    w0 = 2 * pi * cutoff / Fs;

    w0cos = cos(w0);
    w0sin = sin(w0);

    Q = 1.0 / Q;

    % alpha = w0sin / (2*Q)
    alpha = w0sin * sinh(log(2)/2 * Q * w0/w0sin);


    a0 = 1 + alpha;

    b0 = (1.0 - w0cos) / (2.0 * a0);
    b1 = (1.0 - w0cos) / a0;
    b2 = (1.0 - w0cos) / (2.0 * a0);
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

function filtered = chebyshevType1SecondOrder(signal,Fs,cutoff,rippleRatio)

  %%Temporary computations
  K = tan(pi * cutoff/Fs); %prewarp

  sg = sinh(rippleRatio);
  cg = cosh(rippleRatio);
  cg = cg * cg;

  coeff0 = 1.0 / (cg - 0.85355339059327376220042218105097);
  coeff1 = K * coeff0 * sg * 1.847759065022573512256366378792;
  coeff2 = 1.0 / (cg - 0.14644660940672623779957781894758);
  coeff3 = K * coeff2 * sg * 0.76536686473017954345691996806;

  K = K * K;

  %%coefficients
  a0 = 1.0 / (coeff1 + K + coeff0);
  a1 = 2.0 * (coeff0-K) * a0;
  a2 = (coeff1 - K - coeff0) * a0;
  b0 = a0 * K;
  b1 = 2 * b0;
  b2 = b0;

  a3 = 1.0 / (coeff3 + K + coeff2);
  a4 = 2.0 * (coeff2 - K) * a3;
  a5 = (coeff3 - K - coeff2) * a3;
  b3 = a3 * K;
  b4 = 2 * b3;
  b5 = b3;

  state0 = 0.0;
  state1 = 0.0;
  state2 = 0.0;
  state3 = 0.0;

  for n=1:length(signal)
    stage1 = b0 * signal(n) + state0;
    state0 = b1 * signal(n) + a1 * stage1 + state1;
    state1 = b2 * signal(n) + a2 * stage1;
    filtered(n) = b3 * stage1 + state2;
    state2 = b4 * stage1 + a4 * filtered(n) + state3;
    state3 = b5 * stage1 + a5 * filtered(n);
  end
end

function coeff = getBlackmanWindowCoeff(steps,cutoff)
  for i=1:steps
    if i ~= steps/2
      coeff(i) = (sin(2*pi*cutoff*(i - steps/2)) / (i - (steps/2))) * (0.42 - 0.5 * cos(2*pi*i/steps) + 0.08*cos(4*pi*i/steps));
    else
      coeff(i) = 2*pi*cutoff;
    end
  end

  coeff;

  n = sum(abs(coeff));

  coeff(:) = coeff(:) ./ n;
end
