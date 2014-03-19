#Makefile for Euclid project
NAME = Euclid
TARGET = debug
SOURCES = main.d
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

unittests/%.ut: %.d
	$(DC) -unittest -od=obj/unittest -oq -of=$@ $<

$(OBJDIR)/%.o: %.d
	$(DC) $(DFLAGS)  -c $<

clean:
	rm -rf obj/ bin/
