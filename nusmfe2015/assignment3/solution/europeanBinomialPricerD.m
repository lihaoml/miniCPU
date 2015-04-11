function v = europeanBinomialPricerD(spot, sigma, rf, T, N, payoff, div_ts, div_rs)
  dt = T / N
  mu = rf - 0.5 * sigma * sigma
  # use log S as state variable
  
  # CRR parameters
  a = sqrt(1+ mu * mu / sigma / sigma * dt)
  u = sigma * sqrt(dt) * a;
  d = -u;
  p = 0.5 + mu / 2 / sigma * sqrt(dt) / a;

  # dividend adjustment
  spotadj = spot;
  for k = 1 : length(div_rs)
      spotadj *= 1-div_rs(k)
  endfor
  spotadj
  for i = 1 : (N+1)
      price(i) = payoff( spotadj * exp(2*(i-1)*u - N*u) );
  endfor

  for i = 0:(N-1)
      for j = 1:(N-i)
         price(j) = price(j)*(1-p) + price((j+1))*(p);
      endfor
  endfor

  v = exp(-rf*T) * price(1);

  # analytic price for reference
  F = spotadj * exp(rf*T);
  K = 90;
  d1 = (log (F/K) + 0.5 * sigma * sigma * T) / sigma / sqrt(T);
  d2 = (log (F/K) - 0.5 * sigma * sigma * T) / sigma / sqrt(T); 
  bs = exp(-rf*T) * (F * normcdf(d1) - K*normcdf(d2))
endfunction