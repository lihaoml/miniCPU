function MyFirstDeriv(x0, h, ys)

# step a
# b1 * f(x - h) = b1 * [f(x) - f'(x)h + 1/2 f''(x)h^2 - 1/6 f'''(x)h^3]
# b2 * f(x - 1/2 h) = b2 * [f(x) - f'(x)1/2 h + 1/2 f''(x)1/4 h^2 - 1/6 f'''(x)1/8 h^3]
# b3 * f(x + 1/2 h) = b3 * [f(x) + f'(x)1/2 h + 1/2 f''(x)1/4 h^2 + 1/6 f'''(x)1/8 h^3]
# b4 * f(x + h) = b4 * [f(x) + f'(x)h + 1/2 f''(x)h^2 + 1/6 f'''(x)h^3]

# the linear system is

# -b1 - b2 1/2  + b3 1/2 + b4 = 1/h
# b1  + b2 1/4  + b3 1/4 + b4 = 0
# b1  + b2      + b3     + b4 = 0
# -b1 - 1/8 b2  + 1/8 b3 + b4 = 0

mat = [-1, -0.5, 0.5, 1; 1, 1/4, 1/4, 1; 1, 1, 1, 1; -1, -1/8, 1/8, 1];
os = [1/h;0;0;0];
bs = inv(mat) * os
cs_a = [bs(1), bs(2), 0, bs(3), bs(4)]
deriv_a = sum(cs_a .* ys)


# step b
ah = (ys(5) - ys(1)) / (2*h)
ah2 = (ys(4) - ys(2)) / (h)
#rh = (4 / 3 * ah2 - ah / 3)
cs_b = [1/6/h, -4/3/h, 0, 4/3/h, -1/6/h]
deriv_b = sum(cs_b .* ys)

# step c
# fit a polynomial  y = a4 x^4 + a3 x^3 + a2 x^2 + a1 x + a0
xs = [(x0-h)^4, (x0-h)^3, (x0-h)^2, (x0-h), 1;
      (x0-h/2)^4, (x0-h/2)^3, (x0-h/2)^2, (x0-h/2), 1;
      x0^4, 	x0^3, 	  x0^2,     x0,     1;
      (x0+h/2)^4, (x0+h/2)^3, (x0+h/2)^2, (x0+h/2), 1;
      (x0+h)^4, (x0+h)^3, (x0+h)^2, (x0+h), 1;]
as = inv(xs) * ys' 
cs_c = [x0^3*4, x0^2*3, x0*2, 1, 0] * inv(xs)
#deriv_c = as(1)*x0^3*4 + as(2) * x0^2 * 3 + as(3) * x0 * 2 + as(4)
deriv_c = sum(cs_c .* ys)

endfunction