
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

LIBSKRD_MOD = /home/tmw23/working/od_badch_test/skrd/libskrd.a
T2KODRD_HOME = /home/tmw23/working/t2kodrd/
T2KOD_HOME = /home/tmw23/working/t2kod/

#CXX		= g++

ROOTCFLAGS      = $(shell root-config --cflags)                                                                                                                                  
ROOTLIBS        = $(shell root-config --libs) -lMinuit

LOCAL_INC	=  -I./include -I$(T2KODRD_HOME)/core/include -I$(T2KODRD_HOME)/odclassify/include -I$(T2KODRD_HOME)/t2kodtiming/include 
LOCAL_INC	+= -I$(T2KODRD_HOME)/odxtree/include -I$(T2KODRD_HOME)/tlikelihood/include -I$(T2KODRD_HOME)/odreconobj/include
#LOCAL_INC	+= -I$(T2KOD_HOME)/samplelib/include
#LOCAL_INC	+= -I$(T2KOD_HOME)/t2kodfw/include -I$(T2KOD_HOME)/kiloplotfw/include
LOCAL_INC	+= -I$(T2KOD_HOME)/t2kod/include
LOCAL_INC	+= -I$(T2KOD_HOME)/odtrack/include
LOCAL_INC	+= $(ROOTCFLAGS)
CXXFLAGS	+= -g 
CXXFLAGS	+= $(LOCAL_INC)

#APLIB =  -lapdrlib -lpolfit -laplib -lringlib  -ltp -ltf  -lringlib -l1strd_pc \
#	 -laplib -lmsfit -lmslib -lseplib -lmsfit -lprtlib -lmuelib \
#	 -lffit -lstmu -laplowe -lpolfit -lexpq  -lska -lsofttrg \
#         -lapdrlib -lpolfit -laplib -lringlib  -ltp -ltf  -lringlib -lodlib -lmon -lprotonid

SKLIBS = -lzbs $(LIBSKRD_MOD)

# DYNAMIC
#LOCAL_LIBS = -L../lib -lt2kodrdcore -lodxtree -lodreconobj -ltlikelihood -lodclassify -lt2kodtiming -lodcsofttrigcor

# USED STATIC FOR CONSISTENCY
LOCAL_LIBS = -L.

LOCAL_LIBS += $(T2KODRD_HOME)/static/libodxtree.a
LOCAL_LIBS += $(T2KODRD_HOME)/static/libodreconobj.a
LOCAL_LIBS += $(T2KODRD_HOME)/static/libtlikelihood.a
LOCAL_LIBS += $(T2KODRD_HOME)/static/libodclassify.a
LOCAL_LIBS += $(T2KODRD_HOME)/static/libt2kodtiming.a
LOCAL_LIBS += $(T2KODRD_HOME)/static/libodcsofttrigcor.a
LOCAL_LIBS += $(T2KODRD_HOME)/static/libt2kodrdcore.a

LOCAL_LIBS += $(T2KOD_HOME)/static/libt2kod.a
LOCAL_LIBS += $(T2KOD_HOME)/static/libodgeotools.a
LOCAL_LIBS += $(T2KOD_HOME)/static/libodstopthru.a -llelib -lodlib
LOCAL_LIBS += $(T2KOD_HOME)/static/libdedxtable.a


LOCAL_LIBS += $(ROOTLIBS) -lMinuit

CERNLIBS = `cernlib graflib grafX11 packlib mathlib kernlib lapack3 blas`
AUTOSKLIBS = $(LDLIBS)
SYSTEMLIBS = -Wl,-z -Wl,muldefs /usr/local/sklib_g77/skofl_13a/obj//cfclos.o /usr/local/sklib_g77/skofl_13a/obj//cfget.o \
		/usr/local/sklib_g77/skofl_13a/obj//cfopei.o /usr/local/sklib_g77/skofl_13a/obj//cfput.o \
		-pthread -lm -ldl -rdynamic -lrfa  -lnsl -lm -L/opt/FJSVrdass/lib -lrfa -lsupc++ \
		-L/usr/lib/gcc/x86_64-redhat-linux/3.4.6 -L/usr/lib/gcc/x86_64-redhat-linux/3.4.6/../../../../lib64 \
		-L/usr/lib/gcc/x86_64-redhat-linux/3.4.6/../../.. -L/lib/../lib64 -L/usr/lib/../lib64 -lfrtbegin -lg2c -lm  /usr/lib64/libg2c.so.0 
#SKLIBS = -L$(ATMPD_ROOT)/lib -L$(SKOFL_ROOT)/lib -lskroot -lDataDefinition -lRoot2zbs -ltqrealroot \
#		-lloweroot -latmpdroot -lmcinfo -lsofttrgroot -lmufitpe \
#		-lskrd -lskroot -lgeom -lsklib -llibrary -lmon -lastro -liolib -lzbs -lsklib -lsofttrg -lm -lstdc++ -lzbs
SKLIBS = -L$(ATMPD_ROOT)/lib -L$(SKOFL_ROOT)/lib -lskroot -lDataDefinition -lRoot2zbs -ltqrealroot \
		-lloweroot -latmpdroot -lmcinfo -lsofttrgroot -lmufitpe \
		$(LIBSKRD_MOD) -lskroot -lgeom -lsklib -llibrary -lmon -lastro -liolib -lzbs -lsklib -lsofttrg -lm -lstdc++ -lzbs
APLIB = -lapdrlib -lpolfit -laplib -lringlib  -ltp -ltf  -lringlib -l1strd_pc -laplib \
	-lmsfit -lmslib -lseplib -lmsfit -lprtlib -lmuelib \
	-lffit -lstmu -laplowe -lpolfit -lexpq  -lska -lsofttrg \
	-lapdrlib -lpolfit -laplib -lringlib  -ltp -ltf  -lringlib -lodlib -lmon -lprotonid
#LDLIBS = $(SYSTEMLIBS) $(ROOTLIBS) $(CERNLIBS) $(SKLIBS)
LDLIBS = $(LOCAL_LIBS) $(APLIB) $(SKLIBS) $(CERNLIBS) $(SYSTEMLIBS) $(ROOTLIBS) 
#$(LOCAL_LIBS)  -L$(ATMPD_ROOT)/lib -L$(SKOFL_ROOT)/lib $(SKLIBS) $(CERNLIBS) $(ROOTLIBS)  

TARGETS = libt2kodreduc libt2kruninfo test_reduction test_runinfo run_t2kodreduc
T2KINFO_OBJ = T2KRunInfo.o rootdictinfo.o SKsumClass.o SKbeamClass.o bsdclass.o t2kodreducC.o
REDUC_OBJ = t2kodreduc_init.o t2kodreduc_definebranches.o t2kodreduc_event.o
REDUC_OBJ += t2kodreduc_baselinecut.o t2kodreduc_od1cut.o t2kodreduc_od2cut.o t2kodreduc_odTcut.o t2kodreduc_printevent.o t2kodreduc_writetree.o



all: $(TARGETS)

%.o: ./src/%.cc ./include/*.hh
	$(CXX) -c $(CXXFLAGS) -o $@ ./src/$*.cc
%.o: ./src/%.C ./include/*.h
	$(CXX) -c $(CXXFLAGS) -o $@ ./src/$*.C
libt2kodreduc: $(REDUC_OBJ) 
	LD_RUN_PATH=$(LIBDIR):$(SKOFL_LIBDIR) $(CXX) $(CXXFLAGS) -shared $^ -o $@.so
libt2kruninfo: $(T2KINFO_OBJ) 
	LD_RUN_PATH=$(LIBDIR):$(SKOFL_LIBDIR) $(CXX) $(CXXFLAGS) -shared $^ -o $@.so
rootdictinfo.o: include/SKsumClass.h include/SKbeamClass.h include/bsdclass.h
	rootcint -f rootcint/rootdictInfoClasses.cc -c include/SKsumClass.h include/SKbeamClass.h include/bsdclass.h rootcint/LinkDefInfoClasses.h
	$(CXX) -c $(CXXFLAGS) ./rootcint/rootdictInfoClasses.cc -o rootdictinfo.o
test_reduction: test_reduction.o libt2kodreduc
	LD_RUN_PATH=$(LIBDIR):$(SKOFL_LIBDIR) $(CXX) $(CXXFLAGS) $< -L. -lt2kodreduc -L. -lt2kruninfo $(LDLIBS) -o $@
run_t2kodreduc: run_t2kodreduc.o libt2kodreduc
	LD_RUN_PATH=$(LIBDIR):$(SKOFL_LIBDIR) $(CXX) $(CXXFLAGS) $< -L. -lt2kodreduc -L. -lt2kruninfo $(LDLIBS) -o $@
test_runinfo: test_runinfo.o
	LD_RUN_PATH=$(LIBDIR):$(SKOFL_LIBDIR) $(CXX) $(CXXFLAGS) $^ -L. -lt2kruninfo $(LDLIBS) -o $@ 

clean:: 
	$(RM) -f *.o *.so
	rm -f rootcint/rootdict.* test_reduction test_runinfo

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


