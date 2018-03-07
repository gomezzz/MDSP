function w = hammingWindow(Nk)
  %   hammingWindow    Computes a hanning Window
  %       w = hammingWindow(Nk) Computes a hamming Window w of size Nk
  Nk = Nk + 1;
  for i=0:Nk-1
    w(i+1) = 0.54 - 0.46 * cos ( 2 * pi * i / (Nk-1));
  end
  w(Nk) = [];
  w = w';
end
