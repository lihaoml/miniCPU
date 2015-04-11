function q3
  S = 100
  K = 100
  T = 1
  v = 0.2
  r = 0.05
  n = 1000
  analytic = BS(S, K, T, v, r)
  for i = 3:n
    num1(i-2) = PutIntegral(S, K, T, v, r, i);
    num2(i-2) = PutIntegralS(S, K, T, v, r, i);
  endfor
  semilogy([3:n], abs(num1 - analytic), "-b;MidPoint;", 
           [3:n], abs(num2 - analytic), "-r;Simpson;");
endfunction

function put = BS(S, K, T, v, r)
  d1 = (log (S / K) + (r + 0.5 * v * v) * T) / v / sqrt(T);
  d2 = (log (S / K) + (r - 0.5 * v * v) * T) / v / sqrt(T);
  put = K * exp(-r*T) * normcdf(-d2) - S * normcdf(-d1);
endfunction

function put = PutIntegral(S, K, T, v, r, n)
  put  = 0;
  interv = K / n;
  for i = 1:n
    si = (i - 0.5) * interv;
    put += (K-si) * lognpdf(S, v, r, T, si) * interv;
  endfor
  put = put * exp(-r*T);
endfunction

function put = PutIntegralS(S, K, T, v, r, n)
  put  = 0;
  needMid = mod(n, 2); 
  interv = K / n;
  # if the number of intervals is even, left = 0, 
  # then no need mid-point for the first segment
  for i = 1:needMid
    si = (i - 0.5) * interv;
    put += (K-si) * lognpdf(S, v, r, T, si) * interv;
  endfor

  for i = 0:(floor(n/2)-1)
    si0 = (2*i + needMid) * interv;
    si1 = (2*i + 1 + needMid) * interv;
    si2 = (2*i + 2 + needMid) * interv;
    put += ( (K-si0) * lognpdf(S, v, r, T, si0) 
           + (K-si1) * lognpdf(S, v, r, T, si1) * 4
           + (K-si2) * lognpdf(S, v, r, T, si2) )* interv / 3;
  endfor
  put = put * exp(-r*T);
endfunction

function p = lognpdf(S, v, r, T, si)
  if si > 0 
    p = 1 / (v*si*sqrt(2*pi*T)) * exp( -(log(si/S) - r*T + 0.5*v*v*T)^2/(2*v*v*T) );
  else 
    p = 0;
  endif
endfunction

