.default: integration

integration: Main.hs
	ghc Main.hs -o integration

run: integration
	./integration

clean:
	rm integration
	rm Main.o
	rm Main.hi
