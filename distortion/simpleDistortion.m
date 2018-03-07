function out = simpleDistortion(in,amount,id)
  %Applies simple distortion using either a atan or tanh function.
  if (id == 1)
    out = atan_dst(in,amount);
  elseif (id == 2)
    out = tanh_dst(in,amount);
  else
    out = in;
  end
end


function out = atan_dst(in,amount)
  for i=1:length(in)
    out(i) = atan(amount*in(i));
  end
end

function out = tanh_dst(in,amount)
  for i=1:length(in)
    out(i) = tanh(amount*in(i));
  end
end
