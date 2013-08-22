
#
# In case of building locally, set SKOFL_ROOT variable 
#      setenv ATMPDL_ROOT   ... 
#  or directly set in this makefile 
# ATMPD_ROOT = /home/atmpd/skrep/08a
#

#ifndef ATMPD_ROOT
#ATMPD_ROOT = /var/phy/project/hep/neutrino/soft/skiv/atmpd
#endif

#load BOTH ATMPD and SKOFL (gmk has both)
include $(SKOFL_ROOT)/config.gmk

LIBSKRD_MOD = ../skrd/libskrd.a

#CXX		= g++

ROOTCFLAGS      = $(shell root-config --cflags)                                                                                                                                  
ROOTLIBS        = $(shell root-config --libs) -lMinuit

LOCAL_INC	=  -I./include 
LOCAL_INC 	+= -I./../skctools/include
LOCAL_INC	+= $(ROOTCFLAGS)
CXXFLAGS	+= -g 
CXXFLAGS	+= $(LOCAL_INC)

# USED STATIC FOR CONSISTENCY
LOCAL_LIBS = -L.

LOCAL_LIBS += ../skctools/libskctools.a


LOCAL_LIBS += $(ROOTLIBS) -lMinuit

CERNLIBS = `cernlib graflib grafX11 packlib mathlib kernlib lapack3 blas`
SYSTEMLIBS = -Wl,-z -Wl,muldefs $(SKOFL_ROOT)/obj//cfclos.o $(SKOFL_ROOT)/obj//cfget.o \
		$(SKOFL_ROOT)/obj//cfopei.o $(SKOFL_ROOT)/obj//cfput.o \
		-pthread -lm -ldl -rdynamic -lrfa  -lnsl -lm -L/opt/FJSVrdass/lib -lrfa -lsupc++ \
#SYSTEMLIBS += -L/usr/lib/gcc/x86_64-redhat-linux/3.4.6 -L/usr/lib/gcc/x86_64-redhat-linux/3.4.6/../../../../lib64 \
		-L/usr/lib/gcc/x86_64-redhat-linux/3.4.6/../../.. -L/lib/../lib64 -L/usr/lib/../lib64 -lfrtbegin -lg2c -lm  /usr/lib64/libg2c.so.0 
SKLIBS_MOD = -L$(ATMPD_ROOT)/lib -L$(SKOFL_ROOT)/lib -lskroot -lDataDefinition -lRoot2zbs -ltqrealroot \
		-lloweroot -latmpdroot -lmcinfo -lsofttrgroot -lmufitpe \
		$(LIBSKRD_MOD) -lskroot -lgeom -lsklib -llibrary -lmon -lastro -liolib -lzbs -lsklib -lsofttrg -lm -lstdc++ -lzbs
SKLIBS = -L$(ATMPD_ROOT)/lib -L$(SKOFL_ROOT)/lib -lskroot -lDataDefinition -lRoot2zbs -ltqrealroot \
		-lloweroot -latmpdroot -lmcinfo -lsofttrgroot -lmufitpe \
		-lskrd -lskroot -lgeom -lsklib -llibrary -lmon -lastro -liolib -lzbs -lsklib -lsofttrg -lm -lstdc++ -lzbs
APLIB = -lapdrlib -lpolfit -laplib -lringlib  -ltp -ltf  -lringlib -l1strd_pc -laplib \
	-lmsfit -lmslib -lseplib -lmsfit -lprtlib -lmuelib \
	-lffit -lstmu -laplowe -lpolfit -lexpq  -lska -lsofttrg \
	-lapdrlib -lpolfit -laplib -lringlib  -ltp -ltf  -lringlib -lodlib -lmon

LDLIBS = $(LOCAL_LIBS) $(APLIB) $(SKLIBS) $(CERNLIBS) $(SYSTEMLIBS) $(ROOTLIBS) 
LDLIBS_MOD = $(LOCAL_LIBS) $(APLIB) $(SKLIBS_MOD) $(CERNLIBS) $(SYSTEMLIBS) $(ROOTLIBS) 

TARGETS = test_nhitac_unmodified test_nhitac_modified 

FOBJS = odpc_2nd_s.o

all: $(TARGETS)

%.o: ./%.cc ./*.hh
	$(CXX) -c $(CXXFLAGS) -o $@ ./src/$*.cc
#test_nhitac_modified: test_nhitac_modified.o $(FOBJS)
#	$(CXX) $(CXXFLAGS) $(FOBJS) $< $(LDLIBS_MOD) -o $@
test_nhitac_modified: test_nhitac_modified.o $(FOBJS)
	LD_RUN_PATH= $(CXX) $(CXXFLAGS) $(FOBJS) test_nhitac_modified.o -o nhitac_modified $(LDLIBS_MOD)
test_nhitac_unmodified: test_nhitac_unmodified.o $(FOBJS)
	LD_RUN_PATH= $(CXX) $(CXXFLAGS) $(FOBJS) test_nhitac_unmodified.o -o nhitac_unmodified $(LDLIBS)
#test_nhitac_unmodified: test_nhitac_unmodified.o
#	$(CXX) $(CXXFLAGS) $< $(LDLIBS) -o $@
#test: test.o
#	$(CXX) $(CXXFLAGS) $< $(LDLIBS) -o $@

clean:: 
	$(RM) -f *.o *.so
	rm -f test_nhitac_modified test_nhitac_unmodified

install.exec:: 

setup::

includes::

install.includes::

depend::
	@echo "Auto-SK libs: ${AUTOSKLIBS}"
lib::
	$(OBJECTS)

install.lib::

exec:: 

install.exec:: 


