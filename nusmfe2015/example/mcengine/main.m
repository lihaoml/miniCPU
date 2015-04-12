function main

  # construct the market
  tenors = [1/12, 2/12, 3/12, 6/12, 9/12, 1, 1.5, 2, 3, 5, 7, 10];
  p0 = [43, 45, 47, 49.05, 50.37, 51.36, 52.3, 53.51, 54.6, 55.7, 57.24, 57.95];
  mkt = market(tenors, p0, 0.02);
  
  # construct the payoff
  ti_s = [1, 1.1, 1.2, 1.3];  # observation dates
  Ti_s = [2, 2, 2, 2];
  product = asianCall(ti_s, Ti_s, 50, 1.3);
  
  # construct the model
  alpha = 0.5; rho = 0.8; sigmaS = 0.2; sigmaL = 0.05;
  model = gab2(sigmaL, sigmaS, rho, alpha);
  
  # mcprice
  npath = 256;
  price = mcprice(mkt, model, product, npath)
  
  product = euroCall(1, 2, 50, 1);
  price = mcprice(mkt, model, product, npath)
endfunction

