function result = swapMax(n, k)
  if (k <= 0)
    result = n;
  else
    % construct the digits
    i = 0;
    while (n > 0)
      digit(++i) = n - floor(n / 10)*10;
      n = floor(n / 10);
    endwhile
    m = i;
    % one swap operation, check from m to 1, the first i where digit[i] is not the i'th largest number
    for i = m:-1:1
      rep (1:i) = digit(i);
      count = sum (digit(1:i) <= rep(1:i));
      if count < i % means i is the position to swap
		   % we just need to pick the largest digit before i
	max = digit(1);
	pos = 1;
	for j = 2:i
	  if digit(j) > max
	    pos = j;
	    max = digit(j);
	  endif
	endfor
	% swap the digits
	digit(pos) = digit(i);
	digit(i) = max;
	break;
      endif
    endfor
    if i == 1 % means the number is already the largest, so we should make the miminum damage
    % if there are duplicated numbers, we swap the duplication -- no damage and the number remains the same
      if sum(digit(1:m-1) - digit(2:m) == 0) == 0
	% otherwise we swap the last two digits
        tmp = digit(2);
	digit(2) = digit(1);
	digit(1) = tmp;
      endif
    endif
    % reconstruct the number
    n1 = 0;
    for j = m:-1:1
      n1 *= 10;
      n1 += digit(j);
    endfor
    result = swapMax(n1, k-1);
  endif
endfunction
