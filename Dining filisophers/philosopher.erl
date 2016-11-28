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
	chopstick:request(Left),
	receive
		ok ->
			io:format("~s received a chopstick~n", [Name])
	end.