function v = americanBinomialPricerD(spot, sigma, rf, T, N, payoff, div_ts, div_rs)
  dt = T / N;
  mu = rf - 0.5 * sigma * sigma;
  # use log S as state variable
  # CRR parameters
  a = sqrt(1+ mu * mu / sigma / sigma * dt);
  u = sigma * sqrt(dt) * a;
  d = -u;
  p = 0.5 + mu / 2 / sigma * sqrt(dt) / a;
  # dividend adjustment
  spotadj = spot;
  for k = 1 : length(div_rs)
      spotadj *= 1-div_rs(k);
  endfor
  df = exp( -rf * dt );
  # terminal
  for i = 1 : (N+1)
      price(i) = payoff( spotadj * exp(2*(i-1)*u - N*u) );
  endfor

  for i = 0:(N-1)
    adj = 1;
    prevDiv = 0; # previous dividend payment time
    for k = 1 : length(div_ts)
    	if ( div_ts(k) <= dt * (N-i) )
        adj *= 1 - div_rs(k);
        prevDiv = k;
	    endif
    endfor
    # also need to check if the current time step is dividend time, 
    # if yes, do a max of payoff(S_before) and payoff(S_after)
    divrate = 0;
    isDivTime = false;
    if prevDiv > 0
      isDivTime = abs (dt * (N-i) - div_ts(prevDiv)) < 0.5 * dt;
      divadj = 1/(1-div_rs(prevDiv));
    endif
    if isDivTime == false && prevDiv < length(div_ts)
      isDivTime = abs (dt * (N-i) - div_ts(prevDiv+1)) < 0.5 * dt;
      divadj = 1-div_rs(prevDiv+1);
    endif
    
    for j = 1:(N-i)
      S = spot * adj * exp(2*(j-1)*u - (N-1-i)*u);
	    pS = payoff(S);
      if isDivTime
        pS = max(pS, payoff(S * divadj));
      endif
	    euro = price(j)*(1-p) + price((j+1))*(p);
      price(j) = max(df*euro, pS);
    endfor
  endfor
  v = price(1);
endfunction