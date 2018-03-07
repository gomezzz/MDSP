function w = hanningWindow(Nk)
  %   hanningWindow    Computes a hanning Window
  %       w = hanningWindow(Nk) Computes a hanning Window w of size Nk
  Nk = Nk + 1;
  for i=0:Nk-1
    w(i+1) = 0.5 * ( 1.0 - cos(2*pi * i/(Nk-1)));
  end
  w(Nk) = [];
end
