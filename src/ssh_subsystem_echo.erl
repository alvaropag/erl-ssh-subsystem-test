-module(ssh_subsystem_echo).


%% Implement the ssh_daemon_channel behaviour (it's simpler than the ssh_channel)
-behaviour(ssh_daemon_channel).


-export([subsystem_spec/1]).
-export([init/1, handle_ssh_msg/2, handle_msg/2, terminate/2]).


-record(state, {cm,   %%Connection _ConnectionManager
		chid} %%Channel ID
       ).



%%The subsystem spec is a name for your subsystem, it MUST have a '@' signal in the name
subsystem_spec(Options) ->
    {"test@subsystem", {?MODULE, Options}}.
    
    
init(Options) ->
  State = #state{},
  {ok, State}.
  

handle_ssh_msg({ssh_cm, _ConnectionManager,
		{data, _ChannelId, Type, Data}}, State) ->
    error_logger:info_msg("ssh_cm.data, ConnectionManager=~p, ChannelId=~p, Type=~p, Data=~s, State=~p~n", [_ConnectionManager, _ChannelId, Type, Data, State]),
    State1 = handle_data(Type, Data, State),
    {ok, State1};

handle_ssh_msg({ssh_cm, _, {eof, ChannelId}}, State) ->
    error_logger:info_msg("ssh_cm.eof, ChannelId=~p, State=~p~n", [ChannelId, State]),
    {stop, ChannelId, State};

handle_ssh_msg({ssh_cm, _, {signal, _, _}}, State) ->
    %% Ignore signals according to RFC 4254 section 6.9.
    error_logger:info_msg("ssh_cm.signal, State=~p~n", [State]),
    {ok, State};
 
handle_ssh_msg({ssh_cm, _, {exit_signal, ChannelId, _, Error, _}}, State) ->
    Report = io_lib:format("Connection closed by peer ~n Error ~p~n",
			   [Error]),
    error_logger:error_report(Report),
    {stop, ChannelId,  State};

handle_ssh_msg({ssh_cm, _, {exit_status, ChannelId, 0}}, State) ->
    error_logger:info_msg("ssh_cm.exit, ChannelId=~p, State=~p~n", [ChannelId, State]),
    {stop, ChannelId, State};

handle_ssh_msg({ssh_cm, _, {exit_status, ChannelId, Status}}, State) ->
    
    Report = io_lib:format("Connection closed by peer ~n Status ~p~n",
			   [Status]),
    error_logger:error_report(Report),
    {stop, ChannelId, State}.

handle_msg({ssh_channel_up, ChannelId, ConnectionManager}, State) ->
    error_logger:info_msg("ssh_channel_up, ChannelId=~p, ConnectioManager=~p, State=~p~n", [ChannelId, ConnectionManager, State]),
    {ok, #state{chid = ChannelId,
		     cm = ConnectionManager}}.    
		     
handle_data(Type, Data, State) ->
  %%io:fwrite("Type=~s, Data=~s, State=~s", [Type, Data, State]).
    io:fwrite("Data=~s, Type=~p, State=~p~n", [Data, Type, State]),
    io:fwrite("I received the DATA = ~s~n", [Data]),
    State.

terminate(Reason, State) ->
    error_logger:info_msg("terminate, Reason=~p, State=~p~n", [Reason, State]),
    ok. 

  
