function out = saturate(in,level,id)
  %Different saturation fx using a variety of functions
  if (id == 1)
    out = sigSat(in,level);
  elseif (id == 2)
    out = tanSat(in,level);
  elseif (id == 3)
    out = jongSat(in,level);
  elseif (id == 4)
    out = pSat(in,level);
  else
    out = in;
  end
end

function out = pSat(in,level);
  for i=1:length(in)
    factor = 0.95 + 0.0 * sin(100*level*in(i));
    out(i) = factor * tanh(in(i) * level * pi);
  end
end

function out = sigSat(in,level)
  for i=1:length(in)
    if abs(in(i)) < level
      out(i) = in(i);
    else
      if in(i) > 0
        out(i) = level + (1.0 - level) * sigm((in(i) - level) / (1.0 - level)) ;
      else
        out(i) = -level + (1.0 - level) * sigm((-in(i) - level) / (1.0 - level)) ;
      end
    end
  end
end

function y = sigm(x)
  if abs(x) < 1
    y = x * (1.5 - 0.5 * x * x);
  else
    y = sign(x);
  end
end

function out = tanSat(in,level)
  for i=1:length(in)
    if abs(in(i)) < level
      out(i) = in(i);
    else
      if in(i) > 0
        out(i) = level + (1.0 - level) * tanh((in(i) - level) / (1.0 - level)) ;
      else
        out(i) = -level + (1.0 - level) * tanh((-in(i) - level) / (1.0 - level)) ;
      end
    end
  end
end

function out = jongSat(in,level)
  in = in + 1;
  for i=1:length(in)
    if in < level
      out(i) = in(i);
    elseif in > level
      tmp = ((in(i) - level)/(1-level)) * ((in(i) - level)/(1-level));
      out(i) = level + (in(i) - level) / (1 + tmp);
    elseif in > 1
      out(i) = (out + 1) / 2;
    end
  end

  out = out - 1;
end
