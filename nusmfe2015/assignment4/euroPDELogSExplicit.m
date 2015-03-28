% BS pde pricer with S the state variable
function pv = euroPDELogSExplicit(spot, expiry, r, y, sigma, payoff, nT, nS)
  range = 5 * sigma * sqrt(expiry)
  maxS = log(spot) + ( (r-y - 0.5 * sigma * sigma) * expiry + range)
  minS = log(spot) + ( (r-y - 0.5 * sigma * sigma) * expiry - range)   
  % equally spaced T and S dimensions
  k = expiry / nT
  h = (maxS-minS) / (nS-1)
  cond1 = k <= (h / sigma / maxS)^2
  cond2 = h <= sigma * sigma * minS / abs(r - y)
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

  for i = [1:nT-1]
    % linear boundary condition
    b0 = 2 * ps(1) - ps(2);
    b1 = 2 * ps(nS) - ps(nS - 1);
    ps = (m * [b0 ps b1]')';
  endfor
  pv = interp1( logsgrid, ps, log(spot), "linear");
endfunction
