function q3v
  S = 100
  K = 100
  T = 1
  v = 0.2
  r = 0.05
  n = 1000
  analytic = BS(S, K, T, v, r)
  PutIntegral(S, K, T, v, r, n);
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
  interv = K / n;
  ff = @(si) (f(S, K, v, r, T, si));
  ss = ([1:n] - 0.5) * interv;
  ps = arrayfun(ff,ss) * interv;
  put = sum(ps) * exp(-r*T);
endfunction

function put = PutIntegralS(S, K, T, v, r, n)
  needMid = mod(n, 2); 
  interv = K / n;
  ff = @(si) (f(S, K, v, r, T, si));
  # if the number of intervals is even, left = 0, 
  # then no need mid-point for the first segment
  if needMid == 1
    put = ff(0.5 * interv) * interv;
  else
    put = 0;
  endif
  ss = [needMid:n]*interv;
  ps = arrayfun(ff,ss);
  nn = length(ss);
  put += interv*(ps(1) + ps(nn) + 4 * sum(ps(2:2:(nn-1))) + 2 * sum(ps(3:2:nn-2))) / 3;
  put = put * exp(-r*T);
endfunction

function p = f(S, K, v, r, T, si)
  if si > 0 
    p = 1 / (v*si*sqrt(2*pi*T)) * exp( -(log(si/S) - r*T + 0.5*v*v*T)^2/(2*v*v*T) );
  else 
    p = 0;
  endif
  p *= (K-si);
endfunction

