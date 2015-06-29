function myPi (n)
  pi1 = myPi1(n);
  pi2 = myPi2(n);
  pi3 = myPi3(n);
  semilogy([1:length(pi1)], abs(pi1 - pi), "-r;myPi1;", 
           [1:length(pi2)], abs(pi2 - pi), "-g;myPi2;",
           [1:length(pi3)], abs(pi3 - pi), "-b;myPi3;");
  xlabel("nTerms");
  ylabel("error");
endfunction

function pi = myPi1 (nTerm)
  pi(1) = 0;
  for k = 0 : nTerm
    if mod (k, 2)
      pi(k+2) = pi(k+1) - 4 / (2 * k + 1);
    else
      pi(k+2) = pi(k+1) + 4 / (2 * k + 1);
    end
  end
endfunction
  
function pi = myPi2 (nTerm)
  pi(1) = 3;
  for k = 1 : nTerm
    if mod (k, 2)
      pi(k+1) = pi(k) + 1 / k / (k+1) / (2 * k + 1);
    else
      pi(k+1) = pi(k) - 1 / k / (k+1) / (2 * k + 1);
    end
  end
endfunction
  
function pi = myPi3 (nTerm)
  x1 = 1 / 5;
  x2 = 1 / 239;
  pi(1) = 4 * (4/5 - 1/239);
  for k = 1 : nTerm
    x1 = x1 * (2*(k-1) + 1) / (2*k+1) /25;
    x2 = x2 * (2*(k-1) + 1) / (2*k+1) / 239 / 239;
    if mod (k, 2)
      pi(k+1) = pi(k) - 16 * x1 + 4 * x2;
    else
      pi(k+1) = pi(k) + 16 * x1 - 4 * x2;
    end
  end
endfunction