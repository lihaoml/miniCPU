function delta = SimpleDelta(F, T, ks, vs, K)
sigma = ImpliedVol(ks, vs, K);
d = log(F/K) / sigma / sqrt(T);
delta = normcdf(d);
endfunction