function v=europeanTrinomialPricerB(spot, sigma, rf, T, N, payoff)
  # Bolye parameters
  dt=T/N;
  u=exp(sigma*sqrt(2*dt));
  d=1/u;
  ss = exp((2*rf*T + sigma*sigma*T)/N);
  rr = exp( rf*T / N);
  pu = (ss - (d+1)*rr + d) / ((u-1)*(u-d));
  pd = (ss - (u+1)*rr + u) / ((1-d)*(u-d));
  pm=1-pu-pd;
  for i = 1 : (2*N+1)
      price(i) = payoff( spot * (u^(i-1-N)));
  endfor
  for i = 1:N
      for j = 1:(2*N+1-2*i)
         price(j) = price(j)*pd + price(j+1)*pm + price(j+2)*pu;
      endfor
  endfor
  v = exp(-rf*T) * price(1);  
endfunction