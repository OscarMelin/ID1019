-module(env).
-export([new/0, add/3, lookup/2]).


new() ->
	[].

add(Id, Str, Env) ->
	Env ++ [{Id, Str}].
	
lookup(_, []) ->
	false;
lookup(Id, [{Id, Str} | _]) ->
	{Id, Str};
lookup(Id, [_ | R]) ->
	lookup(Id, R).