-module(manel).
-export([mandelbrot/6]).

mandelbrot(Width, Height, X, Y, K, Depth) ->
	Trans = fun(W, H) ->
		cmplx:new(X + K*(W-1), Y - K*(H-1))
		end,
	rows(Width, Height, Trans, Depth, []).

rows()
