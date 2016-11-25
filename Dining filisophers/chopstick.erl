-module(chopstick).
-export([start/0]).

start() ->
    spawn_link(fun() -> availiable() end).

availiable() ->
    receive
        {request, Pid} ->
            gone();
        quit ->
            ok
    end.

gone() ->
    receive
        return ->
            availiable();
        quit ->
            okd
    end.
