-module(chopstick).
-export([start/0, request/2, return/1, terminate/1]).

start() ->
    io:format("chopstick spawned!~n"),
    spawn_link(fun() -> availiable() end).

availiable() ->
    receive
        {request, Pid} ->
            Pid ! ok,
            gone();
        quit ->
            ok
    end.

gone() ->
    receive
        return ->
            availiable();
        quit ->
            ok
    end.

request(Stick, Timeout) ->
    Stick ! {request, self()},
    receive
        ok ->
            ok
	after 
		Timeout ->		
			no
    end.

return(Stick) ->
    Stick ! return.

terminate(Stick) -> 
    Stick ! quit.
