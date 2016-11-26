-module(philosopher).
-export([]).

sleep(T,D)
	timer:sleep(T + random:uniform(D)).

start(Hungry, Right, Left, Name, Ctrl) ->
	spawn_link(fun() -> ... end).

eat(0, _, _, _, Ctrl) ->
	Ctrl ! done;
eat(Hungry, Right, Left, Name, Ctrl) ->
	chopstick:request(Left),
	chopstick:request(Right).