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

	%{L, R} = {chopstick:request(Left), chopstick:request(Right)},

	L = chopstick:request(Left, 100),
	sleep(10, 20),
	R = chopstick:request(Right, 100),

	case {L, R} of
		{ok, ok} ->
			Remaining = Hungry - 1,
			io:format("~s received two chopsticks~n", [Name]),
			sleep(100, 500),
			chopstick:return(Left),
			chopstick:return(Right),
			io:fwrite("~s done, ~w remaining~n", [Name, Remaining]),
			eat(Remaining, Right, Left, Name, Ctrl);
		{no, _} ->
			chopstick:return(Left),
			sleep(10, 20),
			eat(Hungry, Right, Left, Name, Ctrl);
		{_, no} ->
			chopstick:return(Right),
			sleep(10, 20),
			eat(Hungry, Right, Left, Name, Ctrl)
	end.
