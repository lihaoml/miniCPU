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
  at = (exp(alpha * t) -1) / alpha;
  at2 = (exp(2*alpha * t) -1) / 2 / alpha;
  aTij = exp(-alpha *(Ti+Tj));
  a = sigmaL*sigmaL * (t - (exp(-alpha * Ti) + exp(-alpha * Tj)) * at + aTij * at2 );
  b = sigmaS*sigmaS * aTij * at2;
  c = rho * sigmaL * sigmaS * (exp(-alpha*Tj) * at - aTij * at2 );
  d = rho * sigmaL * sigmaS * (exp(-alpha*Ti) * at - aTij * at2 );
  e = a + b + c + d;
  e *= priceCurve(Ti) * priceCurve(Tj);
endfunction 