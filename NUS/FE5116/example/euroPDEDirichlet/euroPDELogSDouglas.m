% BS pde pricer with S the state variable
function pv = euroPDELogSDouglas(spot, expiry, r, y, sigma, payoff, nT, nS, w)
  % w = 1: explicity, w=0: implicit
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

  % set up the matrix z
  z = zeros(nS, nS);
  for i = [2:nS-1]
    z(i, i-1) = - ((r - y) - sigma*sigma/2 - sigma * sigma / h) * k / 2 / h; % Ai
    z(i, i) = - k * sigma * sigma / h / h - k * r; % Bi
    z(i, i+1) = (r - y - sigma*sigma/2 + sigma * sigma / h) * k / 2 / h;  % Ci
  endfor
  m = eye(nS) - (1-w) * z;
  % Dirichlet boundary condition
  m(1, 1) = 1; 
  m(nS, nS) = 1;
  % implicit scheme
  m = inv(m);

  b0 = payoff(exp(minS));
  b1 = payoff(exp(maxS));
  for i = [1:nT-1]
    % explicit scheme
    ps = ((eye(nS) + w*z) * ps')';
    % Dirichlet boundary condition
    ps(1) = b0;
    ps(nS) = b1; 
    ps = (m * ps')';
  endfor
  pv = interp1( logsgrid, ps, log(spot), "linear");
endfunction
