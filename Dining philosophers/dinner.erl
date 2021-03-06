-module (dinner).
-export ([start/0]).

start() ->
	spawn(fun() -> init() end).

init() ->
	C1 = chopstick:start(),
	C2 = chopstick:start(),
	C3 = chopstick:start(),
	C4 = chopstick:start(),
	C5 = chopstick:start(),
	Ctrl = self(),
	philosopher:start(2, C1, C2, "1 Arendt", Ctrl),
	philosopher:start(2, C2, C3, "2 Hypatia", Ctrl),
	philosopher:start(2, C3, C4, "3 Simone", Ctrl),
	philosopher:start(2, C4, C5, "4 Elizabeth", Ctrl),
	philosopher:start(2, C5, C1, "5 Ayn", Ctrl),
	io:format("~n------------~n"),
	wait(5, [C1, C2, C3, C4, C5]).

wait(0, Chopsticks) ->
	lists:foreach(fun(C) -> chopstick:terminate(C) end, Chopsticks),
	io:format("~nAll done!~n");
wait(N, Chopsticks) ->
	receive
		done ->
			wait(N-1, Chopsticks);
		abort ->
			exit(abort)
end.
