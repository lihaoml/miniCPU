function call = euroBS(S, K, T, v, r, y)
  F = S * exp((r - y)*T);
  d1 = (log (F / K) + 0.5 * v * v * T) / v / sqrt(T);
  d2 = (log (F / K) - 0.5 * v * v * T) / v / sqrt(T);
  call = exp(-r*T) * (F * normcdf(d1) - K * normcdf(d2));
endfunction
