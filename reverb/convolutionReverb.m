function out = convolutionReverb(in)
  %   convolutionReverb applies a convolutional reverb to the signal. Currently only below convolutions are used
  %       out = convolutionReverb(in) Applies the reverb
  h = getIR();  %get an impulse response
  out = fconv(in,h);  %apply the convolution in fourier space (faster)
end

function h = getIR()
  %Creates some impulse response. Insert a better one for this to make sense.

  length = 10000;
  Fs = 44100;
  f   = 400;
  amp = 1.0;
  t  = linspace(0,length,Fs*length);
  h(1:length) = 0.0;


  % reversed saw response
  for i=1:length
    for k=1:7
      h(i) = h(i) + (amp/(k*pi))*sin(2*pi*k*f*t(i));
    end
  end

  % for i=1:length
  %     if mod(i,2) == 0
  %       h(i) = sin(rand*pi*i*t(i)*f);
  %     else
  %       h(i) = 0;
  %     end
  % end

  % for i=1:length
  %   h(i) = (length-i)/length * 2 * (rand()-0.5);
  % end
end

function y = fconv(in,h)
  % fconv applies a convolution using the impulse response h to the signal 'in' in fourier space. Convolution in fourier space has
  % linear complexity.


  %desired length
  % Ly = length(in) + length(h) - 1;
  Ly = length(in);

  % find closest power of 2 > Ly
  Ly2 = pow2(nextpow2(Ly));

  X = fft(in,Ly2); %ffts
  H = fft(h, Ly2);
  Y = X.*H; %convolution in frequency domain
  y = real(ifft(Y,Ly2)); %back to timedomain
  y = y(1:1:Ly);
  y = y/max(abs(y)); %normalize

end
