function product = euroCall(ti, Ti, K, T)
  # a product needs to contain "lastTime" and "payoff" fields
  product.lastTime = ti;
  product.payoff = @(f) po(K, ti, Ti, f, T);
endfunction

# payoff returns the cash flow happens at T
function po = po(K, ti, Ti, f, T)
  po = [max(f(ti, Ti) - K, 0), T];
endfunction