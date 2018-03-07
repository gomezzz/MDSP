function out = dBFStoMag(in,A0)
  %   dBFStoMag    Computes mag for a signal in dbFS
  %       out = dBFStoMag(in,A0) Computes mag for a signal in dbFS given reference amplitude A0
  out = A0 * 10.^(in/20);
end
