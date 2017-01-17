-module(chopstick).
-export([start/0, request/3, return/1, terminate/1]).

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

request(Left, Right, Timeout) ->
    Left ! {request, self()},
	Right ! {request, self()},    
	granted(Timeout).

granted(Timeout) ->
	receive
        ok ->
		receive
            ok ->
				ok
		end
	after 
		Timeout ->		
			no
    end.

return(Stick) ->
    Stick ! return.

terminate(Stick) -> 
    Stick ! quit.
