function pv = mcprice(market, model, product, npath)
  dt = model.dt;
  nsteps = ceil( product.lastTime / dt);
  pv = 0;
  for i = 1 : npath
    # generate random numbers
    for j = [1:nsteps]
      for k = 1:model.nfactor
        rnds(k, j) = normrnd(0, sqrt(dt));
      endfor
    endfor
    # pass the random numbers to the model diffusion
    # and generate observers
    fobs = model.recon(market, rnds);
    cashflows = product.payoff(fobs);
    # discount the cashflows
    dfs = market.df(cashflows(:, 2));
    pv += sum(cashflows(:, 1) .* dfs);
  endfor
  pv = pv / npath;
endfunction