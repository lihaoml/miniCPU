function call = bscall(S, K, T, v, r)
d1 = (log (S / K) + (r + 0.5 * v * v) * T) / v / sqrt(T);
d2 = (log (S / K) + (r - 0.5 * v * v) * T) / v / sqrt(T);
call = - K * exp(-r*T) * normcdf(d2) + S * normcdf(d1);
endfunction