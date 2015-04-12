function v = europeanTrinomialPricerCRR(spot, sigma, rf, T, N, payoff)
  dt = T / N / 2;
  mu = rf - 0.5 * sigma * sigma;
  # use log S as state variable
  
  # CRR parameters
  a = sqrt(1+ mu * mu / sigma / sigma * dt);
  u = sigma * sqrt(dt) * a;
  d = -u;
  p = 0.5 + mu / 2 / sigma * sqrt(dt) / a;

  for i = 1 : (2*N+1)
      price(i) = payoff( spot * exp(2*u*(i-1-N)) );
  endfor  

  for i = 1:N
      for j = 1:(2*N+1-2*i)
         price(j) = price(j)*(1-p)*(1-p) + 2*price(j+1)*(1-p)*p + price(j+2)*p*p;
      endfor
  endfor
  v = exp(-rf*T) * price(1);
endfunction