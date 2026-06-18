CFLAGS  := -Wall -Wextra -O2 $(shell pkg-config --cflags gtk4)
LDLIBS  := $(shell pkg-config --libs gtk4)

hello: hello.c
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

run: hello
	./hello

clean:
	rm -f hello

.PHONY: run clean
