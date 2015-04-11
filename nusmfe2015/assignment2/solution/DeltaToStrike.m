function strike = DeltaToStrike(F, T, ks, vs, d)
  f = @(k) (SimpleDelta(F, T, ks, vs, k)-d);
  cs = bisection(f, F*0.001, F*1000, 1e-6);
  strike = cs(1);
endfunction


#ds = [1:99]
#ks = []
#for d = 1:99
#    k(d) = DeltaToStrike(1, 1, [1,2, 3 ,4, 5], [0.2, 0.3, 0.3, 0.4, 0.7], d / 100)
#endfor
# plot(ds, ks)


## Author: Fabio Cannizzo
##
## bisection.m
##
## res = bisection (f, a, b, eps )
##
## f   : function handle
## a   : begin of interval
## b   : end of interval
## eps : accuracy

function [c,x] = bisection( f, a, b, eps )
fa = f(a);
fb = f(b);
i  = 1; x = [];
if (fa*fb > 0 ), error( "f(a)f(b)>0" );
endif
while (b-a > eps)
c  = (a+b)/2;
fc = f(c);
x(i,:)=[i, c, b-a]; i++;
# no need to waste time checking for zero, which is unlikely!
# if by chance it is zero, it is irrelevant which side we take
if (fc*fa<0), b = c;
else          a = c;
endif
endwhile
endfunction