cc=gcc

cflags=-Wall -Wextra -Wpedantic

ldflags=-nostdlib -no-pie

all:
	$(cc) $(cflags) $(ldflags) -o divtest main.s
