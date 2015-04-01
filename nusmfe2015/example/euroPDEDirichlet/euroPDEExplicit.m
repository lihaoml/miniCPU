% BS pde pricer with S the state variable
function pv = euroPDEExplicit(spot, expiry, r, y, sigma, payoff, nT, nS)
  range = 5 * sigma * sqrt(expiry)
  maxS = spot * exp( (r-y - 0.5 * sigma * sigma) * expiry + range)
  minS = spot * exp( (r-y - 0.5 * sigma * sigma) * expiry - range)   
  % equally spaced T and S dimensions
  k = expiry / nT
  h = (maxS-minS) / (nS-1)
  cond1 = k <= (h / sigma / maxS)^2
  cond2 = h <= sigma * sigma * minS / abs(r - y)
  sgrid = minS + h * [0:nS-1];
  
  % initial value
  ps = payoff( sgrid );

  % set up the matrix
  m = zeros(nS, nS+2);
  for i = [1:nS]
    m(i, i) = (-(r - y) + sigma * sigma * sgrid(i) / h) * k * sgrid(i) / 2 / h; % Ai
    m(i, i+1) = 1 - k * sigma * sigma * sgrid(i) * sgrid(i) / h / h - k * r; % Bi
    m(i, i+2) = (r - y + sigma * sigma * sgrid(i) / h) * k * sgrid(i) / 2 / h;  % Ci
  endfor

  for i = [1:nT-1]
    % Dirichlet boundary condition 
    b0 = payoff(minS - h);
    b1 = payoff(maxS + h);
    ps = (m * [b0 ps b1]')';
  endfor
  pv = interp1( sgrid, ps, spot, "linear");
endfunction
