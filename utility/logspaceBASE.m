function y = logspaceBASE(base,first,last,num)
  % logspaceBASE provides logarithmically spaced vector
  % y = logspaceBASE(base,first,last,num) gives a vector, range [first,last] with num logarithmically spaced values
  first = logN(first,base);
  last = logN(last,base);
  y = logspace(first * log10(base), last * log10(base),num);
end
