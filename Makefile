cflags=

ldflags=-nostdlib -no-pie

objs=main.o

link: $(objs)
	ld $(ldflags) -o divtest $(objs)

%.o: %.asm
	as $(cflags) -o $@ $<

.PHONY: clean

clean:
	rm -f $(objs) divtest
