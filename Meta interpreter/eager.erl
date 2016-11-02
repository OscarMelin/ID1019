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

eval_match(ingore, _, Env) ->
	{ok, Env};
eval_match({atm, Id}, Id, Env) ->
	{ok, Env};
eval_match({var, Id}, V, Env) ->
	case env:lookup(Id, Env) of
		false ->
			{ok, env:add(Id, V, Env)}; % Add if not in environment.
		{Id, V} ->
			{ok, Env}; % Simply return if found in environment.
		{Id, _} ->
			fail % Var name already bound.
	end;

%eval_match({cons, ..., ...}, ..., Env)  ->
%	case eval_match(..., ..., ...) of
%		fail ->
%			fail;
%		{ok, ...} ->
%			eval_match(..., ..., ...)
%	end;
eval_match(_, _, _) ->
	fail.











