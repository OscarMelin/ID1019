-module(chopstick).
-export([start/0, request/1, return/1, terminate/1]).

start() ->
    io:format("chopstick spawned!~n"),
    spawn_link(fun() -> availiable() end).

availiable() ->
    receive
        {request, Pid} ->
            io:format("chopstick request recieved!~n"),
            Pid ! ok,
            gone();
        quit ->
            ok
    end.

gone() ->
    receive
        return ->
            availiable(),
            io:format("chopstick availiable!~n");
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
    io:format("returning chopstick!~n"),
    Stick ! return.

terminate(Stick) -> 
    Stick ! quit.