-module(chopstick).
-export([start/0]).

start() ->
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
            okd
    end.

request(Stick) ->
    Stick ! {request, self()},
        receive
            ok ->
                ok
        end.

return(Stick) ->
    Stick ! return.

terminate(Stick) -> 
    Stick ! quit.