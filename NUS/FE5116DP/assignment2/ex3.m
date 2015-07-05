function ex3()
  
  alpha = 0.5
  sigma = 0.2
  rf = 0.05
  expiry = 1
  T = 2
  K = 50

  nT=1000
  nZ=300

  Zmin = -5
  Zmax = 5

  % setup price curve
  delivs = [1/12, 2/12, 3/12, 6/12, 9/12, 1, 1.5, 2, 3, 5];
  prices = [43, 45, 47, 49.05, 50.37, 51.36, 52.3, 53.51, 54.6, 55.7]; 
  
  shifts = [-10:1:10];
  
  for k = 1:length(shifts)    
      priceCurve = @(T) interp1(delivs, prices + shifts(k), T, "linear", "extrap");
      pvs(k) = callOnFuturesPDE(priceCurve, alpha, sigma, rf, expiry, T, K, nT, nZ, Zmax, Zmin);
  endfor
  
  plot(shifts,pvs, '-+');
  pvs
  xlabel('shift');
  ylabel('price');

endfunction

% reconstruct F from Z
function F = recon(priceCurve, t, T, z, alpha, sigma)
  F = priceCurve(T)*exp(-sigma^2/4/alpha*exp(-2*alpha*T)*(exp(2*alpha*t)-1) + sigma*exp(-alpha*(T-t))*z);
endfunction

function res = callOnFuturesPDE(priceCurve, alpha, sigma, rf, expiry, T, K, nT, nZ, Zmax, Zmin)
  dt = expiry / nT;
  h = (Zmax-Zmin)/(nZ-1);
  zgrid = Zmin + h * [0:nZ-1];
  tgrid = [expiry:-dt:0];
    
  % initial value at t=expiry
  pz = max(recon(priceCurve, expiry, T, zgrid, alpha, sigma)-K, 0);
  
  % set up the matrix
  m = zeros(nZ, nZ);
  % Dirichlet boundary condition
  m(1, 1) = 1;
  m(nZ, nZ) = 1;
  for i = [2:nZ-1]
    m(i, i-1) = -(1/h+alpha*zgrid(i))*dt/2/h; % Ai
    m(i, i) = 1+(rf+1/h^2)*dt; % Bi
    m(i, i+1) = -(1/h-alpha*zgrid(i))*dt/2/h;  % Ci
  endfor
  m = inv(m);
  for i = [1:nT-1]
    % Dirichlet boundary condition
    pz(1) = max(recon(priceCurve, tgrid(i+1), T, Zmin, alpha, sigma)-K, 0);
    pz(nZ) = max(recon(priceCurve, tgrid(i+1), T, Zmax, alpha, sigma)-K, 0);
    pz = (m * pz')';
  endfor
  res = interp1( zgrid, pz, 0, "linear","extrap");
    
endfunction