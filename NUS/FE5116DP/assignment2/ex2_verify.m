function ex2()
  r = 0.05
  r_a = 0.06
  r_b = 0.03
  sigma_a = 0.22
  sigma_b = 0.15
  rho = 0.5
  s_a0 = 100
  s_b0 = 95
  T = 2

  % verification for the case of p_a = s_a, p_b = s_b
  nPath = 5120
  p_a = @(s)s
  p_b = @(s)s
  BestOfMC(r, r_a, r_b, sigma_a, sigma_b, rho, s_a0, s_b0, T, p_a, p_b, nPath)

  sigma = sqrt(sigma_a*sigma_a + sigma_b* sigma_b - 2 * rho * sigma_a * sigma_b);
  d1 = (log (s_a0 / s_b0) + r_b - r_a + sigma * sigma * T / 2) / sigma / sqrt(T);
  d2 = d1 - sigma * sqrt(T);
  analytic = exp(-r_a*T)*s_a0*normcdf(d1) + exp(-r_b*T)*s_b0*(1 - normcdf(d2))


  
endfunction


function pv = BestOfMC(r, r_a, r_b, sigma_a, sigma_b, rho, s_a0, s_b0, T, p_a, p_b, nPath)
  corr = [1, rho; rho, 1];
  cholC = chol(corr);

  for i = [1:nPath]
    rnds(1, i) = normrnd(0, sqrt(T));
    rnds(2, i) = normrnd(0, sqrt(T));
  endfor
  % correlate the brownians
  ws = cholC' * rnds;
  for i = [1:nPath];
    s_at = s_a0 * exp ((r - r_a - 0.5 * sigma_a*sigma_a)*T + sigma_a * rnds(1, i));
    s_bt = s_b0 * exp ((r - r_b - 0.5 * sigma_b*sigma_b)*T + sigma_b * rnds(2, i));
    res(i) = max(p_a(s_at), p_b(s_bt));
  endfor
  pv = exp(-r*T) * mean(res);
endfunction

      
			
