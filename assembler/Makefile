CC = c99

CCFLAGS = -ggdb

C_FILES = shared.c
H_FILES = shared.h
LEX_FILES = Assembler.lex Assembler.y

SOURCE = $(C_FILES) $(H_FILES) $(LEX_FILES)

INTERMEDIATE = Assembler.yy.c shared.o Assembler.tab.c Assembler.output Assembler.dSYM Assembler-lex.dSYM shared.h.gch shared.* $(EXECS)

EXECS = Assembler 

all:	Assembler

Assembler:	Assembler.tab.c Assembler.yy.c shared.o Assembler.tab.h
	$(CC) $(CCFLAGS) -o Assembler Assembler.tab.c shared.o

shared.o:
	cp ../hardware/shared.* ./
	$(CC) $(CCFLAGS) -c $(C_FILES) $(H_FILES)
	rm ./shared.c ./shared.h

Assembler.yy.c:	Assembler.tab.c Assembler.tab.h
	flex -oAssembler.yy.c Assembler.lex

Assembler.tab.c:	Assembler.y shared.o
	bison -v Assembler.y

Assembler.tab.h:	Assembler.y shared.o
	bison -d Assembler.y

clean:
	rm -r $(INTERMEDIATE) core 2> /dev/null

realclean:	clean
	rm -r $(EXECS) core 2> /dev/null
