#       Requires System V make
#       @(#)Makefile 1.5 86/05/13
.SUFFIXES:      .o .c .c~ .h .h~
.PRECIOUS:      scclib.a
#       You'll probably want to change these.  These are used by the compilers
#       to figure out where the include files should go.
#	INCDIR will be the look up location for #include <stdio.h> ..
TARGDIR = /home/notebook/Public/work/smallCextended/lib
INCDIR = "/usr/shared/smallC/src/scc/include/"

#CC = mingw32-gcc -D_WIN32 -DMINGW -D_WIN32_WINNT=0x0610 -DUNICODE -std=gnu99
#-DDONT_INCLUDE_QUICKTIME -Dmain=wingwmain -mwindows -O2

INSTFLAGS = -DINCDIR=$(INCDIR)
   CFLAGS = '$(INSTFLAGS)' -O -ggdb

ifdef SystemRoot
   # windows
   CFLAGS = '$(INSTFLAGS)' -O
else
   ifeq ($(shell uname), Linux)
       CFLAGS = '$(INSTFLAGS)' -O
   endif
endif

SRC = initialise.c data.c error.c expr.c function.c gen.c io.c lex.c main.c preproc.c \
      primary.c stmt.c sym.c while.c code8080.c
OBJ = $(addsuffix .o, $(basename $(SRC)))

all:    scc8080

install:        all
	mv sccvax scc8080 sccas09 sccm68k $(TARGDIR)

scc8080: $(OBJ)
	$(CC) -o scc8080 $(CFLAGS) $(OBJ)

clean:
	rm -f $(OBJ) scc8080.exe scc8080

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@
