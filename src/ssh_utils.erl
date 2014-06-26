-module(ssh_utils).

-export([get_server_key_path/0, get_client_key_path/0]).


get_path(Pasta) ->
  {ok, Cwd} = file:get_cwd(),
  filename:join(filename:join(lists:delete("src", filename:split(Cwd))), Pasta).
%  S = filename:split(Cwd),
%  S1 = lists:delete("src", S),
%  S2 = filename:join(S1),
%  filename:join(S2, pasta)

get_server_key_path() ->
    get_path("server_key").

get_client_key_path() ->
    get_path("client_key").
