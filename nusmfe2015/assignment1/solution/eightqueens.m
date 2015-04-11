function eightqueens(n)
  if (PlaceQ(n, [], 1))
    "solution found"
  else
    "no solution found"
  end
endfunction

# check if it is safe to place a queen at (row, col)
# given the previous queens before column (col - 1) are placed in prevQ
function safe = isSafe (row, col, prevQ)
  safe = true;
  for i = 1:(col-1)
    # horizontal or diagonal
    if (prevQ(i) == row || prevQ(i) - i == row - col || prevQ(i) + i == row + col)  
      safe = false;
    endif
  endfor
endfunction
  
# place the queen for the column "col" given the previous placement (before col) in prevQ
function succeed = PlaceQ(n, prevQ, col)
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
        if ( PlaceQ(n, prevQ, col+1) )
          succeed = true;
	  return; # so that we stop when one solution is found
        endif
      endif
    endfor
  end
endfunction
