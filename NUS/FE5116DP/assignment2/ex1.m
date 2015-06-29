function ex1
  sigma = 0.2
  rf = 0.04
  strike = 100
  T = 2
  N = 100
  q = 0.0
  df = exp(-rf * T);
  
  for i = 1:101
    spots(i) = i + 49;
    spot = spots(i);
    treeEuroPrice(i) = europeanStraddleBinomialPricerD(spot, sigma, rf, T, N, strike, q);

    % analytic price
    fwd = spot * exp((rf - q)*T);
    d1 = (log(fwd / strike) + 0.5 * sigma * sigma * T) / sigma / sqrt(T);
    d2 = (log(fwd / strike) - 0.5 * sigma * sigma * T) / sigma / sqrt(T);
    call = df * (fwd * normcdf(d1) - strike * normcdf(d2));
    put = df * (strike * normcdf(-d2) - fwd * normcdf(-d1) );
    analyticPrice(i) = call + put;

    % american straddle
    treeAmerPrice(i) = americanStraddleBinomialPricerD(spot, sigma, rf, T, N, strike, q);
  endfor

  plot(spots, treeEuroPrice, 'r', spots, analyticPrice, 'b', spots, treeAmerPrice, 'g');
  legend("tree european price", "analytic european price", "tree american straddle");
endfunction


function res = europeanStraddleBinomialPricerD( spot, sigma, rf, T, N, strike, q)
  # CRR parameters
  mu = rf - q - 0.5 * sigma * sigma;
  dt = T / N;
  a = sqrt(1+ mu * mu / sigma / sigma * dt);
  u = sigma * sqrt(dt) * a;
  d = -u;
  p = 0.5 + mu / 2 / sigma * sqrt(dt) / a;

  for i = 1 : (N+1)
    s = spot * exp(2*(i-1)*u - N*u);
    price(i) = max( s - strike, strike -s);
  endfor

  for i = 0:(N-1)
    for j = 1:(N-i)
      price(j) = price(j)*(1-p) + price((j+1))*(p);
    endfor
  endfor
  res = exp(-rf*T) * price(1);
endfunction


function res = americanStraddleBinomialPricerD( spot, sigma, rf, T, N, strike, q)
# CRR parameters
  mu = rf - q - 0.5 * sigma * sigma;
  dt = T / N;
  a = sqrt(1+ mu * mu / sigma / sigma * dt);
  u = sigma * sqrt(dt) * a;
  d = -u;
  p = 0.5 + mu / 2 / sigma * sqrt(dt) / a;

  for i = 1 : (N+1)
    s = spot * exp(2*(i-1)*u - N*u);
    price(i) = max( s - strike, strike -s);
  endfor

  for i = 0:(N-1)
    for j = 1:(N-i)
      price(j) = price(j)*(1-p) + price((j+1))*(p);
      s = spot * exp( 2 * (j-1)*u - (N-i-1)*u);
      price(j) = max(price(j), max(s - strike, strike -s));
    endfor
  endfor
  res = exp(-rf*T) * price(1);
endfunction  
