-module(eager).
-export([eval_expr/2, eval_match/3]).


%% Returns either {ok, S} where S is a data structure, or error.
eval_expr({atm, Id}, _) ->
	{ok, Id};
eval_expr({var, Id}, Env) ->
	case env:lookup(Id, Env) of
		false ->
			error;
		{Id, Str} ->
			{ok, Str}
	end;
eval_expr({cons, {var, H}, {atm, T}}, Env) ->
	case eval_expr({var, H}, Env) of
		error ->
			error;
		{ok, V} ->
			{ok, {V, T}}
	end.

