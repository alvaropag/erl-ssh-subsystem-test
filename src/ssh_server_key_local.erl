-module(ssh_server_key_local).

-behaviour(ssh_server_key_api).

-export([host_key/2, is_auth_key/3]).

%%{ok, Key} | {error, Reason}


%% This function has to load the private key for the server
%% Just re-use the function from ssh_file module...
host_key(Algorithm, DaemonOptions) ->
    ssh_file:host_key(Algorithm, DaemonOptions).

%%Return always true (I'll accept any key you send me!)
is_auth_key(Key, User, DaemonOptions) ->
    true.
