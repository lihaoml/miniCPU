% BS pde pricer with S the state variable
function pv = euroPDEImplicit(spot, expiry, r, y, sigma, payoff, nT, nS)
  % set the range of S to be 5 standard deviation of S at expiry
  range = 5 * sigma * sqrt(expiry) 
  maxS = spot * exp( (r-y - 0.5 * sigma * sigma) * expiry + range)
  minS = spot * exp( (r-y - 0.5 * sigma * sigma) * expiry - range)
  % equally spaced T and S dimensions
  k = expiry / nT
  h = (maxS-minS) / (nS-1)
  sgrid = minS + h * [0:nS-1];
  % initial value
  ps = payoff( sgrid );

  % set up the matrix
  m = zeros(nS, nS);
  % Dirichlet boundary condition
  m(1, 1) = 1;
  m(nS, nS) = 1;
  for i = [2:nS-1]
    m(i, i-1) = ((r - y) - sigma * sigma * sgrid(i) / h) * k * sgrid(i) / 2 / h; % Ai
    m(i, i) = 1 + k * sigma * sigma * sgrid(i) * sgrid(i) / h / h + k * r; % Bi
    m(i, i+1) = -(r - y + sigma * sigma * sgrid(i) / h) * k * sgrid(i) / 2 / h;  % Ci
  endfor
  m = inv(m);
  for i = [1:nT-1]
    % linear boundary condition (zero curvature)
    ps(1) = payoff(minS);
    ps(nS) = payoff(maxS); 
    ps = (m * ps')';
  endfor
  pv = interp1( sgrid, ps, spot, "linear");
endfunction
