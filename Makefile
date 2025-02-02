AC=java -jar AppleCommander-linux64-gtk-1.6.0.jar
CC65_HOME=/usr


# Run 'make SYS=<target>'; or, set a SYS env.
# var. to build for another target system.
SYS ?= ebadger

# Just the usual way to find out if we're
# using cmd.exe to execute make rules.
ifneq ($(shell echo),)
  CMD_EXE = 1
endif

ifdef CMD_EXE
  NULLDEV = nul:
  DEL = -del /f
  RMDIR = rmdir /s /q
else
  NULLDEV = /dev/null
  DEL = $(RM)
  RMDIR = $(RM) -r
endif

ifdef CC65_HOME
  AS = $(CC65_HOME)/bin/ca65
  CC = $(CC65_HOME)/bin/cc65
  CL = $(CC65_HOME)/bin/cl65
  LD = $(CC65_HOME)/bin/ld65
else
  AS := $(if $(wildcard ../bin/ca65*),../bin/ca65,ca65)
  CC := $(if $(wildcard ../bin/cc65*),../bin/cc65,cc65)
  CL := $(if $(wildcard ../bin/cl65*),../bin/cl65,cl65)
  LD := $(if $(wildcard ../bin/ld65*),../bin/ld65,ld65)
endif 

all: project

project: 

	xxd -i src/bg.bin > src/bg.c

	$(CL) -t $(SYS) -O --start-addr 0x4000 -vm -m map.txt ./src/main.c -o main.a2
	$(AC) -d disk.dsk test
	$(AC) -as disk.dsk test bin < main.a2
	
	linapple 

clean:
	$(RM) *.a2
