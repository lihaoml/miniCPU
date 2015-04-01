% BS pde pricer with S the state variable
function pv = euroPDELogSExplicit(spot, expiry, r, y, sigma, payoff, nT, nS)
  range = 5 * sigma * sqrt(expiry)
  maxS = log(spot) + ( (r-y - 0.5 * sigma * sigma) * expiry + range)
  minS = log(spot) + ( (r-y - 0.5 * sigma * sigma) * expiry - range)   
  % equally spaced T and S dimensions
  k = expiry / nT
  h = (maxS-minS) / (nS-1)
  logsgrid = minS + h * [0:nS-1];
  
  % initial value
  ps = payoff( exp(logsgrid) );

  % set up the matrix
  m = zeros(nS, nS+2);
  for i = [1:nS]
    m(i, i) = (-(r - y - sigma*sigma/2) + sigma * sigma  / h) * k / 2 / h; % Ai
    m(i, i+1) = 1 - k * sigma * sigma / h / h - k * r; % Bi
    m(i, i+2) = (r - y - sigma*sigma/2 + sigma * sigma / h) * k  / 2 / h;  % Ci
  endfor

  % Dirichlet boundary condition
  b0 = payoff(exp(minS-h));
  b1 = payoff(exp(maxS+h));
  for i = [1:nT-1]
    ps = (m * [b0 ps b1]')';
  endfor
  pv = interp1( logsgrid, ps, log(spot), "linear");
endfunction
