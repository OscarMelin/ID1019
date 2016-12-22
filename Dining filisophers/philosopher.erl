-module(philosopher).
-export([start/5]).

sleep(T,D) ->
	timer:sleep(T + random:uniform(D)).

start(Hungry, Right, Left, Name, Ctrl) ->
	spawn_link(fun() -> eat(Hungry, Right, Left, Name, Ctrl) end),
	io:format("~s spawned!~n", [Name]).

eat(0, _, _, _, Ctrl) ->
	Ctrl ! done;
eat(Hungry, Right, Left, Name, Ctrl) ->

	{L, R} = {chopstick:request(Left), chopstick:request(Right)},

	case {L, R} of
		{ok, ok} ->
			io:format("~s received two chopsticks~n", [Name]),
			sleep(100, 500),
			chopstick:return(Left),
			chopstick:return(Right),
			io:format("~s done~n", [Name])
	end,
	eat(Hungry - 1, Right, Left, Name, Ctrl).
