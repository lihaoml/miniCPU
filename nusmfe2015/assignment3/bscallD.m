# analytic price for reference
function bs = bscallD(spot, sigma, rf, T, K, div_ts, div_rs)

  # dividend adjustment
  spotadj = spot
  for k = 1 : size(div_rs)
      spotadj *= 1-div_rs(k);
  endfor

  F = spotadj * exp(rf*T);
  K = 90;
  d1 = (log (F/K) + 0.5 * sigma * sigma * T) / sigma / sqrt(T);
  d2 = (log (F/K) - 0.5 * sigma * sigma * T) / sigma / sqrt(T);
  bs = exp(-rf*T) * (F * normcdf(d1) - K*normcdf(d2))

endfunction