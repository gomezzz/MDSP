function out = bitcrusher(in,bitrate,bitdepth,gain,Fs)
  %Applies a simple bitcrusher 
  
    max = 2.^bitdepth - 1;
    step = Fs / bitrate
    i = 1;
    while (i <= length(in))
        first = rnd((in(i) + 1.0) * max) / max - 1.0;
        j = 0;
        while ( j < step && i <= length(in))
          out(i) = first;
          i=i+1;
          j=j+1;
        end
    end
end

function out = rnd(in)
  if (in > 0.0)
    out = floor(in + 0.5);
  else
    out = ceil(in - 0.5);
  end
end
