function main

  # construct the market
  tenors = [1/12, 2/12, 3/12, 6/12, 9/12, 1, 1.5, 2, 3, 5, 7, 10];
  p0 = [43, 45, 47, 49.05, 50.37, 51.36, 52.3, 53.51, 54.6, 55.7, 57.24, 57.95];
  mkt = market(tenors, p0, rf = 0.02);
  
  # construct the payoff
  ti_s = [0.6, 0.7, 0.8, 0.9];  # observation dates
  Ti_s = [2, 2, 2, 2];
  product = asianCall(ti_s, Ti_s, K=50, T=1);
  
  # construct the model
  alpha = 0.5; rho = 0.8; sigmaS = 0.2; sigmaL = 0.05;
  model = gab2(sigmaL, sigmaS, rho, alpha);
  
  # mcprice
  npath = 256;
  priceAsian = mcprice(mkt, model, product, npath)
  
  product = euroCall(ti=1, Ti=2, K=50, T=1);
  priceCall = mcprice(mkt, model, product, npath)
endfunction

