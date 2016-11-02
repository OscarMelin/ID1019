-module(eager).
-export([eval_expr/2]).

eval_expr({atm, Id}, _) ->
	{ok, Id};
eval_expr({var, Id}, Env) ->
	case expression of
		false ->
			error;
		... ->
			{ok, ..}
	end;
eval_expr({cons, ..., ...} Env) ->
	case ... of
		error ->
			...;
		{ok, ...} ->
			case ... of
				error ->
					error;
				{ok, ...} ->
					{ok, {..., ...}}
			end
	end.