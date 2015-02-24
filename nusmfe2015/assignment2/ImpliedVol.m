function sigma = ImpliedVol(ks, vs, strike)
# check input validity
  if (strike <= ks(1))
     sigma = vs(1);
  else if (strike >= ks(5))
     sigma = vs(5);
  else
     sigma = interp1(ks, vs, strike, "cubic");
  end
  end

endfunction