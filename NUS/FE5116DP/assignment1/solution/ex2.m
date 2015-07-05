function ex2(x,n)
  [res1, exp1] = myExp1(x, n);
  [res2, exp2] = myExp2(x, n);
  % plot with Y-axis in log-scale
  semilogy([1:n], abs(exp1 - exp(x)), [1:n], abs(exp2 - exp(x)))
  xlabel('n');
  ylabel('logerror');
  legend('myExp1','myExp2');
endfunction

function [res, exp1] = myExp1(x, n)
  for i = 1:n
    exp1(i) = (1+x/i)^i;
  endfor
  res = exp1(n);
endfunction

function [res, exp2] = myExp2(x, n)
  fac(1) = 1;
  exp2(1) = 1;
  for i = 2:n
    fac(i) = fac(i-1) * x / (i-1);
    exp2(i) = exp2(i-1) + fac(i);
  endfor
  res = exp2(n);
endfunction
