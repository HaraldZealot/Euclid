#Makefile for Euclid project
NAME = Euclid
TARGET = debug
OBJ = obj/$(TARGET)
DC = ldc2
DFLAGS = -g -O3 -d-debug -od=$(OBJ) 



all: main.o
	$(DC) $(DFLAGS) -of=bin/$(TARGET)/$(NAME) $(OBJ)/main.o
main.o: main.d
	$(DC) $(DFLAGS) -c main.d
clean:
	$(RM) obj/$(TARGET)/* bin/$(TARGET)/*
