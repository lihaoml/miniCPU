function model = gab2(sigmaL, sigmaS, rho, alpha)
  model.dt = 1 / 250;
  model.nfactor = 2;
  model.recon = @(market, rnds) reconFun(alpha, rho, sigmaS, sigmaL, rnds, market, model.dt);
endfunction

# reconstruction function: recon(ti, Ti) gives the observation on a simulation path.
function recon = reconFun(alpha, rho, sigmaS, sigmaL, rnds, market, dt)
  [dx, dy] = diffuse( alpha, rho, sigmaS, sigmaL, rnds, dt);
  recon = @(ti, Ti) reconst(market, alpha, rho, sigmaS, sigmaL, dx, dy, ti, Ti);
endfunction 

function obs = reconst(market, alpha, rho, sigmaS, sigmaL, dx, dy, ti, Ti)
  dt = 1 / 250;
  idx = ti / dt;
  x = sum(dx(1:idx));
  y = sum(dy(1:idx));
  ret = -0.5 * varianceLn(ti, Ti, alpha, rho, sigmaS, sigmaL) + x + exp(-alpha*Ti)*y;
  f0 = market.priceCurve(Ti);
  obs = f0 * exp(ret);
endfunction

function [dx, dy] = diffuse( alpha, rho, sigmaS, sigmaL, rnds, dt)
  corr = [1, rho; rho, 1];
  cholC = chol(corr);
	% correlate the brownians
  ws = cholC' * rnds;
  for i = 1:columns(rnds);
    t = i * dt;
    dx(i) = sigmaL * ws(1, i);
    dy(i) = (sigmaS * ws(2, i) - sigmaL * ws(1, i)) * exp(alpha * t);
  endfor
endfunction

function var = varianceLn(t, mat, alpha, rho, sigmaS, sigmaL)
  sigmaL2 = sigmaL * sigmaL;
  sigmaS2 = sigmaS * sigmaS;
  var = sigmaL2 * t + 2 * (rho * sigmaL2 - sigmaL2) * exp(-alpha * mat) * (exp(alpha*t) - 1) / alpha + (sigmaL2  + sigmaS2 - 2 * rho * sigmaS * sigmaL) * exp(-2 * alpha * mat) * (exp(2*alpha*t) - 1) / 2/ alpha;
endfunction
