function eightqueens(n)

  # check if it is safe to place a queen at (row, col)
  # given the previous queens before column (col - 1) are placed in prevQ
  function safe = isSafe (row, col, prevQ)
  safe = true;
  for i = 1:(col-1)
    if (prevQ(i) == row || prevQ(i) - i == row - col || prevQ(i) + i \
	== row + col)  # horizontal or diagonal
      safe = false;
    endif
  endfor
  endfunction
  
  # place the queen for the column "col" given the previous placement (before col) in prevQ
  function succeed = place(prevQ, col)
  succeed = false;
  if (col > n)
    succeed = true;
    # display solution
    solutionMat = zeros(n, n);
    for i = 1:n
      solutionMat(i, prevQ(i)) = 1;
    endfor
    solutionMat
  else
    for r = 1:n  # check each (r, col)
      if ( isSafe (r, col, prevQ) ) # go to next column
        prevQ(col) = r;
        if ( place(prevQ, col+1) )
          succeed = true;
          return;
        endif
      endif
    endfor
  end
  endfunction

  if (place([], 1))
    "solution found"
  else
    "no solution found"
  end
endfunction
