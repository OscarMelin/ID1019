-module(eager).
-export([eval_expr/2, eval_match/3, eval/1]).


%% Evaluetes expression and returns either {ok, S}
%% where S is a data structure, or error.
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
		end;
eval_expr({switch, _, []}, _) -> % No matches -> error.
	error;
eval_expr({switch, Exp, [{statement, Ptr, Seq} | R]}, Env) -> % Case handler.
	case eval_expr(Exp, Env) of % Check if valid expression.
		error ->
			error;
		{ok, _} ->
			case eval_match(Exp, Ptr, Env) of
				fail ->
					eval_expr({switch, Exp, R}, Env);
				{ok, _} ->
					eval_seq(Seq, Env)
			end
	end.		


%% Matches and returns either {ok, Env}, where Env is
%% an extended environment, or the atom fail.
eval_match(ignore, _, Env) ->
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
eval_match({cons, H, T}, {A , B}, Env)  ->
	case eval_match(H, A, Env) of % Match head first.
		fail ->
			fail;
		{ok, EnvNew} ->
			eval_match(T, B, EnvNew) % Match tail last.
	end;
eval_match(_, _, _) ->
	fail.

%%
%%
eval_seq([Exp], Env) ->
	eval_expr(Exp, Env);
eval_seq([{match, Ptr, Exp} | Seq], Env) ->
	case eval_expr(Exp, Env) of
		error ->
			error;
		{ok, Str} ->
			case eval_match(Ptr, Str, Env) of
				fail ->
					error;
				{ok, EnvNew} ->
					eval_seq(Seq, EnvNew)
			end
	end;
eval_seq([{switch, Exp, Statements} | Seq], Env) ->
	case eval_expr({switch, Exp, Statements}, Env) of
		error ->
			error;
		{ok, _} ->
			hej
	end.



eval(Seq) ->
	eval_seq(Seq, env:new()).



