
#load BOTH ATMPD and SKOFL (gmk has both)
include $(SKOFL_ROOT)/config.gmk

#CXX		= g++

ROOTCFLAGS      = $(shell root-config --cflags)                                                                                                                                  
ROOTLIBS        = $(shell root-config --libs)

LOCAL_INC	= -I./include -I./softtrg
LOCAL_INC	+= $(ROOTCFLAGS)
#CXXFLAGS 	+= -pg -Wall
CXXFLAGS	+= $(LOCAL_INC)

APLIBS_ZBS =  -lzbs

OBJS = fort_fopen.o defaultrootstyle.o openzbs.o gcresultsC.o gradclusterC.o inpmt_usemisch.o
SRC = ./src

JOBS = libskctools

all: $(JOBS)

%.o: $(SRC)/%.cc
	$(CXX) -c $(CXXFLAGS) -o $@ $(SRC)/$*.cc
%.o: $(SRC)/%.C
	$(CXX) -c $(CXXFLAGS) -o $@ $(SRC)/$*.C
%.o: $(SRC)/%.F
	$(F77) -c $(FFLAGS) -o $@ $(SRC)/$*.F
libskctools: $(OBJS)
	ar clq libskctools.a $^
	ranlib libskctools.a

clean:: 
	$(RM) *.o *.a *.so

install.exec:: 

setup::

includes::

install.includes::

depend::

lib::
	$(OBJECTS)

install.lib::

exec:: 

install.exec:: 


