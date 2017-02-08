-module(brot).
-export([mandelbrot/2]).

mandelbrot(C, M) ->
	Z0 = cmplx:new(0, 0),
	I = 0,
	test(I, Z0, C, M).

test(_, _, _, 0) ->
	0;
test(I, Z0, C, M) ->
	Z = cmplx:add(cmplx:sqr(Z0), C), % Zn+1 = Zn^2 + c
	Abs = cmplx:abs(Z),

	if
		Abs >= 2 -> I;
		true -> test(I+1, Z, C, M-1)
	end.
