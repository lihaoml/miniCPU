% BS pde pricer with S the state variable
function pv = euroPDELogSImplicit(spot, expiry, r, y, sigma, payoff, nT, nS)
  % set the range of S to be 5 standard deviation of S at expiry
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
  m = zeros(nS, nS);
  % linear boundary condition
  m(1, 1) = 1; m(1, 2) = -2; m(1, 3) = 1;
  m(nS, nS-2) = 1; m(nS, nS-1) = -2; m(nS, nS) = 1;
  for i = [2:nS-1]
    m(i, i-1) = (r - y - sigma * sigma / 2 - sigma * sigma / h) * k / 2 / h; % Ai
    m(i, i) = 1 + k * sigma * sigma / h / h + k * r; % Bi
    m(i, i+1) = -(r - y - sigma * sigma / 2 + sigma * sigma / h) * k / 2 / h;  % Ci
  endfor
  m = inv(m);
  for i = [1:nT-1]
    % linear boundary condition (zero curvature)
    ps(1) = 0;
    ps(nS) = 0; 
    ps = (m * ps')';
  endfor
  pv = interp1( logsgrid, ps, log(spot), "linear");
endfunction
