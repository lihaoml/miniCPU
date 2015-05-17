function market = market(tenors, prices, rf)
  market.priceCurve = @(Ti) interp1(tenors, prices, Ti, "linear", "extrap");
  market.df = @(T) exp(-rf*T);
endfunction