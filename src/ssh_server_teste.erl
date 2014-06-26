-module(ssh_server_teste).

-export([do_server_test/0]).

do_server_test() ->
    %% Start the ssh application
    ssh:start(),
    
    %% Load the subsystem spec for the "test@subsystem" service
    SubSystemSpec = ssh_subsystem_echo:subsystem_spec([]),

    KeyPath = ssh_utils:get_server_key_path(),
    
    %% Define the options for the ssh daemon
    Options = [
	       {auth_methods,"publickey"}, 
	       {user_dir, KeyPath}, 
	       {system_dir, KeyPath}, 
	       {key_cb, ssh_server_key_local} %% Define the ssh_server_key_api callback module
	      ],

    %% Start the ssh daemon
    SSHDaemonRef = ssh:daemon(1884, [{subsystems, [SubSystemSpec]} | Options]).
