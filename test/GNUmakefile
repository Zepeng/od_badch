
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

LIBSKRD_MOD = /home/zpli/od_badch/skrd/libskrd.a
#T2KODRD_HOME = /home/tmw23/working/t2kodrd/
#T2KOD_HOME = /home/tmw23/working/t2kod/

#CXX		= g++

ROOTCFLAGS      = $(shell root-config --cflags)                                                                                                                                  
ROOTLIBS        = $(shell root-config --libs) -lMinuit

#LOCAL_INC	=  -I./include -I$(T2KODRD_HOME)/core/include -I$(T2KODRD_HOME)/odclassify/include -I$(T2KODRD_HOME)/t2kodtiming/include 
#LOCAL_INC	+= -I$(T2KODRD_HOME)/odxtree/include -I$(T2KODRD_HOME)/tlikelihood/include -I$(T2KODRD_HOME)/odreconobj/include
#LOCAL_INC	+= -I$(T2KOD_HOME)/t2kod/include
#LOCAL_INC	+= -I$(T2KOD_HOME)/odtrack/include
LOCAL_INC	+= $(ROOTCFLAGS)
LOCAL_INC       += -I./../skctools/include

CXXFLAGS	+= -g 
#CXXFLAGS	+= $(LOCAL_INC)

# USED STATIC FOR CONSISTENCY
LOCAL_LIBS = -L.
LOCAL_LIBS += ../skctools/libskctools.a

#LOCAL_LIBS += $(T2KODRD_HOME)/static/libodxtree.a
#LOCAL_LIBS += $(T2KODRD_HOME)/static/libodreconobj.a
#LOCAL_LIBS += $(T2KODRD_HOME)/static/libtlikelihood.a
#LOCAL_LIBS += $(T2KODRD_HOME)/static/libodclassify.a
#LOCAL_LIBS += $(T2KODRD_HOME)/static/libt2kodtiming.a
#LOCAL_LIBS += $(T2KODRD_HOME)/static/libodcsofttrigcor.a
#LOCAL_LIBS += $(T2KODRD_HOME)/static/libt2kodrdcore.a

#LOCAL_LIBS += $(T2KOD_HOME)/static/libt2kod.a
#LOCAL_LIBS += $(T2KOD_HOME)/static/libodgeotools.a
#LOCAL_LIBS += $(T2KOD_HOME)/static/libodstopthru.a -llelib -lodlib
#LOCAL_LIBS += $(T2KOD_HOME)/static/libdedxtable.a


LOCAL_LIBS += $(ROOTLIBS) -lMinuit

CERNLIBS = `cernlib graflib grafX11 packlib mathlib kernlib lapack3 blas`
SYSTEMLIBS = -Wl,-z -Wl,muldefs /usr/local/sklib_g77/skofl_13a/obj//cfclos.o /usr/local/sklib_g77/skofl_13a/obj//cfget.o \
		/usr/local/sklib_g77/skofl_13a/obj//cfopei.o /usr/local/sklib_g77/skofl_13a/obj//cfput.o \
		-pthread -lm -ldl -rdynamic -lrfa  -lnsl -lm -L/opt/FJSVrdass/lib -lrfa -lsupc++ \
		-L/usr/lib/gcc/x86_64-redhat-linux/3.4.6 -L/usr/lib/gcc/x86_64-redhat-linux/3.4.6/../../../../lib64 \
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
	-lapdrlib -lpolfit -laplib -lringlib  -ltp -ltf  -lringlib -lodlib -lmon -lprotonid

LDLIBS = $(LOCAL_LIBS) $(APLIB) $(SKLIBS) $(CERNLIBS) $(SYSTEMLIBS) $(ROOTLIBS) 
LDLIBS_MOD = $(LOCAL_LIBS) $(APLIB) $(SKLIBS_MOD) $(CERNLIBS) $(SYSTEMLIBS) $(ROOTLIBS) 

TARGETS = test_nhitac_unmodified test_nhitac_modified
FOBJS = odpc_2nd_s.o

all: $(TARGETS)

%.o: ./%.cc ./*.hh
	$(CXX) -c $(CXXFLAGS) -o $@ ./src/$*.cc
#test_nhitac_modified: test_nhitac_modified.o
#	$(CXX) $(CXXFLAGS) $< $(LDLIBS_MOD) -o $@
#test_nhitac_unmodified: test_nhitac_unmodified.o
#	$(CXX) $(CXXFLAGS) $< $(LDLIBS) -o $@
test_nhitac_modified: test_nhitac_modified.o $(FOBJS)
	    LD_RUN_PATH= $(CXX) $(CXXFLAGS) $(FOBJS) test_nhitac_modified.o -o nhitac_modified $(LDLIBS_MOD)
test_nhitac_unmodified: test_nhitac_modified.o $(FOBJS)
		LD_RUN_PATH= $(CXX) $(CXXFLAGS) $(FOBJS) test_nhitac_modified.o -o nhitac_unmodified $(LDLIBS)

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


