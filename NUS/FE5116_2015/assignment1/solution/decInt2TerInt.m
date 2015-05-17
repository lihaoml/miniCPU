function m = decInt2TerInt(decInt, nbits)
  m = zeros(1,nbits);
  for i = 1:nbits
    quotient = floor(decInt/3);
    m(nbits+1-i) = decInt-3*quotient;
	  decInt = quotient;
  endfor
  if decInt !=0
    fprintf("overflow.\n");
  endif
endfunction
