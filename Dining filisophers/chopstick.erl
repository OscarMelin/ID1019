-module(chopstick).
-export([start/0, request/1]).

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

request(Stick) ->
    Stick ! {request, self()},
    io:format("chopstick requested!~n"),
    receive
        ok ->
            ok
    end.

return(Stick) ->
    Stick ! return.

terminate(Stick) -> 
    Stick ! quit.