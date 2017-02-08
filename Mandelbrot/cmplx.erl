-module(mandelbrot).
-export([new/2, add/2, sqr/1, abs/1]).

% Returns the complex number with real value X and imaginary Y.
new(X, Y) ->
	{X, Y}.

% Adds two complex numbers.
add(A, B) ->
	case A of {X1, Y1} ->
		case B of {X2, Y2} ->
			{X1 + X2, Y1, Y2}.

% Squares a complex number.
sqr(A) ->
	case A of {X, Y} ->
		{X*X - Y*Y, 2*X*Y}.

% The absolute value of A.
abs(A) ->
	case A of {X, Y} ->
		math:sqrt(A*A + B*B).
