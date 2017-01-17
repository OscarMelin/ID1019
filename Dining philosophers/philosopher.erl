-module(philosopher).
-export([start/5]).

sleep(T,D) ->
	timer:sleep(T + random:uniform(D)).

start(Hungry, Right, Left, Name, Ctrl) ->

	{A, B, C} = now(),
	spawn_link(fun() ->
	random:seed(A, B, C),
	eat(Hungry, Right, Left, Name, Ctrl) end),
	io:format("~s spawned!~n", [Name]).

eat(0, _, _, _, Ctrl) ->
	Ctrl ! done;
eat(Hungry, Right, Left, Name, Ctrl) ->

	%{L, R} = {chopstick:request(Left), chopstick:request(Right)},

	sleep(100, 500),
	Chopsticks = chopstick:request(Left, Right, 100),
	
	case Chopsticks of
		ok ->
			Remaining = Hungry - 1,
			io:format("~s received two chopsticks~n", [Name]),
			sleep(100, 500),
			chopstick:return(Left),
			chopstick:return(Right),
			io:fwrite("~s done, ~w remaining~n", [Name, Remaining]),
			eat(Remaining, Right, Left, Name, Ctrl);
		no ->
			chopstick:return(Left),
			io:fwrite("~s dropped left~n", [Name]),
			chopstick:return(Right),
			io:fwrite("~s dropped right~n", [Name]),
			eat(Hungry, Right, Left, Name, Ctrl)
	end.
