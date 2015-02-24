function q3(S, K, T, v, r, n)
analytic = BS(S, K, T, v, r)
num1 = PutIntegral(S, K, T, v, r, n)
endfunction

function put = BS(S, K, T, v, r)
d1 = (log (S / K) + (r + 0.5 * v * v) * T) / v / sqrt(T);
d2 = (log (S / K) + (r - 0.5 * v * v) * T) / v / sqrt(T);
put = K * exp(-r*T) * normcdf(-d2) - S * normcdf(-d1);
endfunction

function put = PutIntegral(S, K, T, v, r, n)
put  = 0;
for i = 1:n
    si = (i - 0.5) * (K / n);
    p = 1 / (v*si*sqrt(2*pi*T)) * exp( -(log(si/S) - r*T + 0.5*v*v*T)^2/(2*v*v*T) );
    put += (K-si) * p * (K / n);
endfor
put = put * exp(-r*T)
endfunction




