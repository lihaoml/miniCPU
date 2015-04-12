load("testData/tenors.mat")
load("testData/hist.mat")
[sigmaL, sigmaS, rho, alpha] = gab2Calib(hist, tenors)
priceCurve = @(t) interp1(tenors, hist(1, :), t);
sigmaL
ti_s = [0.1, 0.2, 0.3];
Ti_s = [1, 1, 1];
mm2Gab2AsianCall(sigmaL, sigmaS, rho, alpha, priceCurve, ti_s, Ti_s, 45, 0.01, 0.6)
mm2Gab2AsianCall(sigmaL, sigmaS, rho, alpha, priceCurve, ti_s, Ti_s, 50, 0.01, 0.6)


"degenerate case"
mm2Gab2AsianCall(sigmaS, sigmaS, 1.0, 0.1, priceCurve, [1], [1], 50, 0.01, 1)

# BS reference for degenerate case
var = sigmaS * sigmaS * 1.0
m = priceCurve(1)
K = 50;
rf = 0.01;
T = 1;
d1 = (log (m/K) + 0.5 * var) / sqrt(var);
d2 = (log (m/K) - 0.5 * var) / sqrt(var);
pv = exp(-rf*T) * (m * normcdf(d1) - K*normcdf(d2))



