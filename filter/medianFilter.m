function out = medianFilter(in,N)
  % out = medianFilter applies a median filter to the signal 'in' with a window size of N
  num_rows = size(in,1);
  num_cols = size(in,2);

  for i=1:num_rows

    neigh_i = getNeighbors(i,N,num_rows);

    for j=1:num_cols
      neigh_j = getNeighbors(j,N,num_cols);
      buffer = fillLocalBuffer(in,neigh_i,neigh_j,N);

      out(i,j) = median(buffer);
    end
  end
end

function neighbors = getNeighbors(i,N,dim_end)
  for k = 0:2*N
    neighbors(k+1) = max(1,min(dim_end,i+N-k)); %compute neighbors in x
  end
end

function buffer = fillLocalBuffer(in,neigh_i,neigh_j,N)
  index = 1;
  for i=1:(2*N)+1
    for j=1:(2*N)+1
        buffer(index) = in(neigh_i(i),neigh_j(j));
        index = index + 1;
    end
  end
end
