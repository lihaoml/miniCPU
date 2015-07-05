function ex3
% (a)
  S = 100
  r = 0.02
  T = 1
  K = 102
  V = 8
  sigma = ImpliedVol(S,r,K,T,V)
  
% (b)
  ks = [78, 92, 102, 115, 130];
  vs = [0.30, 0.25, 0.20, 0.23, 0.28];
  for k = 1:200
    smile(k) = VolSmile(ks, vs, k);
  endfor
  figure(1)
  plot ([1:200],smile);

% (c)
  for k = 1:200
    prices(k) = bscall(S, r, k, T, smile(k));
  endfor
  figure(2)
  plot ([1:200], prices);

% (d)
  function p = pdfF(k, h)
    pleft = bscall(S, r, k-h, T, VolSmile(ks, vs, k-h));
    pright = bscall(S, r, k+h, T, VolSmile(ks, vs, k+h));
    pcenter = bscall(S, r, k, T, VolSmile(ks, vs, k));
    p = (pleft + pright - 2 * pcenter) / h / h * exp(r*T);
  endfunction

  for k = 1:200
    pdf(k) = pdfF(k, 0.5);
  endfor

  figure(3)
  plot([1:200], pdf);

% (e)
  pdfFun = @(si) (pdfF(si, 0.5))
  for k = 1:200
    pquad(k) = callQuad(S, r, T, pdfFun, 300, k);
  endfor
  pquad
  figure(4)
  plot([1:200], pquad);

endfunction

% (a)
function v = bscall(S, r, K, T, sigma)
  d1 = (log(S/K)+(r+(sigma^2)/2)*T)/(sigma*(sqrt(T)));
  d2 = (log(S/K)+(r-(sigma^2)/2)*T)/(sigma*(sqrt(T)));
  v = S*normcdf(d1) - K*exp(-r*T)*normcdf(d2);
endfunction

function sigma = ImpliedVol(S,r,K,T,V)
  f = @(vol) (bscall(S, r, K, T, vol) - V);
  sigma = bisection(f, 0.0001, 100, 1e-6);
endfunction

function [c,x] = bisection( f, a, b, eps )
  fa = f(a);
  fb = f(b);
  i  = 1; x = [];
  if (fa*fb > 0 ), error( "f(a)f(b)>0" );
  endif
  while (b-a > eps)
    c  = (a+b)/2;
    fc = f(c);
    x(i,:)=[i, c, b-a]; i++;
    if (fc*fa<0), b = c;
    else          a = c;
    endif
  endwhile
endfunction


%(b)
function sigma = VolSmile(ks,vs,strike)
if strike <= ks(1)
  sigma = vs(1);
else 
  if strike > ks(5)
    sigma = vs(5);
  else
    sigma = interp1 (ks, vs, strike, "spline");
  endif
endif
endfunction


% (e)
function v=callQuad(S, r, T, pdf, u, K) % u for the upper bound
  v=0;
  nInterv = 1000;
  dS = (u - K) / nInterv;
  for i=1:nInterv
    si=K + (i-1+0.5)*dS;
    v +=(si-K) * pdf(si) * dS;
  endfor
  v = v * exp(-r*T);
endfunction
