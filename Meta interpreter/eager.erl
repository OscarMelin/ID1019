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
eval_seq([{switch, _, []}, _], _) -> % No matches -> error.
        error;
eval_seq([{switch, Exp, [{statement, Ptr, Body} | R]} | Seq], Env) ->
	case eval_expr(Exp, Env) of
		error ->
			error;
		{ok, _} ->
			io:format("~n~p   ~p~n", [Ptr, Body]),
			case eval_match(Exp, Ptr, Env) of
				fail ->
					io:format("No match!~n"),
					io:format("Exp: ~p, Ptr: ~p, Env: ~p~n~n", [Exp, Ptr, Env]),
					eval_seq([{switch, Exp, R} | Seq], Env);
				{ok, _} ->
					io:format("Match found!~n"),
					io:format("eval_seq([~p] ++ ~p, ~p)~n~n", [Body, Seq, Env]),
					eval_seq([Body] ++ Seq, Env)
			end		
	end.




eval(Seq) ->
	eval_seq(Seq, env:new()).



