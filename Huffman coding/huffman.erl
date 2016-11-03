%Huffman.erl
%2015-01-30

-module(huffman).
-compile(export_all).

sample() -> "the quick brown fox jumps over the lazy dog
this is a sample text that we will use when we build
up a table we will only handle lower case letters and
no punctuation symbols the frequency will of course not
represent english but it is probably not that far off".


%%%%%MAIN
compress(Text) ->
	ChrFreq = lists:keysort(2, chr_freq(Text)),
	Tree = tree(ChrFreq),
	ChrCodes = chr_codes(Tree),
	Dict = dict:from_list(ChrCodes),
	EncodedText = encode(Text, Dict).

decompress(Text, BitString) ->
	ChrFreq = lists:keysort(2, chr_freq(Text)),
	Tree = tree(ChrFreq),
	ChrCodes = chr_codes(Tree),
	Dict = dict:from_list(rev_tuple(ChrCodes)),
	DecodedText = decode(BitString, Dict).

%%%%% ENCODE
%Calculate character frequency
chr_freq(Str) ->
	chr_freq(Str, []).

chr_freq([], FreqList) ->
	FreqList;
chr_freq([H | Rest], FreqList) ->
	[{H, Num}, RestToCount] = chr_freq(Rest, H, 1, []),
	chr_freq(RestToCount, FreqList ++ [{H, Num}]).
	
chr_freq([], H, Num, RestToCount) ->
	[{H, Num}, RestToCount];
chr_freq([H | Rest], H, Num, RestToCount) ->
	chr_freq(Rest, H, Num + 1, RestToCount);
chr_freq([Other | Rest], H, Num, RestToCount) ->
	chr_freq(Rest, H, Num, RestToCount ++ [Other]).

%Create tree
tree([{N, _} | []]) ->
    N;
tree(Ns) ->
    [{N1, C1}, {N2, C2} | Rest] = lists:keysort(2, Ns),
    tree([{{N1, N2}, C1 + C2} | Rest]).

%Traverse tree and generate character codes
chr_codes({L, R}) ->
    chr_codes(L, "0") ++ chr_codes(R, "1").
 
chr_codes({L, R}, Chr_code) ->
    chr_codes(L, Chr_code ++ "0") ++ chr_codes(R, Chr_code ++ "1");
chr_codes(Chr, Chr_code) ->
    [{Chr, Chr_code}].

%Encode text by dictionary
encode(Text, Dict) ->
	encode(Text, Dict, []).

encode([], _Dict, Result) ->
	Result;
encode([H | Rest], Dict, Result) ->
	encode(Rest, Dict, Result ++ dict:fetch(H, Dict)).

%%%%% DECODE
%Reverse all tuples in list
rev_tuple(List) ->
	rev_tuple(List, []).
rev_tuple([], Result) ->
	Result;
rev_tuple([{K, V} | ListRest], Result) ->
	rev_tuple(ListRest, Result ++ [{V, K}]).

%Decode bits by dictionary
decode(BitString, Dict) ->
	decode(BitString, Dict, "").


decode(BitString, Dict, Result) ->
	decode("", BitString, Dict, Result).

decode(A, [], _Dict, Result) ->
	Result;
decode(Chr, [H | Rest], Dict, Result) ->
	case dict:is_key(Chr ++ [H], Dict) of
		true ->
			decode("", Rest, Dict, Result ++ [dict:fetch(Chr ++ [H], Dict)]);
		false ->
			decode(Chr ++ [H], Rest, Dict, Result)
	end.




%%%%%
%BENCHMARKING

asd(Text) ->

    statistics(runtime),
    statistics(wall_clock),

    ChrFreq = lists:keysort(2, chr_freq(Text)),
	Tree = tree(ChrFreq),
	ChrCodes = chr_codes(Tree),
	Dict = dict:from_list(ChrCodes),
	EncodedText = encode(Text, Dict),

    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    U1 = Time1 * 1000,
    U2 = Time2 * 1000,
    io:format("Code time=~p (~p) microseconds~n",
    [U1,U2]).

zxc(Text, BitString) ->

	
	ChrFreq = lists:keysort(2, chr_freq(Text)),
	Tree = tree(ChrFreq),
	ChrCodes = chr_codes(Tree),
	Dict = dict:from_list(rev_tuple(ChrCodes)),
	
    statistics(runtime),
    statistics(wall_clock),

	DecodedText = decode(BitString, Dict),

    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    U1 = Time1 * 1000,
    U2 = Time2 * 1000,
    io:format("Code time=~p (~p) microseconds~n",
    [U1,U2]).
