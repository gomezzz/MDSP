function out = magTodBFS(in,A0)
  %   magTodBFS    Computes dbFS for the signal 
  %       out = magTodBFS(in,A0) Computes a dbFS of the signal given reference amplitude A0
  out = 20 * log10(in/A0);
end
