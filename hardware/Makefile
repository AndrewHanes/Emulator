#
# Created by makemake (Sparc Sep  4 2012) on Sat Mar  8 15:11:37 2014
#

#
# Definitions
#

.SUFFIXES:
.SUFFIXES:	.a .o .c .C .cpp .s .S
.c.o:
		$(COMPILE.c) $<
.C.o:
		$(COMPILE.cc) $<
.cpp.o:
		$(COMPILE.cc) $<
.S.s:
		$(CPP) -o $*.s $<
.s.o:
		$(COMPILE.cc) $<
.c.a:
		$(COMPILE.c) -o $% $<
		$(AR) $(ARFLAGS) $@ $%
		$(RM) $%
.C.a:
		$(COMPILE.cc) -o $% $<
		$(AR) $(ARFLAGS) $@ $%
		$(RM) $%
.cpp.a:
		$(COMPILE.cc) -o $% $<
		$(AR) $(ARFLAGS) $@ $%
		$(RM) $%

CC =		c99
CXX =		CC

RM = rm -f
AR = ar
LINK.c = $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LINK.cc = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
COMPILE.c = $(CC) $(CFLAGS) $(CPPFLAGS) -c
COMPILE.cc = $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c
CPP = $(CPP) $(CPPFLAGS)
########## Default flags (redefine these with a header.mak file if desired)
CXXFLAGS =	-g -xildoff -xsb
CFLAGS =	-g
CLIBFLAGS =	-lm
CCLIBFLAGS =	
########## End of default flags


CPP_FILES =	
C_FILES =	Emulator.c shared.c
PS_FILES =	
S_FILES =	
H_FILES =	shared.h
SOURCEFILES =	$(H_FILES) $(CPP_FILES) $(C_FILES) $(S_FILES)
.PRECIOUS:	$(SOURCEFILES)
OBJFILES =	shared.o 

#
# Main targets
#

all:	Emulator


Emulator:	Emulator.o $(OBJFILES)
	$(CC) $(CFLAGS) -o Emulator Emulator.o $(OBJFILES) $(CLIBFLAGS)

#
# Dependencies
#

Emulator.o:	shared.h
shared.o:	shared.h

#
# Housekeeping
#

Archive:	archive.tgz

archive.tgz:	$(SOURCEFILES) Makefile
	tar cf - $(SOURCEFILES) Makefile | gzip > archive.tgz

clean:
	-/bin/rm $(OBJFILES) Emulator.o ptrepository SunWS_cache .sb ii_files core 2> /dev/null

realclean:        clean
	-/bin/rm -rf Emulator 
