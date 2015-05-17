function product = asianCall(ti_s, Ti_s, K, T)
  # a product needs to contain "lastTime" and "payoff" fields
  product.lastTime = max(ti_s);
  product.payoff = @(f) po(K, ti_s, Ti_s, f, T);
endfunction

# payoff returns the cash flow happens at T
function po = po(K, ti_s, Ti_s, f, T)
  a = 0;
  for i = 1 : length(ti_s)
    a += f(ti_s(i), Ti_s(i));
  endfor
  a = a / length(ti_s);
  po = [max(a - K, 0), T];
endfunction