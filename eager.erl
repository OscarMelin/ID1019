-module(eager).
-export([eval_expr/2]).

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
			case eval_expr({atm, T}, Env) of %Not needed? Cant return error.
				error ->
					error;
				{ok, T} ->
					{ok, {V, T}}
			end
	end.