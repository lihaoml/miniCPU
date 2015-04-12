function market = market(tenors, prices, rf)
  market.priceCurve = @(mat) interp1(tenors, prices, mat, "linear", "extrap");
  market.df = @(T) exp(-rf*T);
endfunction