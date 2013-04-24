#Makefile for Euclid project

binary: main.o
	ldc2 -of=bin/binary obj/main.o
main.o: main.d
	ldc2 -od=obj -c main.d
clean:
	rm -f obj/* bin/*
