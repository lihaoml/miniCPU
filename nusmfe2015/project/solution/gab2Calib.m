function [sigmaL, sigmaS, rho, alpha] = gab2Calib(hist, tenors)
  histmat = histCovar(hist, tenors)
  dt = 1/250;
  f = @(params) objFun(histmat, dt, tenors, params(1), params(2), params(3), params(4));
  sigmaL_init = sqrt(histmat(length(tenors), length(tenors)) / dt)
  sigmaS_init = sqrt(histmat(1, 1) / dt)
  rho_init = histmat(1, length(tenors))  / dt / sigmaL_init / sigmaS_init
  init = [ sigmaL_init, sigmaS_init, rho_init, 0.5]

  [x] = sqp (init, f, [], @constraint);
  sigmaL = x(1); sigmaS = x(2); rho = x(3); alpha = x(4);
  f(x)
endfunction

function r = constraint(params)
  r = [ params(3) + 1; 1 - params(3);  # -1 <= rho <= 1
        params(2); params(1); params(2)-params(1); # sigmaS > sigmaL > 0
        params(4)];  # alpha > 0
endfunction
  
function err = objFun(histmat, dt, tenors, sigmaL, sigmaS, rho, alpha)
  err = 0;
  for i = 1:length(tenors)
    for j = 1:length(tenors)
      diff = modelCovar(sigmaL, sigmaS, rho, alpha, dt, tenors(i), tenors(j)) - histmat(i, j);
      err += diff * diff;
    endfor
  endfor
endfunction

function c = modelCovar(sigmaL, sigmaS, rho, alpha, dt, T1, T2)
  sigmaL2 = sigmaL * sigmaL;
  rSL = rho * sigmaS * sigmaL; 
  e1 = exp (-alpha * T1);
  e2 = exp (-alpha * T2);
  e3 = exp (alpha * dt);
  c = sigmaL2 * dt + (rSL - sigmaL2) * (e1 + e2) * (e3 - 1) / alpha \
    + (sigmaS * sigmaS + sigmaL2 - 2 * rSL) * (e1 * e2) * (e3 * e3 -1) / alpha / 2.0;
endfunction

function histmat = histCovar(hist)
  # daily log return series
  rets = zeros (rows(hist) -1, columns(hist));
  for i = 1:rows(hist)-1
    rets(i, :) = log(hist(i, :) ./ hist(i+1, :));
  endfor
  histmat = rets' * rets ./ (rows(hist)-1);
endfunction