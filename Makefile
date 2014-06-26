all: compile

compile:
	mkdir -p ebin
	erlc +debug_info -o ebin src/*.erl

