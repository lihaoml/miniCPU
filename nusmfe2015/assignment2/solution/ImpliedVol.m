function sigma = ImpliedVol(ks, vs, strike)
# check input validity
assert(length(ks) == length(vs) && length(vs) == 5)
assert(ks > 0)
assert(vs > 0)
assert(ks(2:5) - ks(1:4) > 0) # strikes are given in ascending order
assert(strike > 0)
# interpolate
  if (strike <= ks(1))
     sigma = vs(1);
  else if (strike >= ks(5))
     sigma = vs(5);
  else
     sigma = interp1(ks, vs, strike, "spline");
  end
  end
endfunction