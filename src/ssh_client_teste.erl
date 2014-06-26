-module(ssh_client_teste).

-export([do_test/0, do_test/1]).


do_test() ->
  do_test("DEFAULT VALUE").

do_test(Valor) ->
  %% Start the ssh application
  ssh:start(),

  KeyPath = ssh_utils:get_client_key_path(),
  
  %% Open a connection with the server
  {ok, ConnectionRef} = ssh:connect("localhost", 1884, [{user_dir, KeyPath}, {silently_accept_hosts, true}]),
   
  %% Open the channel inside the connection (SSH support multiplexed channels inside a connection)
  {ok, ChannelId} = ssh_connection:session_channel(ConnectionRef, infinity),

  %% Change the channel to access a subsystem called "test@subsystem"
  success = ssh_connection:subsystem(ConnectionRef, ChannelId, "test@subsystem", infinity),
  
  %% Send Data to the subsystem
  %% This data will be printed only in the server stdout
  ok = ssh_connection:send(ConnectionRef, ChannelId, Valor, infinity),
  
  %% Stop the ssh application
  ssh:stop(),
  
  ok.


