all: compile

compile:
	erlc +debug_info -o ebin src/*.erl

