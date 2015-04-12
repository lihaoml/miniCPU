function pv = mm2Gab2AsianCall(sigmaL, sigmaS, rho, alpha, priceCurve, ti_s, Ti_s, K, rf, T)
  m = sum(arrayfun(priceCurve, Ti_s)) / length(Ti_s)
  v = 0;
  for i = 1:length(Ti_s)
    for j = 1:length(Ti_s)
      v += expectation (sigmaL, sigmaS, rho, alpha, priceCurve, ti_s(i), ti_s(j), Ti_s(i), Ti_s(j));
    endfor
  endfor
  v = v / length(Ti_s) / length(Ti_s);
  var = v / m / m
  d1 = (log (m/K) + 0.5 * var) / sqrt(var);
  d2 = (log (m/K) - 0.5 * var) / sqrt(var);
  bspv = exp(-rf*T) * (m * normcdf(d1) - K*normcdf(d2))
endfunction

function e = expectation (sigmaL, sigmaS, rho, alpha, priceCurve, ti, tj, Ti, Tj)
  t = min(ti, tj);
  a = sigmaL*sigmaL * (t - (exp(-alpha * Ti) + exp(-alpha * Tj))/alpha * (exp(alpha * t) -1) + exp(-alpha *(Ti+Tj))/2/alpha * (exp(2*alpha * t) -1) );
  b = sigmaS*sigmaS * exp(- alpha*(Ti + Tj)) / 2 / alpha * (exp(2*alpha * t) -1);
  c = rho * sigmaL * sigmaS * (exp(-alpha*Tj)/alpha * (exp(alpha * t) -1) - exp(-alpha*(Ti+Tj)) / alpha /2 * (exp(2*alpha * t) -1) );
  d = rho * sigmaL * sigmaS * (exp(-alpha*Ti)/alpha * (exp(alpha * t) -1) - exp(-alpha*(Ti+Tj)) / alpha /2 * (exp(2*alpha * t) -1) );
  e = a + b + c + d;
  e *= priceCurve(Ti) * priceCurve(Tj);
endfunction 