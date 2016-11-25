-module(philosopher).
-export([]).

sleep(T,D)
	timer:sleep(T + random:uniform(D)).

start(Hungry, Right, Left, Name, Ctrl) ->
	spawn_link(fun() -> ... end).