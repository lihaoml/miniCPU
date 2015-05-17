function hist = genHist()
  tenors = [1/12, 2/12, 3/12, 6/12, 9/12, 1, 1.5, 2, 3, 5, 7, 10];
  p0 = [43, 45, 47, 49.05, 50.37, 51.36, 52.3, 53.51, 54.6, 55.7, 57.24, 57.95];
  # plot(tenors, p0);
  alpha = 0.5;
  rho = 0.8;
  sigmaS = 0.2;
  sigmaL = 0.05;
  hist = diffuseGab2(alpha, rho, sigmaS, sigmaL, tenors, p0);
  save tenors.mat tenors;
  save hist.mat hist;
endfunction

function var = varianceLn(t, mat, alpha, rho, sigmaS, sigmaL)
  sigmaL2 = sigmaL * sigmaL;
  sigmaS2 = sigmaS * sigmaS;
  var = sigmaL2 * t + 2 * (rho * sigmaL2 - sigmaL2) * exp(-alpha * mat) * (exp(alpha*t) - 1) / alpha + (sigmaL2  + sigmaS2 - 2 * rho * sigmaS * sigmaL) * exp(-2 * alpha * mat) * (exp(2*alpha*t) - 1) / 2/ alpha;
endfunction

function dynamics = diffuseGab2( alpha, rho, sigmaS, sigmaL, tenors, p0)
  corr = [1, rho; rho, 1];
  cholC = chol(corr);
  dt = 1 / 250;
  for i = [1:250]
    rnds(1, i) = normrnd(0, sqrt(dt));
    rnds(2, i) = normrnd(0, sqrt(dt));
  endfor
	% correlate the brownians
  ws = cholC' * rnds;
  x = 0;
  y = 0;
  for i = [1:250];
    t = i / 250;
    dx = sigmaL * ws(1, i);
    dy = (sigmaS * ws(2, i) - sigmaL * ws(1, i)) * exp(alpha * t);
    x += dx;
    y += dy;

    for j = [1:length(tenors)]
      mat = t + tenors(j);
      ret = -0.5 * varianceLn(t, mat, alpha, rho, sigmaS, sigmaL) + x + exp(-alpha*mat)*y;
      f0 = interp1(tenors, p0, mat, "linear", "extrap");
      f(i, j) = f0 * exp(ret);
    endfor
  endfor
  dynamics = f;
endfunction

      
			







												       
