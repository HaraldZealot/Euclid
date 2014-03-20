#Makefile for Euclid project
NAME = Euclid
TARGET = debug
SOURCES = main.d euclidnumber.d
OBJECTS = $(OBJDIR)/$(SOURCES:.d=.o)
UNITTESTS = unittests/$(SOURCES:.d=.ut)
BINDIR = bin/$(TARGET)
OBJDIR = obj/$(TARGET)
DC = ldc2
DFLAGS = -g -d-debug  -od=$(OBJDIR)

all: $(BINDIR)/$(NAME)

$(BINDIR)/$(NAME): $(OBJECTS)
	mkdir -p $(BINDIR)
	$(DC) $(DFLAGS) -of=$(BINDIR)/$(NAME) $(OBJECTS)

run: $(BINDIR)/$(NAME)
	./$(BINDIR)/$(NAME)

unittests: $(UNITTESTS)
	./$<

unittests/%.ut:  %.d
	$(DC) -unittest -main -od=obj/unittest -of=$@ $<
	rm obj/unittest/*

$(OBJDIR)/%.o: %.d
	$(DC) $(DFLAGS)  -c $<

clean:
	rm -rf obj/ bin/ unittests/
